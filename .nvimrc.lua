-- neodev (deprecated, but let's try)

-- IMPORTANT: make sure to setup neodev BEFORE lspconfig
require("neodev").setup({
  -- add any options here, or leave empty to use the default settings
})

-- Set up nvim-cmp.
local cmp = require'cmp'
cmp.types = require'cmp.types'

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["UltiSnips#Anon"](args.body)
      -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
      -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item({ behavior = cmp.types.cmp.SelectBehavior.Insert })
      else
        cmp.complete()
        cmp.select_next_item({ behavior = cmp.types.cmp.SelectBehavior.Insert })
      end
    end,
    ['<C-c>'] = cmp.mapping.abort(),
    ['<CR>'] = {
      i = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    },
    ['<C-CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ['<Down>'] = {
      i = cmp.mapping.select_next_item({ behavior = cmp.types.cmp.SelectBehavior.Insert }),
    },
    ['<Up>'] = {
      i = cmp.mapping.select_prev_item({ behavior = cmp.types.cmp.SelectBehavior.Insert }),
    },
    ['<C-j>'] = {
      i = cmp.mapping.select_next_item({ behavior = cmp.types.cmp.SelectBehavior.Insert }),
    },
    ['<C-k>'] = {
      i = cmp.mapping.select_prev_item({ behavior = cmp.types.cmp.SelectBehavior.Insert }),
    },
  }),
  sources = cmp.config.sources({
    { name = 'ultisnips' },
    { name = 'nvim_lsp' },
    -- { name = 'vsnip' }, -- For vsnip users.
    -- { name = 'luasnip' }, -- For luasnip users.
    -- { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
  }, {
    { name = 'buffer' },
  }),
  completion = {
    completeopt = "menu,menuone,preview"
  }
})


-- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
-- Set configuration for specific filetype.
--[[ cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'git' },
  }, {
    { name = 'buffer' },
  })
})
require("cmp_git").setup() ]]-- 

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
-- require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
  --   capabilities = capabilities
  -- }

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

require "lsp_signature".setup{
  handler_opts = {
    border = "none"   -- double, rounded, single, shadow, none, or a table of borders
  },
}

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

