return {
  'nvimtools/none-ls.nvim',
  dependencies = {
    'nvimtools/none-ls-extras.nvim',
    'jayp0521/mason-null-ls.nvim', -- ensure dependencies are installed
  },
  config = function()
    local null_ls = require 'null-ls'
    local formatting = null_ls.builtins.formatting -- to setup formatters
    local diagnostics = null_ls.builtins.diagnostics -- to setup linters
    -- list of formatters & linters for mason to install
    require('mason-null-ls').setup {
      ensure_installed = {
        'checkmake',
        'prettier', -- ts/js formatter
        'stylua', -- lua formatter
        'eslint_d', -- ts/js linter
        'shfmt',
        'ruff',
        'clang_format', -- c, cpp, cs, java, cuda, proto
        'pint', -- php (Laravel)
        'phpstan', -- php
      },
      -- auto-install configured formatters & linters (with null-ls)
      automatic_installation = true,
    }
    local sources = {
      diagnostics.checkmake,
      formatting.prettier.with {
        filetypes = { 'html', 'json', 'yaml', 'markdown', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'vue', 'angular', 'css' },
        extra_args = { '--tab-width', '2', '--print-width', '100' },
      },
      formatting.stylua,
      formatting.shfmt.with { args = { '-i', '4' } },
      formatting.terraform_fmt,
      require('none-ls.formatting.ruff').with { extra_args = { '--extend-select', 'I' } },
      require 'none-ls.formatting.ruff_format',
      diagnostics.credo,
      formatting.mix,
      formatting.sqruff,
      formatting.clang_format,
      formatting.pint, -- Laravel's official PHP code style tool
      diagnostics.phpstan, -- PHP static analysis
    }
    local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
    null_ls.setup {
      -- debug = true, -- Enable debug mode. Inspect logs with :NullLsLog.
      sources = sources,
      -- you can reuse a shared lspconfig on_attach callback here
      on_attach = function(client, bufnr)
        if client.supports_method 'textDocument/formatting' then
          vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
          vim.api.nvim_create_autocmd('BufWritePre', {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format { async = false }
            end,
          })
        end
        vim.keymap.set('n', '<leader>f', function()
          vim.lsp.buf.format()
        end, { desc = '[F]ormat buffer', buffer = bufnr })
      end,
    }
  end,
}
