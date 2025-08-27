local cmp = require'cmp'

local function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end
----------------------------
-- Vim commandline completion
----------------------------

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  }),
  matching = { disallow_symbol_nonprefix_matching = false }
})


----------------------------
-- Dap replace :DapContinue with all languages
----------------------------

local dap = require('dap')
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

-- Store original dap continue function
local original_continue = dap.continue

local function telescope_dap_configurations()
  local all_configs = {}
  for filetype, configs in pairs(dap.configurations) do
    for _, config in ipairs(configs) do
      table.insert(all_configs, {
        config = config,
        filetype = filetype
      })
    end
  end

  pickers.new({}, {
    prompt_title = "DAP Configurations",
    finder = finders.new_table {
      results = all_configs,
      entry_maker = function(entry)
        return {
          value = entry,
          display = string.format("[%s] %s", entry.filetype, entry.config.name),
          ordinal = entry.filetype .. " " .. entry.config.name,
        }
      end,
    },
    
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        dap.run(selection.value.config)
      end)
      return true
    end,
  }):find()
end
  
dap.continue = function(opts)
  opts = opts or {}
  -- If session is running, just do normal stuff
  if dap.session() and not opts.new then
    return original_continue(opts)
  end
  -- Else, launch the picker
  telescope_dap_configurations()
end


----------------------------
-- Project auto commands
----------------------------

local dap_orig_config = nil

vim.api.nvim_create_autocmd("User", {
  pattern = "BeforeProjectChanged",
  callback = function()
    vim.cmd("NERDTreeClose")
    if dap_orig_config ~= nil then
      require'dap'.configurations  = dap_orig_config
    end
  end,
})

vim.api.nvim_create_autocmd("User", {
 pattern = "ProjectChanged",
 callback = function()
   vim.cmd("NERDTree")
   if file_exists('./.nvim/rc') then
     vim.cmd('source ./.nvim/rc')
   end
   if file_exists('./.nvim/rc.lua') then
     vim.cmd('luafile ./.nvim/rc.lua')
   end
   dap_orig_config = vim.deepcopy(require'dap'.configurations)
   require'dap.ext.vscode'.load_launchjs()
 end,
})
