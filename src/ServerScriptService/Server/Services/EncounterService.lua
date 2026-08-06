--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local CreatureDataRegistry = require(ReplicatedStorage.Shared.Config.CreatureDataRegistry)
local RemoteNames = require(ReplicatedStorage.Shared.Constants.RemoteNames)
local WorldTypes = require(ReplicatedStorage.Shared.Types.WorldTypes)
local CombatDamageCalculator = require(ReplicatedStorage.Shared.Utils.CombatDamageCalculator)
local ElementEffectiveness = require(ReplicatedStorage.Shared.Utils.ElementEffectiveness)
local WildLifecycle = require(ReplicatedStorage.Shared.Utils.WildLifecycle)
local CompanionService = require(script.Parent.CompanionService)
local RegionalWildService = require(script.Parent.RegionalWildService)
local StarterSelectionService = require(script.Parent.StarterSelectionService)
local RemoteFactory = require(script.Parent.Parent.Systems.RemoteFactory)

type EncounterSnapshot = WorldTypes.EncounterSnapshot
type WildCreatureRecord = WorldTypes.WildCreatureRecord

type EncounterRecord = {
    id: string,
    wildId: string,
    companionCreatureId: string,
    companionHealth: number,
    companionMaximumHealth: number,
    nextCompanionAttackAt: number,
    nextWildAttackAt: number,
}

local BASIC_ATTACK_POWER = 6
local recordsByPlayer: { [Player]: EncounterRecord } = {}
local encounterSequence = 0
local worldUpdatedRemote: RemoteEvent? = nil

local EncounterService = {}

local function getRootPosition(player: Player): Vector3?
    local character = player.Character
    local humanoid = if character == nil then nil else character:FindFirstChildOfClass("Humanoid")
    local root = if character == nil then nil else character:FindFirstChild("HumanoidRootPart")
    if humanoid == nil or humanoid.Health <= 0 or root == nil or not root:IsA("BasePart") then
        return nil
    end
    return root.Position
end

function EncounterService.getSnapshot(player: Player): EncounterSnapshot
    local encounter = recordsByPlayer[player]
    local starterId = StarterSelectionService.getSelectedStarterId(player)
    if encounter == nil then
        local maximumHealth: number? = nil
        if starterId ~= nil then
            local definition = CreatureDataRegistry.getCreature(starterId)
            maximumHealth = if definition == nil then nil else definition.baseStats.maxHealth
        end
        return {
            encounterId = nil,
            state = "Exploring",
            wildId = nil,
            wildCreatureId = nil,
            wildHealth = nil,
            wildMaximumHealth = nil,
            companionCreatureId = starterId,
            companionHealth = maximumHealth,
            companionMaximumHealth = maximumHealth,
        }
    end
    local wild = RegionalWildService.get(encounter.wildId)
    if wild == nil or wild.state == "Despawned" then
        return {
            encounterId = nil,
            state = "Exploring",
            wildId = nil,
            wildCreatureId = nil,
            wildHealth = nil,
            wildMaximumHealth = nil,
            companionCreatureId = encounter.companionCreatureId,
            companionHealth = encounter.companionHealth,
            companionMaximumHealth = encounter.companionMaximumHealth,
        }
    end
    return {
        encounterId = encounter.id,
        state = wild.state,
        wildId = wild.id,
        wildCreatureId = wild.creatureId,
        wildHealth = wild.currentHealth,
        wildMaximumHealth = wild.maximumHealth,
        companionCreatureId = encounter.companionCreatureId,
        companionHealth = encounter.companionHealth,
        companionMaximumHealth = encounter.companionMaximumHealth,
    }
end

function EncounterService.publish(player: Player)
    if worldUpdatedRemote ~= nil and player.Parent == Players then
        worldUpdatedRemote:FireClient(player, EncounterService.getSnapshot(player))
    end
end

local function clearEncounter(player: Player, returnWild: boolean)
    local encounter = recordsByPlayer[player]
    if encounter == nil then
        return
    end
    if returnWild then
        RegionalWildService.beginReturning(encounter.wildId)
    end
    recordsByPlayer[player] = nil
    CompanionService.setCombatTarget(player, nil)
    EncounterService.publish(player)
end

local function beginNearestEncounter(player: Player, companionPosition: Vector3)
    local starterId = StarterSelectionService.getSelectedStarterId(player)
    local rootPosition = getRootPosition(player)
    if starterId == nil or rootPosition == nil then
        return
    end
    local nearest: WildCreatureRecord? = nil
    local nearestDistance = math.huge
    for _, wild in RegionalWildService.getAll() do
        if wild.state ~= "Idle" then
            continue
        end
        local zone = RegionalWildService.getZone(wild.id)
        if zone == nil then
            continue
        end
        local canStart = WildLifecycle.canStartEngagement(
            wild,
            rootPosition,
            companionPosition,
            math.max(zone.aggroRange, zone.engagementRange),
            zone.disengageRange
        )
        if not canStart then
            continue
        end
        local distance = (wild.position - companionPosition).Magnitude
        if distance < nearestDistance then
            nearest = wild
            nearestDistance = distance
        end
    end
    if nearest == nil then
        return
    end
    local starter = CreatureDataRegistry.getCreature(starterId)
    assert(starter ~= nil, `Selected starter is missing from registry: {starterId}`)
    encounterSequence += 1
    local encounterId = `world-{player.UserId}-{encounterSequence}`
    local started =
        RegionalWildService.beginEngagement(nearest.id, encounterId, player.UserId, nearestDistance)
    if not started then
        return
    end
    local currentTime = os.clock()
    local zone = RegionalWildService.getZone(nearest.id)
    assert(zone ~= nil, `Wild creature zone is missing: {nearest.zoneId}`)
    recordsByPlayer[player] = {
        id = encounterId,
        wildId = nearest.id,
        companionCreatureId = starterId,
        companionHealth = starter.baseStats.maxHealth,
        companionMaximumHealth = starter.baseStats.maxHealth,
        nextCompanionAttackAt = currentTime + zone.attackIntervalSeconds,
        nextWildAttackAt = currentTime + zone.attackIntervalSeconds,
    }
    CompanionService.setCombatTarget(player, nearest.position)
    EncounterService.publish(player)
end

local function calculateDamage(
    attackerCreatureId: string,
    attackerAttack: number,
    defenderCreatureId: string,
    defenderDefense: number
): number
    local attacker = CreatureDataRegistry.getCreature(attackerCreatureId)
    local defender = CreatureDataRegistry.getCreature(defenderCreatureId)
    assert(attacker ~= nil and defender ~= nil, "Encounter creatures must exist in the registry")
    local multiplier, multiplierError =
        ElementEffectiveness.getMultiplier(attacker.elementId, defender.elementId)
    assert(multiplier ~= nil, multiplierError or "Encounter element chart is invalid")
    return CombatDamageCalculator.calculateDamage({
        attack = attackerAttack,
        defense = defenderDefense,
        basePower = BASIC_ATTACK_POWER,
        elementMultiplier = multiplier,
    })
end

local function updateEncounter(
    player: Player,
    encounter: EncounterRecord,
    deltaTime: number,
    currentTime: number
)
    local rootPosition = getRootPosition(player)
    local companionPosition = CompanionService.getPosition(player)
    local wild = RegionalWildService.get(encounter.wildId)
    local zone = RegionalWildService.getZone(encounter.wildId)
    if rootPosition == nil or companionPosition == nil or wild == nil or zone == nil then
        clearEncounter(player, true)
        return
    end
    if
        wild.state ~= "Engaging"
        or wild.encounterId ~= encounter.id
        or wild.targetUserId ~= player.UserId
    then
        clearEncounter(player, false)
        return
    end
    if
        WildLifecycle.shouldDisengage(
            wild,
            rootPosition,
            companionPosition,
            zone.disengageRange,
            zone.leashRange
        )
    then
        clearEncounter(player, true)
        return
    end
    CompanionService.setCombatTarget(player, wild.position)
    local distance = (wild.position - companionPosition).Magnitude
    if distance > zone.attackRange * 0.75 then
        RegionalWildService.setPosition(
            wild.id,
            WildLifecycle.stepToward(wild.position, companionPosition, zone.moveSpeed, deltaTime)
        )
        wild = RegionalWildService.get(encounter.wildId) :: WildCreatureRecord
        distance = (wild.position - companionPosition).Magnitude
    end
    local stateChanged = false
    if distance <= zone.attackRange and currentTime >= encounter.nextCompanionAttackAt then
        local companionDefinition = CreatureDataRegistry.getCreature(encounter.companionCreatureId)
        assert(companionDefinition ~= nil, "Companion definition is missing")
        encounter.nextCompanionAttackAt = currentTime + zone.attackIntervalSeconds
        local damage = calculateDamage(
            encounter.companionCreatureId,
            companionDefinition.baseStats.attack,
            wild.creatureId,
            wild.defense
        )
        stateChanged = true
        if RegionalWildService.applyDamage(wild.id, damage) then
            clearEncounter(player, false)
            return
        end
    end
    if distance <= zone.attackRange and currentTime >= encounter.nextWildAttackAt then
        local companionDefinition = CreatureDataRegistry.getCreature(encounter.companionCreatureId)
        assert(companionDefinition ~= nil, "Companion definition is missing")
        encounter.nextWildAttackAt = currentTime + zone.attackIntervalSeconds
        local damage = calculateDamage(
            wild.creatureId,
            wild.attack,
            encounter.companionCreatureId,
            companionDefinition.baseStats.defense
        )
        encounter.companionHealth = math.max(0, encounter.companionHealth - damage)
        stateChanged = true
        if encounter.companionHealth == 0 then
            clearEncounter(player, true)
            return
        end
    end
    if stateChanged then
        EncounterService.publish(player)
    end
end

function EncounterService.validateCaptureTarget(
    player: Player,
    encounterId: string,
    wildId: string,
    maximumDistance: number
): (WildCreatureRecord?, string?)
    local encounter = recordsByPlayer[player]
    if encounter == nil or encounter.id ~= encounterId or encounter.wildId ~= wildId then
        return nil, "ENCOUNTER_NOT_FOUND"
    end
    local rootPosition = getRootPosition(player)
    local wild = RegionalWildService.get(wildId)
    if rootPosition == nil or wild == nil then
        return nil, "TARGET_NOT_FOUND"
    end
    local distance = (rootPosition - wild.position).Magnitude
    local valid =
        WildLifecycle.validateTarget(wild, encounterId, player.UserId, distance, maximumDistance)
    if not valid then
        return nil, "TARGET_INVALID"
    end
    if wild.currentHealth >= wild.maximumHealth then
        return nil, "TARGET_NOT_WEAKENED"
    end
    return wild, nil
end

function EncounterService.completeCapture(
    player: Player,
    encounterId: string,
    wildId: string
): boolean
    local encounter = recordsByPlayer[player]
    if encounter == nil or encounter.id ~= encounterId or encounter.wildId ~= wildId then
        return false
    end
    if not RegionalWildService.capture(wildId) then
        return false
    end
    recordsByPlayer[player] = nil
    CompanionService.setCombatTarget(player, nil)
    EncounterService.publish(player)
    return true
end

function EncounterService.start()
    worldUpdatedRemote = RemoteFactory.getEvent(RemoteNames.WORLD_UPDATED)
    local getWorldRemote = RemoteFactory.getFunction(RemoteNames.GET_WORLD_STATE)
    getWorldRemote.OnServerInvoke = function(player: Player): EncounterSnapshot
        return EncounterService.getSnapshot(player)
    end
    RunService.Heartbeat:Connect(function(deltaTime)
        local currentTime = os.clock()
        for _, player in Players:GetPlayers() do
            local encounter = recordsByPlayer[player]
            if encounter ~= nil then
                updateEncounter(player, encounter, deltaTime, currentTime)
            else
                local companionPosition = CompanionService.getPosition(player)
                if companionPosition ~= nil then
                    beginNearestEncounter(player, companionPosition)
                end
            end
        end
    end)
    Players.PlayerRemoving:Connect(function(player)
        clearEncounter(player, true)
        recordsByPlayer[player] = nil
    end)
end

return table.freeze(EncounterService)
