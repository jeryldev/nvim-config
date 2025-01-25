return {
  'luckasRanarison/tailwind-tools.nvim',
  name = 'tailwind-tools',
  build = ':UpdateRemotePlugins',
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-telescope/telescope.nvim', 'neovim/nvim-lspconfig' },
  config = function()
    require('tailwind-tools').setup {
      colors = {
        documentation = true, -- show document colors
        suggest = true,       -- show suggestions for colors
      },
      templates = {
        -- custom templates for class names suggestions
        template_string = true,
        framework_specific = true,
      },
      custom_filetypes = { 'templ', 'javascript', 'typescript', 'react', 'html', 'heex', 'eex', 'elixir', 'eelixir', 'lexical' },
    }

    -- Setup the LSP with expanded Elixir support
    require('lspconfig').tailwindcss.setup {
      capabilities = require('cmp_nvim_lsp').default_capabilities(),
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
      },
      init_options = {
        userLanguages = {
          elixir = 'phoenix-heex',
          eelixir = 'phoenix-heex',
          heex = 'phoenix-heex',
          eex = 'phoenix-heex',
        },
      },
      settings = {
        tailwindCSS = {
          experimental = {
            classRegex = { 'class[:]\\s*"([^"]*)"', "class[:]\\s*'([^']*)'" },
          },
        },
      },
    }
  end,
}
