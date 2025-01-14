-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {{
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
        options = {
            icons_enabled = false,
            component_separators = '|',
            section_separators = ''
        },
        tabline = {
            lualine_a = {'buffers'},
            lualine_z = {'tabs'}
        }
    }
}, {
    'vim-test/vim-test',
    config = function()
        vim.cmd [[
        function! BufferTermStrategy(cmd)
          exec 'te ' . a:cmd
        endfunction

        let g:test#custom_strategies = {'bufferterm': function('BufferTermStrategy')}
        let g:test#strategy = 'bufferterm'
      ]]
    end,
    keys = {{
        '<leader>Tf',
        '<cmd>TestFile<cr>',
        silent = true,
        desc = 'Run this file'
    }, {
        '<leader>Tn',
        '<cmd>TestNearest<cr>',
        silent = true,
        desc = 'Run nearest test'
    }, {
        '<leader>Tl',
        '<cmd>TestLast<cr>',
        silent = true,
        desc = 'Run last test'
    }}
}, {
    'stevearc/oil.nvim',
    opts = {},
    dependencies = {'nvim-tree/nvim-web-devicons'},
    keys = {{
        '-',
        '<cmd>Oil<cr>',
        desc = 'Open parent directory'
    }}
}, {
    'stevearc/conform.nvim',
    opts = {
        formatters_by_ft = {
            lua = {'lua_ls'},
            javascript = {{'prettierd', 'prettier'}, {'eslint_d', 'eslint'}},
            typescript = {{'prettierd', 'prettier'}, {'eslint_d', 'eslint'}}
        },
        format_on_save = {
            -- These options will be passed to conform.format()
            timeout_ms = 500,
            lsp_fallback = true
        }
    }
}, {
    "elixir-tools/elixir-tools.nvim",
    version = "*",
    event = {"BufReadPre", "BufNewFile"},
    config = function()
        local elixir = require("elixir")
        local elixirls = require("elixir.elixirls")

        elixir.setup {
            nextls = {
                enable = true
            },
            elixirls = {
                enable = true,
                settings = elixirls.settings {
                    dialyzerEnabled = false,
                    enableTestLenses = false
                },
                on_attach = function(client, bufnr)
                    vim.keymap.set("n", "<space>efp", ":ElixirFromPipe<cr>", {
                        buffer = true,
                        noremap = true
                    })
                    vim.keymap.set("n", "<space>etp", ":ElixirToPipe<cr>", {
                        buffer = true,
                        noremap = true
                    })
                    vim.keymap.set("v", "<space>em", ":ElixirExpandMacro<cr>", {
                        buffer = true,
                        noremap = true
                    })
                end
            },
            projectionist = {
                enable = true
            }
        }
    end,
    dependencies = {"nvim-lua/plenary.nvim"}
}, {
    "luckasRanarison/tailwind-tools.nvim",
    name = "tailwind-tools",
    dependencies = {"nvim-treesitter/nvim-treesitter", "nvim-telescope/telescope.nvim", "neovim/nvim-lspconfig"},
    config = function()
        require("tailwind-tools").setup({
            colors = {
                documentation = true, -- show document colors
                suggest = true -- show suggestions for colors
            },
            templates = {
                -- custom templates for class names suggestions
                template_string = true,
                framework_specific = true
            },
            custom_filetypes = {"templ", "javascript", "typescript", "react", "html", "heex", "eex", "elixir",
                                "eelixir", "lexical"}
        })

        -- Setup the LSP with expanded Elixir support
        require("lspconfig").tailwindcss.setup({
            capabilities = require('cmp_nvim_lsp').default_capabilities(),
            filetypes = {"html", "javascriptreact", "typescriptreact", "javascript", "typescript", "heex", "ex", "exs",
                         "eex", "elixir", "eelixir", "lexical"},
            init_options = {
                userLanguages = {
                    elixir = "phoenix-heex",
                    eelixir = "phoenix-heex",
                    heex = "phoenix-heex",
                    eex = "phoenix-heex"
                }
            },
            settings = {
                tailwindCSS = {
                    experimental = {
                        classRegex = {'class[:]\\s*"([^"]*)"', 'class[:]\\s*\'([^\']*)\''}
                    }
                }
            }
        })
    end
}, {
    "olrtg/nvim-emmet",
    dependencies = {"neovim/nvim-lspconfig"},
    config = function()
        require("lspconfig").emmet_ls.setup({
            capabilities = require('cmp_nvim_lsp').default_capabilities(),
            filetypes = {'html', 'typescriptreact', 'javascriptreact', 'css', 'sass', 'scss', 'less', 'heex', 'eex',
                         'ex', 'exs', 'elixir', 'eelixir', 'lexical'},
            init_options = {
                html = {
                    options = {
                        ["bem.enabled"] = true
                    }
                }
            }
        })

        vim.keymap.set({"n", "v"}, '<leader>xe', require('nvim-emmet').wrap_with_abbreviation)
    end
}}
