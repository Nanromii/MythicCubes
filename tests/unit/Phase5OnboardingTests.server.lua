--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CreatureDataRegistry = require(ReplicatedStorage.Shared.Config.CreatureDataRegistry)
local OnboardingDefinitions = require(ReplicatedStorage.Shared.Config.OnboardingDefinitions)
local StarterDefinitions = require(ReplicatedStorage.Shared.Config.StarterDefinitions)
local CollectionEngine = require(ReplicatedStorage.Shared.Utils.CollectionEngine)
local OnboardingEngine = require(ReplicatedStorage.Shared.Utils.OnboardingEngine)
local OnboardingRequestValidator =
    require(ReplicatedStorage.Shared.Utils.OnboardingRequestValidator)

local passedTestCount = 0

local function pass(condition: boolean, message: string)
    assert(condition, message)
    passedTestCount += 1
end

pass(#OnboardingDefinitions.worlds == 5, "Phase 5 must expose exactly five onboarding worlds")
pass(
    OnboardingDefinitions.normalWorld.id == "origin_plains"
        and OnboardingDefinitions.normalWorld.displayName == "Bình Nguyên Khởi Sinh",
    "The shared tutorial route must use the accepted Normal world"
)
pass(
    #OnboardingDefinitions.elementalWorlds == 4,
    "World choice must contain exactly four elemental worlds"
)

local tumblet = CreatureDataRegistry.getCreature("tumblet")
pass(
    tumblet ~= nil and tumblet.elementId == "normal",
    "Tumblet must be a data-driven Normal creature"
)
pass(
    StarterDefinitions.getById("tumblet") == nil and #StarterDefinitions.list == 5,
    "Tumblet must not replace or extend the five-starter choice"
)

local validAction = OnboardingRequestValidator.validate({
    requestId = "request-1",
    action = "enter_normal_world",
})
pass(validAction ~= nil, "Exact no-world onboarding action must validate")

local validWorldChoice = OnboardingRequestValidator.validate({
    requestId = "request-2",
    action = "select_elemental_world",
    worldId = "ember_archipelago",
})
pass(
    validWorldChoice ~= nil and validWorldChoice.worldId == "ember_archipelago",
    "Exact elemental world choice must validate"
)

local invalidExtraField = OnboardingRequestValidator.validate({
    requestId = "request-3",
    action = "enter_normal_world",
    completed = true,
})
pass(invalidExtraField == nil, "Client-provided completion and extra fields must be rejected")

local invalidWorldOnCapture = OnboardingRequestValidator.validate({
    requestId = "request-4",
    action = "capture_tumblet",
    worldId = "ember_archipelago",
})
pass(invalidWorldOnCapture == nil, "Actions must reject fields outside their exact shape")

local invalidAction = OnboardingRequestValidator.validate({
    requestId = "request-5",
    action = "complete_tutorial",
})
pass(invalidAction == nil, "Client cannot send a completion action")

local firstSession = OnboardingEngine.createSession(101)
local secondSession = OnboardingEngine.createSession(202)
local studioSession = OnboardingEngine.createSession(-1)
pass(
    firstSession.state == "AWAITING_STARTER" and secondSession.state == "AWAITING_STARTER",
    "Each player must start in the canonical awaiting-starter state"
)
pass(
    studioSession.ownerUserId == -1 and studioSession.state == "AWAITING_STARTER",
    "Studio test player user IDs must be accepted by the session-only engine"
)
pass(
    not OnboardingEngine.canAccessWorld(firstSession, "origin_plains"),
    "No world is accessible before the starter commit"
)
pass(
    OnboardingEngine.resolveGateAction(firstSession, "world", "origin_plains") == nil
        and OnboardingEngine.resolveGateAction(firstSession, "return", nil) == nil,
    "Gate touch must fail closed before the starter commit"
)

local captureBeforeStarter = OnboardingEngine.transition(firstSession, "CAPTURE_TUMBLET", nil)
pass(not captureBeforeStarter, "Illegal transition must fail closed")

local starterSelected = OnboardingEngine.transition(firstSession, "STARTER_SELECTED", "pyrel")
pass(
    starterSelected
        and firstSession.state == "NORMAL_WORLD_READY"
        and firstSession.starterId == "pyrel",
    "Starter commit must unlock the shared Normal tutorial route"
)
pass(
    OnboardingEngine.canAccessWorld(firstSession, "origin_plains")
        and not OnboardingEngine.canAccessWorld(firstSession, "ember_archipelago"),
    "Only the Normal world is accessible during the tutorial"
)
local normalGateAction = OnboardingEngine.resolveGateAction(firstSession, "world", "origin_plains")
pass(
    normalGateAction ~= nil
        and normalGateAction.action == "enter_normal_world"
        and normalGateAction.worldId == nil
        and OnboardingEngine.resolveGateAction(firstSession, "world", "ember_archipelago")
            == nil,
    "Only touching the Normal gate may begin the tutorial after starter selection"
)
pass(
    not OnboardingEngine.transition(firstSession, "STARTER_SELECTED", "bramblet"),
    "Starter replay cannot replace the committed starter"
)

pass(
    OnboardingEngine.transition(firstSession, "ENTER_NORMAL_WORLD", nil)
        and firstSession.state == "NORMAL_TUTORIAL",
    "Entering the Normal route must start the tutorial"
)
pass(
    not OnboardingEngine.transition(firstSession, "CAPTURE_TUMBLET", nil),
    "Tutorial capture cannot skip basic attack and active skill practice"
)
pass(
    OnboardingEngine.transition(firstSession, "PRACTICE_BASIC_ATTACK", nil)
        and firstSession.state == "BASIC_ATTACK_PRACTICED",
    "Server-confirmed basic attack practice must advance the tutorial"
)
pass(
    OnboardingEngine.transition(firstSession, "PRACTICE_ACTIVE_SKILL", nil)
        and firstSession.state == "ACTIVE_SKILL_PRACTICED",
    "Server-confirmed active skill practice must advance the tutorial"
)
pass(
    OnboardingEngine.transition(firstSession, "CAPTURE_TUMBLET", nil)
        and firstSession.state == "TUMBLET_CAPTURED",
    "Server-confirmed Tumblet capture must advance exactly once"
)
local tutorialReturnAction = OnboardingEngine.resolveGateAction(firstSession, "return", nil)
pass(
    tutorialReturnAction ~= nil and tutorialReturnAction.action == "return_to_village",
    "Touching the tutorial return gate must become available after Tumblet capture"
)
pass(
    not OnboardingEngine.transition(firstSession, "CAPTURE_TUMBLET", nil),
    "Capture transition replay must not advance twice"
)
pass(
    OnboardingEngine.transition(firstSession, "RETURN_TO_VILLAGE", nil)
        and firstSession.state == "WORLD_CHOICE_READY",
    "Returning to the Village must open the elemental world choice"
)
local elementalGateAction = OnboardingEngine.resolveGateAction(firstSession, "world", "azure_tide")
pass(
    elementalGateAction ~= nil
        and elementalGateAction.action == "select_elemental_world"
        and elementalGateAction.worldId == "azure_tide"
        and OnboardingEngine.resolveGateAction(firstSession, "world", "origin_plains") == nil,
    "World choice must accept only an elemental gate touch"
)
pass(
    not OnboardingEngine.transition(firstSession, "SELECT_ELEMENTAL_WORLD", "origin_plains"),
    "The shared Normal world cannot be selected as the elemental world"
)
pass(
    OnboardingEngine.transition(firstSession, "SELECT_ELEMENTAL_WORLD", "azure_tide")
        and firstSession.state == "COMPLETE"
        and firstSession.selectedElementalWorldId == "azure_tide",
    "Player must be able to choose one of four elemental worlds independently of starter"
)
pass(
    OnboardingEngine.canAccessWorld(firstSession, "origin_plains")
        and OnboardingEngine.canAccessWorld(firstSession, "azure_tide")
        and not OnboardingEngine.canAccessWorld(firstSession, "ember_archipelago"),
    "Completed onboarding must expose exactly Normal plus the chosen elemental world"
)
local elementalReturnAction = OnboardingEngine.resolveGateAction(firstSession, "return", nil)
pass(
    elementalReturnAction ~= nil and elementalReturnAction.action == "return_to_village",
    "Touching a landing return gate must return a completed player to the Village"
)
pass(
    OnboardingEngine.setLocation(firstSession, "village"),
    "Completed onboarding must permit a server-owned return to the Village"
)
local normalTravelAction =
    OnboardingEngine.resolveGateAction(firstSession, "world", "origin_plains")
local elementalTravelAction =
    OnboardingEngine.resolveGateAction(firstSession, "world", "azure_tide")
pass(
    normalTravelAction ~= nil
        and normalTravelAction.action == "travel_world"
        and elementalTravelAction ~= nil
        and elementalTravelAction.action == "travel_world",
    "Touching either accessible world gate must travel after onboarding"
)
pass(
    OnboardingEngine.resolveGateAction(firstSession, "world", "ember_archipelago") == nil
        and OnboardingEngine.resolveGateAction(firstSession, "world", "missing_world") == nil,
    "Locked and unknown gate touches must fail closed after onboarding"
)
pass(
    secondSession.state == "AWAITING_STARTER" and secondSession.starterId == nil,
    "Onboarding state must remain isolated between players"
)

local collection = CollectionEngine.createSession(101)
assert(CollectionEngine.addStarter(collection, "pyrel"))
local beforeQuantity = collection.captureInventory.trail_capsule
local tutorialCapture, firstExecution = CollectionEngine.completeCapture(
    collection,
    101,
    "phase5-tutorial-capture",
    "trail_capsule",
    "tumblet",
    true
)
pass(
    tutorialCapture.captured
        and firstExecution
        and #collection.ownedCreatures == 2
        and collection.captureInventory.trail_capsule == beforeQuantity - 1,
    "Guaranteed tutorial capture must consume one device and grant exactly one Tumblet"
)
local retryCapture, retryExecuted = CollectionEngine.completeCapture(
    collection,
    101,
    "phase5-tutorial-capture",
    "trail_capsule",
    "tumblet",
    true
)
pass(
    retryCapture.captured
        and not retryExecuted
        and #collection.ownedCreatures == 2
        and collection.captureInventory.trail_capsule == beforeQuantity - 1,
    "Tutorial capture replay must not consume or grant twice"
)

print(`[Phase5OnboardingTests] {passedTestCount} tests passed`)
