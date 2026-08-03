--!strict

local services = script.Parent.Services
local CaptureService = require(services.CaptureService)
local CollectionService = require(services.CollectionService)
local CompanionService = require(services.CompanionService)
local EncounterService = require(services.EncounterService)
local HomeService = require(services.HomeService)
local RegionalWildService = require(services.RegionalWildService)
local StarterSelectionService = require(services.StarterSelectionService)

HomeService.start()
CollectionService.start()
CompanionService.start()
StarterSelectionService.start()
RegionalWildService.start()
EncounterService.start()
CaptureService.start()

print("[VoxelCreatures] Phase 4 server started")
