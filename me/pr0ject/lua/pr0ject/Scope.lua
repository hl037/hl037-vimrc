---@class Scope
---@field commands table<string, boolean> List of created commands
---@field keymaps table<{mode:string, lhs:string}> List of created keymaps
local Scope = {}
Scope.__index = Scope

---Creates a new instance of Scope
---@return Scope
function Scope:new()
    local obj = setmetatable({
        commands = {},
        keymaps = {}
    }, self)
    return obj
end

---Wrap of `vim.api.nvim_create_user_command`
---@param name string Name of the command
---@param command string|function Command to execute
---@param opts table? Command options (as in nvim_create_user_command)
function Scope:nvim_create_user_command(name, command, opts)
    vim.api.nvim_create_user_command(name, command, opts or {})
    self.commands[name] = true
end

---Creates a keymap using modern `vim.keymap.set`
---@param mode string|table Mode(s) for the keymap ("n", "i", etc.)
---@param lhs string Key sequence to bind
---@param rhs string|function Command or function to execute
---@param opts table? Keymap options
function Scope:set_keymap(mode, lhs, rhs, opts)
    opts = opts or {}
    vim.keymap.set(mode, lhs, rhs, opts)
    -- Store all modes for later removal
    if type(mode) == "string" then
        table.insert(self.keymaps, {mode = mode, lhs = lhs})
    elseif type(mode) == "table" then
        for _, m in ipairs(mode) do
            table.insert(self.keymaps, {mode = m, lhs = lhs})
        end
    end
end

---Removes all commands and keymaps created through this manager
function Scope:clean()
    -- Remove commands
    for name,_ in pairs(self.commands) do
        vim.api.nvim_del_user_command(name)
    end
    self.commands = {}

    -- Remove keymaps
    for _, km in ipairs(self.keymaps) do
        vim.keymap.set(km.mode, km.lhs, nil)  -- nil removes the keymap
    end
    self.keymaps = {}
end

return Scope
