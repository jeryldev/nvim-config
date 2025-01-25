return {
  'olrtg/nvim-emmet',
  dependencies = { 'neovim/nvim-lspconfig' },
  config = function()
    require('lspconfig').emmet_ls.setup {
      capabilities = require('cmp_nvim_lsp').default_capabilities(),
      filetypes = {
        'html',
        'typescriptreact',
        'javascriptreact',
        'css',
        'sass',
        'scss',
        'less',
        'heex',
        'eex',
        'ex',
        'exs',
        'elixir',
        'eelixir',
        'lexical',
      },
      init_options = {
        html = {
          options = {
            ['bem.enabled'] = true,
          },
        },
      },
    }

    vim.keymap.set({ 'n', 'v' }, '<leader>xe', require('nvim-emmet').wrap_with_abbreviation)
  end,
}
