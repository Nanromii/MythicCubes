--!strict

local RoleTypes = require(script.Parent.Parent.Types.RoleTypes)

type RoleDefinition = RoleTypes.RoleDefinition

local definitions: { RoleDefinition } = {
    table.freeze({
        id = "guardian",
        displayName = "Guardian",
        description = "Absorbs pressure and protects the team.",
    }),
    table.freeze({
        id = "striker",
        displayName = "Striker",
        description = "Applies direct damage with decisive attacks.",
    }),
    table.freeze({
        id = "support",
        displayName = "Support",
        description = "Keeps allies stable through defensive utility.",
    }),
    table.freeze({
        id = "controller",
        displayName = "Controller",
        description = "Shapes the encounter by restricting opponents.",
    }),
}

return table.freeze(definitions)
