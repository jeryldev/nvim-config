return {
  'luckasRanarison/tailwind-tools.nvim',
  name = 'tailwind-tools',
  build = ':UpdateRemotePlugins',
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-telescope/telescope.nvim', 'neovim/nvim-lspconfig' },
  config = function()
    require('tailwind-tools').setup {
      -- Required fields based on error message
      extension = {
        -- Extension options (required field)
        enabled = true,
      },

      server = {
        filetypes = {
          'html',
          'javascriptreact',
          'typescriptreact',
          'javascript',
          'typescript',
          'heex',
          'ex',
          'exs',
          'eex',
          'elixir',
          'eelixir',
          'lexical',
          'php',
          'blade',
          'blade.php',
        },
        init_options = {
          userLanguages = {
            -- Elixir templates
            elixir = 'phoenix-heex',
            eelixir = 'phoenix-heex',
            heex = 'phoenix-heex',
            eex = 'phoenix-heex',

            -- PHP templates
            blade = 'blade',
            ['blade.php'] = 'blade',
          },
        },
        settings = {
          tailwindCSS = {
            experimental = {
              classRegex = {
                'class[:]\\s*"([^"]*)"',
                "class[:]\\s*'([^']*)'",
                'class\\s*=\\s*"([^"]*)"',
                "class\\s*=\\s*'([^']*)'",
                '@class\\(\\[([^\\]]*)\\]\\)',
              },
            },
            validate = true,
            emmetCompletions = true,
          },
        },
      },

      document_color = {
        enabled = true,
      },

      conceal = {
        enabled = false,
      },

      cmp = {
        enabled = true,
      },

      telescope = {
        enabled = true,
      },
    }
  end,
}
