--!strict

local OnboardingController = require(script.Parent.Controllers.OnboardingController)
local StarterSelectionController = require(script.Parent.Controllers.StarterSelectionController)
local WorldController = require(script.Parent.Controllers.WorldController)

local worldControllerStarted = false

local function startWorldController()
    if worldControllerStarted then
        return
    end

    worldControllerStarted = true
    WorldController.start()
end

OnboardingController.start(function()
    task.defer(startWorldController)
end)

StarterSelectionController.start(function(_starterId: string) end)

print("[VoxelCreatures] Phase 5 client started")
