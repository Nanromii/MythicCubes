--!strict

local CombatController = require(script.Parent.Controllers.CombatController)
local StarterSelectionController = require(script.Parent.Controllers.StarterSelectionController)

local combatControllerStarted = false

local function startCombatController()
    if combatControllerStarted then
        return
    end

    combatControllerStarted = true
    CombatController.start()
end

StarterSelectionController.start(function(_starterId: string)
    task.defer(startCombatController)
end)

print("[VoxelCreatures] Phase 3 client started")
