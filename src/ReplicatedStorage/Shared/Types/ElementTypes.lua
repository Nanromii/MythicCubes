--!strict

export type ElementDefinition = {
    id: string,
    displayName: string,
    color: Color3,
    effectiveness: { [string]: number },
}

return table.freeze({})
