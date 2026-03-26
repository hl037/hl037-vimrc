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
-- Dap custom entries (for direct function call and dynamic dap configs)
----------------------------

local dap_custom_entries = {
  function() return {
    filetype = "py",
    config = {
      name = "Nearest test method",
    },
    exec_callback = require('dap-python').test_method
  } end,
}

package.loaded['dap-custom-entries'] = dap_custom_entries



----------------------------
-- Dap replace :DapContinue with all languages + custom entries
----------------------------

local dap = require"dap"
local pickers = require"telescope.pickers"
local finders = require"telescope.finders"
local conf = require"telescope.config".values
local actions = require"telescope.actions"
local action_state = require"telescope.actions.state"

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
  
  for _, entry_factory in ipairs(dap_custom_entries) do
    local entry = entry_factory()
    if entry ~= nil then
      table.insert(all_configs, entry)
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
        if selection.value.exec_callback ~= nil then
          selection.value.exec_callback()
        else
          dap.run(selection.value.config)
        end
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

require'treeasy'.set_colors('filetreeasy', {
  current = {
    bold = true,
    fg = "#ffffff"
  },
  dir = {
    fg = "#7aa2f7"
  },
  ft_header = {
    bold = true,
    fg = "#565f89"
  },
  ft_root_delete = {
    bold = true,
    fg = "#f7768e"
  },
  ft_root_path = {
    bold = true,
    fg = "#ffd454"
  },
  git_conflict = {
    fg = "#f7768e"
  },
  git_conflict_name = {
    fg = "#f7768e",
    underline = true
  },
  git_deleted = {
    fg = "#f7768e"
  },
  git_ignored = {
    fg = "#565f89"
  },
  git_modified = {
    fg = "#e0af68"
  },
  git_renamed = {
    fg = "#bb9af7"
  },
  git_staged = {
    fg = "#9ece6a"
  },
  git_untracked = {
    fg = "#7dcfff"
  },
  modified = {
    fg = "#e0af68"
  },
  pick_win = {
    fg = "#414868"
  },
  pick_win_active = {
    bold = true,
    fg = "#e0af68"
  },
  symlink = {
    italic = true
  },
  visible = {
    fg = "#c0caf5"
  }
})


----------------------------
-- Project auto commands
----------------------------

local dap_orig_config = nil

vim.api.nvim_create_autocmd("User", {
  pattern = "BeforeProjectChanged",
  callback = function()
    vim.cmd("FileTreeClose")
    if dap_orig_config ~= nil then
      require'dap'.configurations  = dap_orig_config
    end
  end,
})

vim.api.nvim_create_autocmd("User", {
 pattern = "ProjectChanged",
 callback = function()
   vim.cmd("FileTreeOpen")
   if file_exists('./.nvim/rc') then
     vim.cmd('source ./.nvim/rc')
   end
   if file_exists('./.nvim/rc.py') then
     vim.cmd('pyfile ./.nvim/rc.py')
   end
   if file_exists('./.nvim/rc.lua') then
     vim.cmd('luafile ./.nvim/rc.lua')
   end
   dap_orig_config = vim.deepcopy(require'dap'.configurations)
   require'dap.ext.vscode'.load_launchjs()
 end,
})


----------------------------
-- Dolphin and Konsole
----------------------------


vim.api.nvim_create_user_command("Dolphin", function()
  vim.fn.jobstart({'dolphin', '--new-window', vim.fn.getcwd()},{
    detach = true
  })
end, {
  desc = "Open Dolphin in current directory"
})
  
vim.api.nvim_create_user_command("Konsole", function()
  vim.fn.jobstart({'konsole', '--workdir', vim.fn.getcwd()},{
    detach = true
  })
end, {
  desc = "Open Dolphin in current directory"
})

-- DEBUG

vim.api.nvim_create_user_command("SelfDebug", function()
  require"osv".launch({port = 8086}) 
end, {
  desc = "Start OSV dap server"
})
