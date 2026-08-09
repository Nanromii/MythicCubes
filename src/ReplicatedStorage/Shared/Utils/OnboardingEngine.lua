--!strict

local OnboardingDefinitions = require(script.Parent.Parent.Config.OnboardingDefinitions)
local StarterDefinitions = require(script.Parent.Parent.Config.StarterDefinitions)
local OnboardingTypes = require(script.Parent.Parent.Types.OnboardingTypes)

type SessionState = OnboardingTypes.SessionState
type Snapshot = OnboardingTypes.Snapshot
type TransitionEvent = OnboardingTypes.TransitionEvent
type GateKind = OnboardingTypes.GateKind
type GateAction = OnboardingTypes.GateAction

local VILLAGE_LOCATION_ID = "village"

local OnboardingEngine = {}

function OnboardingEngine.createSession(ownerUserId: number): SessionState
    return {
        ownerUserId = ownerUserId,
        state = "AWAITING_STARTER",
        starterId = nil,
        selectedElementalWorldId = nil,
        locationId = VILLAGE_LOCATION_ID,
    }
end

function OnboardingEngine.canAccessWorld(state: SessionState, worldId: string): boolean
    if worldId == OnboardingDefinitions.normalWorld.id then
        return state.state ~= "AWAITING_STARTER"
    end
    return state.state == "COMPLETE" and state.selectedElementalWorldId == worldId
end

function OnboardingEngine.resolveGateAction(
    state: SessionState,
    gateKind: GateKind,
    worldId: string?
): GateAction?
    if gateKind == "return" then
        if
            (
                state.state == "TUMBLET_CAPTURED"
                and state.locationId == OnboardingDefinitions.normalWorld.id
            )
            or (state.state == "COMPLETE" and state.locationId ~= VILLAGE_LOCATION_ID)
        then
            return {
                action = "return_to_village",
                worldId = nil,
            }
        end
        return nil
    end

    if worldId == nil or OnboardingDefinitions.getWorld(worldId) == nil then
        return nil
    end
    if state.locationId ~= VILLAGE_LOCATION_ID then
        return nil
    end
    if state.state == "NORMAL_WORLD_READY" and worldId == OnboardingDefinitions.normalWorld.id then
        return {
            action = "enter_normal_world",
            worldId = nil,
        }
    end
    if state.state == "WORLD_CHOICE_READY" and OnboardingDefinitions.isElementalWorld(worldId) then
        return {
            action = "select_elemental_world",
            worldId = worldId,
        }
    end
    if state.state == "COMPLETE" and OnboardingEngine.canAccessWorld(state, worldId) then
        return {
            action = "travel_world",
            worldId = worldId,
        }
    end
    return nil
end

function OnboardingEngine.makeSnapshot(state: SessionState): Snapshot
    local accessibleWorldIds: { string } = {}
    for _, world in OnboardingDefinitions.worlds do
        if OnboardingEngine.canAccessWorld(state, world.id) then
            table.insert(accessibleWorldIds, world.id)
        end
    end
    return {
        state = state.state,
        starterId = state.starterId,
        selectedElementalWorldId = state.selectedElementalWorldId,
        locationId = state.locationId,
        accessibleWorldIds = accessibleWorldIds,
    }
end

function OnboardingEngine.setLocation(state: SessionState, locationId: string): boolean
    if locationId == VILLAGE_LOCATION_ID then
        state.locationId = locationId
        return true
    end
    if not OnboardingEngine.canAccessWorld(state, locationId) then
        return false
    end
    state.locationId = locationId
    return true
end

function OnboardingEngine.transition(
    state: SessionState,
    event: TransitionEvent,
    value: string?
): (boolean, string?)
    if event == "STARTER_SELECTED" then
        if state.state ~= "AWAITING_STARTER" or value == nil then
            return false, "WRONG_STATE"
        end
        if StarterDefinitions.getById(value) == nil then
            return false, "UNKNOWN_STARTER"
        end
        state.starterId = value
        state.state = "NORMAL_WORLD_READY"
        return true, nil
    end

    if event == "ENTER_NORMAL_WORLD" then
        if state.state ~= "NORMAL_WORLD_READY" then
            return false, "WRONG_STATE"
        end
        state.state = "NORMAL_TUTORIAL"
        state.locationId = OnboardingDefinitions.normalWorld.id
        return true, nil
    end

    if event == "CAPTURE_TUMBLET" then
        if state.state ~= "ACTIVE_SKILL_PRACTICED" then
            return false, "WRONG_STATE"
        end
        state.state = "TUMBLET_CAPTURED"
        return true, nil
    end

    if event == "PRACTICE_BASIC_ATTACK" then
        if state.state ~= "NORMAL_TUTORIAL" then
            return false, "WRONG_STATE"
        end
        state.state = "BASIC_ATTACK_PRACTICED"
        return true, nil
    end

    if event == "PRACTICE_ACTIVE_SKILL" then
        if state.state ~= "BASIC_ATTACK_PRACTICED" then
            return false, "WRONG_STATE"
        end
        state.state = "ACTIVE_SKILL_PRACTICED"
        return true, nil
    end

    if event == "RETURN_TO_VILLAGE" then
        if state.state ~= "TUMBLET_CAPTURED" then
            return false, "WRONG_STATE"
        end
        state.state = "WORLD_CHOICE_READY"
        state.locationId = VILLAGE_LOCATION_ID
        return true, nil
    end

    if event == "SELECT_ELEMENTAL_WORLD" then
        if state.state ~= "WORLD_CHOICE_READY" or value == nil then
            return false, "WRONG_STATE"
        end
        if not OnboardingDefinitions.isElementalWorld(value) then
            return false, "WORLD_NOT_SELECTABLE"
        end
        state.selectedElementalWorldId = value
        state.locationId = value
        state.state = "COMPLETE"
        return true, nil
    end

    return false, "UNKNOWN_EVENT"
end

return table.freeze(OnboardingEngine)
