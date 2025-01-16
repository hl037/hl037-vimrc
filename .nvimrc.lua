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
    ensure_installed = { "lua_ls", "rust_analyzer", "clangd", "volar", "ruff", "pyright", "gopls"},
    automatic_installation = true,
}

require("mason-lspconfig").setup_handlers {
    -- The first entry (without a key) will be the default handler
    -- and will be called for each installed server that doesn't have
    -- a dedicated handler.
    function (server_name) -- default handler (optional)
        require("lspconfig")[server_name].setup {}
    end,
    -- Next, you can provide a dedicated handler for specific servers.
    -- For example, a handler override for the `rust_analyzer`:
    ["clangd"] = function ()
      require("lspconfig").clangd.setup {
        cmd = { 'clangd', '--background-index', '-j', '8', '--clang-tidy'}
      }
    end
}

require "lsp_signature".setup{
  handler_opts = {
    border = "none"   -- double, rounded, single, shadow, none, or a table of borders
  },
}

-- Vue
local mason_registry = require('mason-registry')
local vue_language_server_path = mason_registry.get_package('vue-language-server'):get_install_path() .. '/node_modules/@vue/language-server'

require('lspconfig').ts_ls.setup {
    -- Initial options for the TypeScript language server
    init_options = {
        plugins = {
            {
                -- Name of the TypeScript plugin for Vue
                name = '@vue/typescript-plugin',

                -- Location of the Vue language server module (path defined in step 1)
                location = vue_language_server_path,

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
}

-- Telescope
-- 
local telescope, builtin = require('telescope'), require('telescope.builtin')

telescope.setup{
}

telescope.load_extension('fzf')        -- without this there's no 'foo | ^bar | baz$' style filtering
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

