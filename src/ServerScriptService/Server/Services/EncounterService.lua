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
local HomeService = require(script.Parent.HomeService)
local RegionalWildService = require(script.Parent.RegionalWildService)
local StarterSelectionService = require(script.Parent.StarterSelectionService)
local RemoteFactory = require(script.Parent.Parent.Systems.RemoteFactory)

type EncounterSnapshot = WorldTypes.EncounterSnapshot
type EncounterWildSnapshot = WorldTypes.EncounterWildSnapshot
type WildCreatureRecord = WorldTypes.WildCreatureRecord

type EncounterRecord = {
    id: string,
    wildIds: { string },
    companionCreatureId: string,
    nextCompanionAttackAt: number,
    nextWildAttackAtById: { [string]: number },
}

local BASIC_ATTACK_POWER = 6
local recordsByPlayer: { [Player]: EncounterRecord } = {}
local companionHealthByPlayer: { [Player]: number } = {}
local companionMaximumHealthByPlayer: { [Player]: number } = {}
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

local function sortedWilds(wilds: { WildCreatureRecord }): { WildCreatureRecord }
    table.sort(wilds, function(left, right)
        return left.id < right.id
    end)
    return wilds
end

local function ensureCompanionHealth(player: Player, creatureId: string): (number, number)
    local definition = CreatureDataRegistry.getCreature(creatureId)
    assert(definition ~= nil, `Companion definition is missing: {creatureId}`)
    local maximumHealth = definition.baseStats.maxHealth
    companionMaximumHealthByPlayer[player] = maximumHealth
    if companionHealthByPlayer[player] == nil then
        companionHealthByPlayer[player] = maximumHealth
    end
    return companionHealthByPlayer[player], maximumHealth
end

local function healCompanionAtSafeZone(player: Player): boolean
    local starterId = StarterSelectionService.getSelectedStarterId(player)
    local rootPosition = getRootPosition(player)
    if starterId == nil or rootPosition == nil or not HomeService.isInSafeZone(rootPosition) then
        return false
    end
    local _, maximumHealth = ensureCompanionHealth(player, starterId)
    if companionHealthByPlayer[player] == maximumHealth then
        return false
    end
    companionHealthByPlayer[player] = maximumHealth
    return true
end

local function makeWildSnapshots(
    wilds: { WildCreatureRecord }
): ({ EncounterWildSnapshot }, { string })
    local snapshots: { EncounterWildSnapshot } = {}
    local captureEligibleWildIds: { string } = {}
    for _, wild in sortedWilds(wilds) do
        table.insert(snapshots, {
            wildId = wild.id,
            creatureId = wild.creatureId,
            health = wild.currentHealth,
            maximumHealth = wild.maximumHealth,
            state = wild.state,
            isCaptureLocked = wild.captureLockRequestId ~= nil,
        })
        if wild.state == "Engaging" and wild.currentHealth < wild.maximumHealth then
            table.insert(captureEligibleWildIds, wild.id)
        end
    end
    return snapshots, captureEligibleWildIds
end

local function getActiveWilds(player: Player, encounter: EncounterRecord): { WildCreatureRecord }
    local wilds: { WildCreatureRecord } = {}
    local retainedWildIds: { string } = {}
    for _, wildId in encounter.wildIds do
        local wild = RegionalWildService.get(wildId)
        if
            wild ~= nil
            and wild.state == "Engaging"
            and wild.encounterId == encounter.id
            and WildLifecycle.hasParticipant(wild, player.UserId)
        then
            table.insert(wilds, wild)
            table.insert(retainedWildIds, wild.id)
        end
    end
    encounter.wildIds = retainedWildIds
    return sortedWilds(wilds)
end

function EncounterService.getSnapshot(player: Player): EncounterSnapshot
    local encounter = recordsByPlayer[player]
    local starterId = StarterSelectionService.getSelectedStarterId(player)
    if encounter == nil then
        local companionHealth: number? = nil
        local maximumHealth: number? = nil
        if starterId ~= nil then
            companionHealth, maximumHealth = ensureCompanionHealth(player, starterId)
        end
        return {
            encounterId = nil,
            state = "Exploring",
            wildId = nil,
            wildCreatureId = nil,
            wildHealth = nil,
            wildMaximumHealth = nil,
            wilds = {},
            captureEligibleWildIds = {},
            companionCreatureId = starterId,
            companionHealth = companionHealth,
            companionMaximumHealth = maximumHealth,
        }
    end

    local wilds = getActiveWilds(player, encounter)
    if #wilds == 0 then
        recordsByPlayer[player] = nil
        CompanionService.setCombatTarget(player, nil)
        return {
            encounterId = nil,
            state = "Exploring",
            wildId = nil,
            wildCreatureId = nil,
            wildHealth = nil,
            wildMaximumHealth = nil,
            wilds = {},
            captureEligibleWildIds = {},
            companionCreatureId = encounter.companionCreatureId,
            companionHealth = companionHealthByPlayer[player],
            companionMaximumHealth = companionMaximumHealthByPlayer[player],
        }
    end

    local primaryWild = wilds[1]
    local wildSnapshots, captureEligibleWildIds = makeWildSnapshots(wilds)
    return {
        encounterId = encounter.id,
        state = "Engaging",
        wildId = primaryWild.id,
        wildCreatureId = primaryWild.creatureId,
        wildHealth = primaryWild.currentHealth,
        wildMaximumHealth = primaryWild.maximumHealth,
        wilds = wildSnapshots,
        captureEligibleWildIds = captureEligibleWildIds,
        companionCreatureId = encounter.companionCreatureId,
        companionHealth = companionHealthByPlayer[player],
        companionMaximumHealth = companionMaximumHealthByPlayer[player],
    }
end

function EncounterService.publish(player: Player)
    if worldUpdatedRemote ~= nil and player.Parent == Players then
        worldUpdatedRemote:FireClient(player, EncounterService.getSnapshot(player))
    end
end

function EncounterService.publishEncounter(encounterId: string)
    for player, encounter in recordsByPlayer do
        if encounter.id == encounterId then
            EncounterService.publish(player)
        end
    end
end

local function clearEncounter(player: Player, returnWild: boolean)
    local encounter = recordsByPlayer[player]
    if encounter == nil then
        return
    end
    local encounterId = encounter.id
    for _, wildId in encounter.wildIds do
        RegionalWildService.removeParticipant(wildId, player.UserId)
        if returnWild and not RegionalWildService.hasParticipants(wildId) then
            RegionalWildService.beginReturning(wildId)
        end
    end
    recordsByPlayer[player] = nil
    CompanionService.setCombatTarget(player, nil)
    EncounterService.publish(player)
    EncounterService.publishEncounter(encounterId)
end

local function canPlayerReachWild(
    player: Player,
    wild: WildCreatureRecord,
    rootPosition: Vector3,
    companionPosition: Vector3
): boolean
    local zone = RegionalWildService.getZone(wild.id)
    if zone == nil then
        return false
    end
    if wild.state == "Idle" then
        local canStart = WildLifecycle.canStartEngagement(
            wild,
            rootPosition,
            companionPosition,
            math.max(zone.aggroRange, zone.engagementRange),
            zone.disengageRange
        )
        return canStart
    end
    if wild.state == "Engaging" and not WildLifecycle.hasParticipant(wild, player.UserId) then
        return (wild.position - companionPosition).Magnitude <= math.max(zone.aggroRange, zone.engagementRange)
            and (rootPosition - wild.position).Magnitude <= zone.disengageRange
    end
    return false
end

local function findNearestJoinableWild(
    player: Player,
    rootPosition: Vector3,
    companionPosition: Vector3
): WildCreatureRecord?
    local nearest: WildCreatureRecord? = nil
    local nearestDistance = math.huge
    for _, wild in RegionalWildService.getAll() do
        if not canPlayerReachWild(player, wild, rootPosition, companionPosition) then
            continue
        end
        local distance = (wild.position - companionPosition).Magnitude
        if distance < nearestDistance then
            nearest = wild
            nearestDistance = distance
        end
    end
    return nearest
end

local function beginNearestEncounter(player: Player, companionPosition: Vector3)
    local starterId = StarterSelectionService.getSelectedStarterId(player)
    local rootPosition = getRootPosition(player)
    if starterId == nil or rootPosition == nil or (companionHealthByPlayer[player] or 1) <= 0 then
        return
    end
    local nearest = findNearestJoinableWild(player, rootPosition, companionPosition)
    if nearest == nil then
        return
    end
    local starter = CreatureDataRegistry.getCreature(starterId)
    assert(starter ~= nil, `Selected starter is missing from registry: {starterId}`)
    ensureCompanionHealth(player, starterId)

    local encounterId: string?
    local candidates = RegionalWildService.getBySpawnGroup(nearest.spawnGroupId)
    if nearest.state == "Engaging" and nearest.encounterId ~= nil then
        encounterId = nearest.encounterId
    else
        for _, candidate in candidates do
            if candidate.state == "Engaging" and candidate.encounterId ~= nil then
                encounterId = candidate.encounterId
                break
            end
        end
    end
    if encounterId == nil then
        encounterSequence += 1
        encounterId = `world-{encounterSequence}`
    end

    local wildIds: { string } = {}
    local currentTime = os.clock()
    local nextWildAttackAtById: { [string]: number } = {}
    for _, wild in sortedWilds(candidates) do
        -- The nearest wild already passed the owner/aggro trigger. Cluster members
        -- are claimed as one encounter instead of being gated independently.
        local zone = RegionalWildService.getZone(wild.id)
        assert(zone ~= nil, `Wild creature zone is missing: {wild.zoneId}`)
        local maximumTriggerRange = math.max(zone.aggroRange, zone.engagementRange)
        local started = RegionalWildService.beginEngagement(
            wild.id,
            encounterId,
            player.UserId,
            math.min((wild.position - companionPosition).Magnitude, maximumTriggerRange)
        )
        if started then
            table.insert(wildIds, wild.id)
            nextWildAttackAtById[wild.id] = currentTime + zone.attackIntervalSeconds
        end
    end
    if #wildIds == 0 then
        return
    end
    local firstZone = RegionalWildService.getZone(wildIds[1])
    assert(firstZone ~= nil, `Wild creature zone is missing: {wildIds[1]}`)
    recordsByPlayer[player] = {
        id = encounterId,
        wildIds = wildIds,
        companionCreatureId = starterId,
        nextCompanionAttackAt = currentTime + firstZone.attackIntervalSeconds,
        nextWildAttackAtById = nextWildAttackAtById,
    }
    local firstWild = RegionalWildService.get(wildIds[1])
    CompanionService.setCombatTarget(player, if firstWild == nil then nil else firstWild.position)
    EncounterService.publish(player)
    EncounterService.publishEncounter(encounterId)
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

local function chooseCompanionTarget(
    companionPosition: Vector3,
    wilds: { WildCreatureRecord }
): WildCreatureRecord?
    local selected: WildCreatureRecord? = nil
    local selectedDistance = math.huge
    for _, wild in wilds do
        local distance = (wild.position - companionPosition).Magnitude
        if distance < selectedDistance then
            selected = wild
            selectedDistance = distance
        end
    end
    return selected
end

local function updateEncounter(
    player: Player,
    encounter: EncounterRecord,
    deltaTime: number,
    currentTime: number
)
    local rootPosition = getRootPosition(player)
    local companionPosition = CompanionService.getPosition(player)
    if rootPosition == nil or companionPosition == nil then
        clearEncounter(player, true)
        return
    end
    local companionHealth = companionHealthByPlayer[player]
    if companionHealth == nil or companionHealth <= 0 then
        clearEncounter(player, true)
        return
    end
    local wilds = getActiveWilds(player, encounter)
    if #wilds == 0 then
        clearEncounter(player, false)
        return
    end

    local nearestTarget = chooseCompanionTarget(companionPosition, wilds)
    if nearestTarget == nil then
        clearEncounter(player, false)
        return
    end

    local disengaged = true
    local stateChanged = false
    for _, wild in wilds do
        local zone = RegionalWildService.getZone(wild.id)
        if zone == nil then
            continue
        end
        local ownerLeftCompanion = (rootPosition - companionPosition).Magnitude > zone.disengageRange
        local ownerLeftWild = (rootPosition - wild.position).Magnitude > zone.disengageRange
        if not ownerLeftCompanion and not ownerLeftWild then
            disengaged = false
        end
        if (wild.position - wild.spawnPosition).Magnitude > zone.leashRange then
            RegionalWildService.removeParticipant(wild.id, player.UserId)
            if not RegionalWildService.hasParticipants(wild.id) then
                RegionalWildService.beginReturning(wild.id)
            end
            stateChanged = true
        end
    end
    if disengaged then
        clearEncounter(player, true)
        return
    end

    for _, wild in wilds do
        local zone = RegionalWildService.getZone(wild.id)
        if zone == nil then
            continue
        end
        local distance = (wild.position - companionPosition).Magnitude
        if distance > zone.attackRange * 0.75 then
            RegionalWildService.setPosition(
                wild.id,
                WildLifecycle.stepToward(
                    wild.position,
                    companionPosition,
                    zone.moveSpeed,
                    deltaTime
                )
            )
        end
    end

    local refreshedWilds = getActiveWilds(player, encounter)
    nearestTarget = chooseCompanionTarget(companionPosition, refreshedWilds)
    if nearestTarget == nil then
        clearEncounter(player, false)
        return
    end
    CompanionService.setCombatTarget(player, nearestTarget.position)
    local targetZone = RegionalWildService.getZone(nearestTarget.id)
    if targetZone ~= nil then
        local distance = (nearestTarget.position - companionPosition).Magnitude
        if distance <= targetZone.attackRange and currentTime >= encounter.nextCompanionAttackAt then
            local companionDefinition = CreatureDataRegistry.getCreature(encounter.companionCreatureId)
            assert(companionDefinition ~= nil, "Companion definition is missing")
            encounter.nextCompanionAttackAt = currentTime + targetZone.attackIntervalSeconds
            local damage = calculateDamage(
                encounter.companionCreatureId,
                companionDefinition.baseStats.attack,
                nearestTarget.creatureId,
                nearestTarget.defense
            )
            stateChanged = true
            if RegionalWildService.applyDamage(nearestTarget.id, damage) then
                EncounterService.publishEncounter(encounter.id)
                return
            end
        end
    end

    for _, wild in getActiveWilds(player, encounter) do
        local zone = RegionalWildService.getZone(wild.id)
        if zone == nil then
            continue
        end
        local distance = (wild.position - companionPosition).Magnitude
        if distance <= zone.attackRange and currentTime >= (encounter.nextWildAttackAtById[wild.id] or 0) then
            local companionDefinition = CreatureDataRegistry.getCreature(encounter.companionCreatureId)
            assert(companionDefinition ~= nil, "Companion definition is missing")
            encounter.nextWildAttackAtById[wild.id] = currentTime + zone.attackIntervalSeconds
            local damage = calculateDamage(
                wild.creatureId,
                wild.attack,
                encounter.companionCreatureId,
                companionDefinition.baseStats.defense
            )
            companionHealthByPlayer[player] = math.max(0, (companionHealthByPlayer[player] or 0) - damage)
            stateChanged = true
            if companionHealthByPlayer[player] == 0 then
                clearEncounter(player, true)
                return
            end
        end
    end
    if stateChanged then
        EncounterService.publish(player)
        EncounterService.publishEncounter(encounter.id)
    end
end

function EncounterService.validateCaptureTarget(
    player: Player,
    encounterId: string,
    wildId: string,
    maximumDistance: number
): (WildCreatureRecord?, string?)
    local encounter = recordsByPlayer[player]
    if encounter == nil or encounter.id ~= encounterId then
        return nil, "ENCOUNTER_NOT_FOUND"
    end
    local belongsToEncounter = false
    for _, encounterWildId in encounter.wildIds do
        if encounterWildId == wildId then
            belongsToEncounter = true
            break
        end
    end
    if not belongsToEncounter then
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

function EncounterService.reserveCaptureTarget(
    player: Player,
    encounterId: string,
    wildId: string,
    requestId: string,
    maximumDistance: number
): (WildCreatureRecord?, string?)
    local wild, targetError =
        EncounterService.validateCaptureTarget(player, encounterId, wildId, maximumDistance)
    if wild == nil then
        return nil, targetError
    end
    local reserved, reserveError = RegionalWildService.reserveCapture(wildId, player.UserId, requestId)
    if not reserved then
        return nil, reserveError or "TARGET_CAPTURE_LOCKED"
    end
    EncounterService.publishEncounter(encounterId)
    return wild, nil
end

function EncounterService.releaseCaptureTarget(player: Player, encounterId: string, wildId: string, requestId: string)
    RegionalWildService.releaseCapture(wildId, player.UserId, requestId)
    EncounterService.publishEncounter(encounterId)
end

function EncounterService.completeCapture(
    player: Player,
    encounterId: string,
    wildId: string
): boolean
    local encounter = recordsByPlayer[player]
    if encounter == nil or encounter.id ~= encounterId then
        return false
    end
    if not RegionalWildService.capture(wildId) then
        return false
    end
    for participant, participantEncounter in recordsByPlayer do
        if participantEncounter.id == encounterId then
            local retainedWildIds: { string } = {}
            for _, participantWildId in participantEncounter.wildIds do
                if participantWildId ~= wildId then
                    table.insert(retainedWildIds, participantWildId)
                end
            end
            participantEncounter.wildIds = retainedWildIds
            if #retainedWildIds == 0 then
                recordsByPlayer[participant] = nil
                CompanionService.setCombatTarget(participant, nil)
            end
            EncounterService.publish(participant)
        end
    end
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
                if healCompanionAtSafeZone(player) then
                    EncounterService.publish(player)
                end
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
        companionHealthByPlayer[player] = nil
        companionMaximumHealthByPlayer[player] = nil
    end)
end

return table.freeze(EncounterService)
