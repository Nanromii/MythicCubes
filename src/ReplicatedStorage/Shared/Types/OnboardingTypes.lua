--!strict

export type StateName =
    "AWAITING_STARTER"
    | "NORMAL_WORLD_READY"
    | "NORMAL_TUTORIAL"
    | "BASIC_ATTACK_PRACTICED"
    | "ACTIVE_SKILL_PRACTICED"
    | "TUMBLET_CAPTURED"
    | "WORLD_CHOICE_READY"
    | "COMPLETE"

export type TransitionEvent =
    "STARTER_SELECTED"
    | "ENTER_NORMAL_WORLD"
    | "PRACTICE_BASIC_ATTACK"
    | "PRACTICE_ACTIVE_SKILL"
    | "CAPTURE_TUMBLET"
    | "RETURN_TO_VILLAGE"
    | "SELECT_ELEMENTAL_WORLD"

export type WorldDefinition = {
    id: string,
    displayName: string,
    elementId: string,
    displayColor: Color3,
}

export type SessionState = {
    ownerUserId: number,
    state: StateName,
    starterId: string?,
    selectedElementalWorldId: string?,
    locationId: string,
}

export type Snapshot = {
    state: StateName,
    starterId: string?,
    selectedElementalWorldId: string?,
    locationId: string,
    accessibleWorldIds: { string },
}

export type ActionName =
    "enter_normal_world"
    | "practice_basic_attack"
    | "practice_active_skill"
    | "capture_tumblet"
    | "return_to_village"
    | "select_elemental_world"
    | "travel_world"

export type GateKind = "world" | "return"

export type GateAction = {
    action: ActionName,
    worldId: string?,
}

export type ActionIntent = {
    requestId: string,
    action: ActionName,
    worldId: string?,
}

export type ActionResponse = {
    ok: boolean,
    code: string,
    message: string,
    snapshot: Snapshot,
}

return table.freeze({})
