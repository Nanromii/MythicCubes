--!strict

local services = script.Parent.Services
local HomeService = require(services.HomeService)
local StarterSelectionService = require(services.StarterSelectionService)

HomeService.start()
StarterSelectionService.start()

print("[VoxelCreatures] Phase 1 server started")
