
require('lazydev').setup()

local blink_cmp_use_lua = os.getenv('HOST_ENV') == 'bnpp'

require('blink.cmp').setup({
  keymap = {
    ['<C-space>']   = { 'show_and_insert', 'select_next', 'fallback' },
    ['<C-S-space>'] = { 'select_prev', 'fallback' },
    ['<C-c>']       = { 'hide', 'fallback' },
    ['<CR>']        = { 'accept', 'fallback' },
    ['<C-CR>']      = { 'accept', 'fallback' },
    ['<Down>']      = { 'select_next', 'fallback' },
    ['<Up>']        = { 'select_prev', 'fallback' },
    ['<C-j>']       = { 'select_next', 'fallback' },
    ['<C-k>']       = { 'select_prev', 'fallback' },
    ['<C-b>']       = { 'scroll_documentation_up', 'fallback' },
    ['<C-f>']       = { 'scroll_documentation_down', 'fallback' },
  },

  completion = {
    trigger = {
      show_on_keyword                      = true,
      show_on_trigger_character            = true,
      show_on_backspace                    = false,
      show_on_backspace_in_keyword         = false,
      show_on_backspace_after_accept       = false,
      show_on_backspace_after_insert_enter = false,
      show_on_insert_on_trigger_character  = false,
    },
    list = {
      selection = { preselect = true, auto_insert = true },
    },
    documentation = {
      auto_show          = true,
      auto_show_delay_ms = 200,
    },
    ghost_text = { enabled = false },
    menu = {
      draw = {
        columns = {
          { 'label', 'label_description', gap = 1 },
          { 'kind', 'source_label', gap = 1 },
        },
        components = {
          label = {
            highlight = function(ctx) return ctx.kind_hl end,
          },
          label_description = {
            highlight = function(ctx) return ctx.kind_hl end,
          },
          source_label = {
            text = function(ctx)
              local name = ctx.item.client_name or ctx.source_name
              return '<' .. name .. '>'
            end,
            highlight = 'BlinkCmpSource',
          },
        },
      },
    },
  },

  signature = { enabled = true },

  sources = {
    default = { 'lsp', 'path', 'buffer', 'lazydev' },
    providers = {
      lsp = {
        transform_items = function(_, items)
          return vim.tbl_filter(function(item)
            return item.kind ~= require('blink.cmp.types').CompletionItemKind.Snippet
          end, items)
        end,
      },
      lazydev = {
        name   = 'LazyDev',
        module = 'lazydev.integrations.blink',
        score_offset = 100, -- priorité maximale sur le LSP pour les fichiers lua
      },
    },
  },

  fuzzy = {
    implementation    = blink_cmp_use_lua and 'lua' or 'prefer_rust',
    prebuilt_binaries = { download = false },
  },

  cmdline = {
    enabled = true,
    sources = function()
      local type = vim.fn.getcmdtype()
      if type == '/' or type == '?' then
        return { 'buffer' }
      end
      if type == ':' then
        return { 'path', 'cmdline' }
      end
      return {}
    end,
  },
})

vim.api.nvim_set_hl(0, 'BlinkCmpKindText',          { link = 'String' })
vim.api.nvim_set_hl(0, 'BlinkCmpKindMethod',         { link = 'Function' })
vim.api.nvim_set_hl(0, 'BlinkCmpKindFunction',       { link = 'Function' })
vim.api.nvim_set_hl(0, 'BlinkCmpKindConstructor',    { link = 'Function' })
vim.api.nvim_set_hl(0, 'BlinkCmpKindField',          { link = 'Identifier' })
vim.api.nvim_set_hl(0, 'BlinkCmpKindVariable',       { link = 'Identifier' })
vim.api.nvim_set_hl(0, 'BlinkCmpKindClass',          { link = 'Type' })
vim.api.nvim_set_hl(0, 'BlinkCmpKindInterface',      { link = 'Type' })
vim.api.nvim_set_hl(0, 'BlinkCmpKindModule',         { link = 'Include' })
vim.api.nvim_set_hl(0, 'BlinkCmpKindProperty',       { link = '@property' })
vim.api.nvim_set_hl(0, 'BlinkCmpKindUnit',           { link = 'Number' })
vim.api.nvim_set_hl(0, 'BlinkCmpKindValue',          { link = 'Number' })
vim.api.nvim_set_hl(0, 'BlinkCmpKindEnum',           { link = 'Type' })
vim.api.nvim_set_hl(0, 'BlinkCmpKindKeyword',        { link = 'Keyword' })
vim.api.nvim_set_hl(0, 'BlinkCmpKindSnippet',        { link = 'Comment' })
vim.api.nvim_set_hl(0, 'BlinkCmpKindColor',          { link = 'Special' })
vim.api.nvim_set_hl(0, 'BlinkCmpKindFile',           { link = 'Directory' })
vim.api.nvim_set_hl(0, 'BlinkCmpKindReference',      { link = 'Special' })
vim.api.nvim_set_hl(0, 'BlinkCmpKindFolder',         { link = 'Directory' })
vim.api.nvim_set_hl(0, 'BlinkCmpKindEnumMember',     { link = 'Constant' })
vim.api.nvim_set_hl(0, 'BlinkCmpKindConstant',       { link = 'Constant' })
vim.api.nvim_set_hl(0, 'BlinkCmpKindStruct',         { link = 'Type' })
vim.api.nvim_set_hl(0, 'BlinkCmpKindEvent',          { link = 'Special' })
vim.api.nvim_set_hl(0, 'BlinkCmpKindOperator',       { link = 'Operator' })
vim.api.nvim_set_hl(0, 'BlinkCmpKindTypeParameter',  { link = 'Type' })

require'mason'.setup{
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
}

require'mason-lspconfig'.setup{
  ensure_installed = { "lua_ls", "rust_analyzer", "vue_ls", "pyright", "gopls", "vtsls"},
  automatic_installation = true,
}

vim.lsp.config('clangd', {
  cmd = { 'clangd', '--background-index', '-j', '8', '--clang-tidy'}
})

-- require'mason-lspconfig'.setup_handlers {
  --     -- The first entry (without a key) will be the default handler
  --     -- and will be called for each installed server that doesn't have
  --     -- a dedicated handler.
  --     function (server_name) -- default handler (optional)
    --         require("lspconfig")[server_name].setup {}
    --     end,
  --     -- Next, you can provide a dedicated handler for specific servers.
  --     -- For example, a handler override for the `rust_analyzer`:
  --     ["clangd"] = function ()
    --       require("lspconfig").clangd.setup {
      --         cmd = { 'clangd', '--background-index', '-j', '8', '--clang-tidy'}
      --       }
    --     end
  -- }

-- require "lsp_signature".setup{
--   handler_opts = {
--     border = "none"   -- double, rounded, single, shadow, none, or a table of borders
--   },
-- }

-- Lua
-- vim.lsp.config("lua_ls", {
  --     settings = {
    --         Lua = {
      --             runtime = {
        --             
        --             },
      --             diagnostics = {
        --               globals = { "vim" },
        --               path = vim.split(package.path, ';')
        --             },
      --             workspace = {
        --               library = {
          --                 vim.api.nvim_get_runtime_file("", true),
          --               },
        --               checkThirdParty = false
        --             },
      --             telemetry = { enable = false },
      --         },
    --     },
  -- })


-- Vue
local mason_registry = require('mason-registry')
-- local vue_language_server_path = mason_registry.get_package('vue-language-server'):get_install_path() .. '/node_modules/@vue/language-server'
local vue_language_server_path = vim.fn.expand '$MASON/packages' .. '/vue-language-server' .. '/node_modules/@vue/language-server'

local vue_plugin = {
  name = '@vue/typescript-plugin',
  location = vue_language_server_path,
  languages = { 'vue' },
  configNamespace = 'typescript',
}

local vtsls_config = {
  settings = {
    vtsls = {
      tsserver = {
        globalPlugins = {
          vue_plugin,
        },
      },
    },
  },
  filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
}

local vue_ls_config = {
  on_init = function(client)
    client.handlers['tsserver/request'] = function(_, result, context)
      local clients = vim.lsp.get_clients { bufnr = context.bufnr, name = 'vtsls' }
      if #clients == 0 then
        vim.notify('Could not find `vtsls` lsp client, `vue_ls` would not work without it.', vim.log.levels.ERROR)
        return
      end
      local ts_client = clients[1]

      local param = unpack(result)
      local id, command, payload = unpack(param)
      ts_client:exec_cmd({
        title = 'vue_request_forward', -- You can give title anything as it's used to represent a command in the UI, `:h Client:exec_cmd`
        command = 'typescript.tsserverRequest',
        arguments = {
          command,
          payload,
        },
      }, { bufnr = context.bufnr }, function(_, r)
        local response = r and r.body
        -- TODO: handle error or response nil here, e.g. logging
        -- NOTE: Do NOT return if there's an error or no response, just return nil back to the vue_ls to prevent memory leak
        local response_data = { { id, response } }

        ---@diagnostic disable-next-line: param-type-mismatch
        client:notify('tsserver/response', response_data)
      end)
    end
  end,
}
-- nvim 0.11 or above
vim.lsp.config('vtsls', vtsls_config)
vim.lsp.config('vue_ls', vue_ls_config)
vim.lsp.enable { 'vtsls', 'vue_ls' }

-- local vue_language_server_path = vim.fn.expand '$MASON/packages' .. '/vue-language-server' .. '/node_modules/@vue/language-server'
-- local vue_plugin = {
--   name = '@vue/typescript-plugin',
--   location = vue_language_server_path,
--   languages = { 'vue' },
--   configNamespace = 'typescript',
-- }
-- local vtsls_config = {
--   settings = {
--     vtsls = {
--       tsserver = {
--         globalPlugins = {
--           vue_plugin,
--         },
--       },
--     },
--   },
--   filetypes = tsserver_filetypes,
-- }
-- 
-- local ts_ls_config = {
--   init_options = {
--     plugins = {
--       vue_plugin,
--     },
--   },
--   filetypes = tsserver_filetypes,
-- }
-- 
-- local vue_ls_config = {
--   on_init = function(client)
--     client.handlers['tsserver/request'] = function(_, result, context)
--       local ts_clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = 'ts_ls' })
--       local vtsls_clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = 'vtsls' })
--       local clients = {}
-- 
--       vim.list_extend(clients, ts_clients)
--       vim.list_extend(clients, vtsls_clients)
-- 
--       if #clients == 0 then
--         vim.notify('Could not find `vtsls` or `ts_ls` lsp client, `vue_ls` would not work without it.', vim.log.levels.ERROR)
--         return
--       end
--       local ts_client = clients[1]
-- 
--       local param = unpack(result)
--       local id, command, payload = unpack(param)
--       ts_client:exec_cmd({
--         title = 'vue_request_forward', -- You can give title anything as it's used to represent a command in the UI, `:h Client:exec_cmd`
--         command = 'typescript.tsserverRequest',
--         arguments = {
--           command,
--           payload,
--         },
--       }, { bufnr = context.bufnr }, function(_, r)
--           local response = r and r.body
--           -- TODO: handle error or response nil here, e.g. logging
--           -- NOTE: Do NOT return if there's an error or no response, just return nil back to the vue_ls to prevent memory leak
--           local response_data = { { id, response } }
-- 
--           ---@diagnostic disable-next-line: param-type-mismatch
--           client:notify('tsserver/response', response_data)
--         end)
--     end
--   end,
-- }
-- 
-- vim.lsp.config('vue_ls', vue_ls_config)
-- vim.lsp.config('vtsls', vtsls_config)
-- vim.lsp.config('ts_ls', ts_ls_config)
-- vim.lsp.enable({'vtsls', 'vue_ls'})

vim.lsp.config("pylsp", {
  settings = {
    pylsp = {
      plugins = {
        pyflakes = { enabled = false },
        pycodestyle = { enabled = false },
        mccabe = { enabled = false },
        yapf = { enabled = true },
      },
    },
  },
})

vim.lsp.config('pyright', {})

-- Telescope
local telescope, builtin = require('telescope'), require('telescope.builtin')

telescope.setup{
  defaults = {
    mappings = {
      i = {
        -- Naviguer dans l'historique des recherches
        ["<C-Down>"] = require('telescope.actions').cycle_history_next,
        ["<C-Up>"] = require('telescope.actions').cycle_history_prev,
        
        -- Note : <C-n> et <C-p> restent souvent utiles pour 
        -- naviguer dans la liste des résultats eux-mêmes.
      },
    },
  },
}

telescope.load_extension('fzf')        -- without this there's no 'foo | ^bar | baz$' style filtering
telescope.load_extension('dap')
-- requires telescope-fzf-native, check the readme/wiki

function FuzzyFindFiles()
  builtin.grep_string({
    path_display = { 'smart' },
    only_sort_text = true,
    word_match = "-w",
    search = '',
  })
end

-- Enable inlay hints (display parmas)

vim.lsp.inlay_hint.enable(true, { 0 })


-- map display diagnosis
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = "Show diagnosis in float" })

-- Configuration de nvim-dap
local dap = require('dap')
local dapui = require('dapui')

-- Configuration de mason-nvim-dap
require('mason-nvim-dap').setup({
  ensure_installed = { 'codelldb', 'cppdbg' }, -- ou 'cppdbg' selon ta préférence
  automatic_installation = true,
})

-- Configuration de dap-ui
dapui.setup({
  controls = {
    icons = {
      disconnect = "⏻",
      pause = "⏸",
      play = "⏵",
      run_last = "↺",
      step_back = "←",
      step_into = "⤓",
      step_out = "⤒",
      step_over = "→",
      terminate = "❌"
    }
  },
  icons = {
    collapsed = "+",
    current_frame = "⤚",
    expanded = "-"
  },
})

-- Auto-ouverture/fermeture de l'UI
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

-- Use :edit instead of create new tab...
require('dap').defaults.fallback.open = function(fname)
  vim.cmd('edit ' .. fname)
end

local dap_python = require"dap-python"

dap_python.setup("python")
dap_python.test_runner = "pytest"

require("dap-disasm").setup({
  -- Add disassembly view to elements of nvim-dap-ui
  dapui_register = true,

  -- Show winbar with buttons to step into the code with instruction granularity
  -- This settings is overriden (disabled) if the dapview integration is enabled and the plugin is installed
  winbar = true,

  -- The sign to use for instruction the exectution is stopped at
  sign = "DapStopped",

  -- Number of instructions to show before the memory reference
  ins_before_memref = 32,

  -- Number of instructions to show after the memory reference
  ins_after_memref = 32,

  -- Labels of buttons in winbar
  controls = {
    step_into = "Step Into",
    step_over = "Step Over",
    step_back = "Step Back",
  },

  -- Columns to display in the disassembly view
  columns = {
    "address",
    "instructionBytes",
    "instruction",
  },
})


-- Python venv switcher (enable only cwd)
require('venv-selector').setup({
  settings = {
    options = {
      notify_user_on_venv_activation = false,
      set_environment_variables = true,
      activate_venv_in_terminal = true,
    },
    search = {
      -- On définit uniquement la recherche dans le dossier de travail
      my_cwd_search = {
        command = "fd 'bin/python$' --full-path --color never -E /proc -E /sys -E /dev",
      },
    },
  },
})

require'pr0ject'.setup()
require'luaguard'.setup()
-- require'embassy-inspect'.setup()
require'dap-ghidra-sync'.setup()


require("filetreeasy").setup({
  width    = 20,
  side     = "left",    -- "left" | "right"
  devicons = false,     -- opt-in: requires nvim-web-devicons
  icons    = {
    dir_open   = "▾ ",
    dir_closed = "▸ ",
    file       = "",
    modified   = "●",
  },

  buffer_sync            = true,   -- auto-reveal current file in tree on BufEnter
  auto_close_empty_roots = true,  -- remove alt roots when all their buffers close
  collapse_alt_on_switch = true,  -- collapse alt roots when switching to another root

  plugins = {
    require("filetreeasy.plugins.git"),
    require("filetreeasy.plugins.pick_win"),
  },
})


require("outlineasy").setup({
  scope = "file",   -- default scope: "file" | "module" | "all"
  width = 20,       -- sidebar width in columns
  side  = "right",   -- "left" | "right"
  icons = false,     -- false = no nerd-font icons (symbol kinds + file types)
})

