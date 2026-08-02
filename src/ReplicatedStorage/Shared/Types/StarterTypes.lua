--!strict

export type StarterDefinition = {
    id: string,
    displayName: string,
    color: Color3,
}

export type StarterResponse = {
    ok: boolean,
    code: string,
    message: string,
    starterId: string?,
}

return table.freeze({})
