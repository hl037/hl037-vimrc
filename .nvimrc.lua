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
      vim.fn["UltiSnps#Anon"](args.body)
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
  ensure_installed = { "lua_ls", "rust_analyzer", "vue_ls", "pyright", "gopls"},
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

vim.lsp.config('ts_ls', {
  -- Initial options for the TypeScript language server
  init_options = {
    plugins = {
      {
        -- Name of the TypeScript plugin for Vue
        name = '@vue/typescript-plugin',

        -- Location of the Vue language server module (path defined in step 1)
        -- location = vue_language_server_path,
        location = 'vue_language-server',

        -- Specify the languages the plugin applies to (in this case, Vue files)
        languages = { 'vue' },
      },
    },
  },

  -- Specify the file types that will trigger the TypeScript language server
  filetypes = {
    'typescript',          -- TypeScript files (.ts)
    'javascript',          -- JavaScript files (.js)
    'javascriptreact',     -- React files with JavaScript (.jsx)
    'typescriptreact',     -- React files with TypeScript (.tsx)
    'vue'                  -- Vue.js single-file components (.vue)
  },
})

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


-- Python venv switcher (enable only cwd)
require'venv-selector'.setup{
  options = {
    enable_default_searches = false,            -- switches all default searches on/off
    enable_cached_venvs = true,                -- use cached venvs that are activated automatically when a python file is registered with the LSP.
    cached_venv_automatic_activation = true,   -- if set to false, the VenvSelectCached command becomes available to manually activate them.
    activate_venv_in_terminal = true,          -- activate the selected python interpreter in terminal windows opened from neovim
    set_environment_variables = true,          -- sets VIRTUAL_ENV or CONDA_PREFIX environment variables
    notify_user_on_venv_activation = false,    -- notifies user on activation of the virtual env
    search_timeout = 5,                        -- if a search takes longer than this many seconds, stop it and alert the user
    debug = false,                             -- enables you to run the VenvSelectLog command to view debug logs
    require_lsp_activation = false,             -- require activation of an lsp before setting env variables
  },
  search = {
    cwd = require'venv-selector.config'.get_default_searches()().cwd,
  }
}

require'pr0ject'.setup()
require'luaguard'.setup()

