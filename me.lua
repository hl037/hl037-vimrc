local dap = require"dap"
local pickers = require"telescope.pickers"
local finders = require"telescope.finders"
local conf = require"telescope.config".values
local actions = require"telescope.actions"
local action_state = require"telescope.actions.state"
local make_entry = require("telescope.make_entry")
local previewers = require("telescope.previewers")

local function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

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
-- Custom commands
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

-- RG

local NS = vim.api.nvim_create_namespace("telescope_rg_match")

-- ─── helpers ─────────────────────────────────────────────────────────────────

local function base_cmd(extra_args)
  return vim.list_extend({ "rg", "--smart-case" }, extra_args)
end

local function parse_args(opts)
  return vim.split(opts.args, "%s+", { trimempty = true })
end

-- Add fuzzy prompt highlight in the preview window.
-- Uses vim's `matchadd` with the Search hl group so it feels native.
local function highlight_prompt_in_preview(winid, prompt)
  if not prompt or #prompt == 0 then return end
  vim.api.nvim_win_call(winid, function()
    pcall(vim.fn.clearmatches)
    pcall(vim.fn.matchadd, "Search", vim.fn.escape(prompt, "\\/.*$^~[]"))
  end)
end

-- ─── :TelescopeRG (json, rg match in results + fuzzy in preview) ─────────────

local function json_entry_maker(line)
  local ok, parsed = pcall(vim.json.decode, line)
  if not ok or parsed.type ~= "match" then return nil end

  local data     = parsed.data
  local filename = data.path.text
  local lnum     = data.line_number
  local sub      = data.submatches[1]
  local text     = (data.lines.text or ""):gsub("\n$", "")
  local prefix   = filename .. ":" .. lnum .. ": "

  return {
    value    = filename .. ":" .. lnum .. ":" .. sub.start .. ":" .. text,
    -- display returns (string, highlights) to mark the rg match in the results list
    display  = function(_)
      local hl_start = #prefix + sub.start
      local hl_end   = #prefix + sub["end"]
      return prefix .. text, { { { hl_start, hl_end }, "TelescopePreviewMatch" } }
    end,
    ordinal  = filename .. " " .. text,
    filename = filename,
    lnum     = lnum,
    col      = sub.start,
    col_end  = sub["end"],
  }
end

local json_previewer = previewers.new_buffer_previewer({
  title = "Preview",
  get_buffer_by_name = function(_, entry) return entry.filename end,
  define_preview = function(self, entry, status)
    conf.buffer_previewer_maker(entry.filename, self.state.bufnr, {
      bufname  = self.state.bufname,
      winid    = self.state.winid,
      callback = function(bufnr)
        -- scroll to match
        pcall(vim.api.nvim_win_set_cursor, self.state.winid, { entry.lnum, entry.col })
        vim.api.nvim_win_call(self.state.winid, function() vim.cmd("normal! zz") end)

        -- rg exact match highlight (extmark)
        vim.api.nvim_buf_clear_namespace(bufnr, NS, 0, -1)
        vim.api.nvim_buf_add_highlight(
          bufnr, NS, "TelescopePreviewMatch",
          entry.lnum - 1, entry.col, entry.col_end
        )

        -- fuzzy query highlight (matchadd in window)
        highlight_prompt_in_preview(self.state.winid, status.picker:_get_prompt())
      end,
    })
  end,
})

vim.api.nvim_create_user_command("TelescopeRG", function(opts)
  local path = nil
  require'filetreeasy.views'.each(function(v)
    if path == nil then
      path = v.tree.root.children[2].path
    end
  end)
  local args = parse_args(opts)
  pickers.new({}, {
    prompt_title = "rg " .. opts.args,
    finder  = finders.new_oneshot_job(
      vim.list_extend(base_cmd(args), { "--json" }),
      {
        entry_maker = json_entry_maker,
        cwd = path
      }
    ),
    previewer = json_previewer,
    sorter    = conf.generic_sorter({}),
  }):find()
end, { nargs = "+", desc = "rg --json: rg match highlight in results + fuzzy in preview" })

-- ─── :TelescopeRGfast (vimgrep, fuzzy highlight in preview only) ─────────────

local fast_previewer = previewers.new_buffer_previewer({
  title = "Preview",
  get_buffer_by_name = function(_, entry) return entry.filename end,
  define_preview = function(self, entry, status)
    conf.buffer_previewer_maker(entry.filename, self.state.bufnr, {
      bufname  = self.state.bufname,
      winid    = self.state.winid,
      callback = function(bufnr)
        -- scroll to match
        local col = (entry.col or 1) - 1
        pcall(vim.api.nvim_win_set_cursor, self.state.winid, { entry.lnum, col })
        vim.api.nvim_win_call(self.state.winid, function() vim.cmd("normal! zz") end)

        -- fuzzy query highlight
        highlight_prompt_in_preview(self.state.winid, status.picker:_get_prompt())

        -- suppress unused warning: bufnr is used implicitly via buffer_previewer_maker
        _ = bufnr
      end,
    })
  end,
})

vim.api.nvim_create_user_command("TelescopeRGfast", function(opts)
  require'filetreeasy.views'.each(function(v)
    if path == nil then
      path = v.tree.root.children[2].path
    end
  end)
  local args = parse_args(opts)
  pickers.new({}, {
    prompt_title = "rg (fast) " .. opts.args,
    finder  = finders.new_oneshot_job(
      vim.list_extend(base_cmd(args), { "--color=never", "--vimgrep" }),
      {
        entry_maker = make_entry.gen_from_vimgrep({}),
        cwd = path
      }
    ),
    previewer = fast_previewer,
    sorter    = conf.generic_sorter({}),
  }):find()
end, { nargs = "+", desc = "rg --vimgrep: fast stream, fuzzy highlight in preview" })
