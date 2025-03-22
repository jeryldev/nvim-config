-- lua/custom/plugins/php.lua
return {
  -- PHP Language Server with Intelephense
  {
    'neovim/nvim-lspconfig',
    opts = function(_, opts)
      -- Ensure opts.servers exists
      opts.servers = opts.servers or {}

      -- Configure PHP language server
      opts.servers.intelephense = {
        settings = {
          intelephense = {
            files = {
              maxSize = 1000000,
            },
            stubs = {
              -- Core PHP stubs
              'apache',
              'bcmath',
              'bz2',
              'calendar',
              'Core',
              'curl',
              'date',
              'dom',
              'fileinfo',
              'filter',
              'ftp',
              'gd',
              'hash',
              'iconv',
              'json',
              'libxml',
              'mbstring',
              'mysqli',
              'openssl',
              'pcre',
              'PDO',
              'pdo_mysql',
              'Phar',
              'posix',
              'Reflection',
              'session',
              'SimpleXML',
              'SPL',
              'sqlite3',
              'standard',
              'superglobals',
              'tokenizer',
              'xml',
              'xmlreader',
              'xmlwriter',
              'zip',
              'zlib',

              -- Laravel stubs if using Laravel
              'laravel',
              'blade',
              'eloquent',
            },
            environment = {
              phpVersion = '8.2',
            },
            completion = {
              insertUseDeclaration = true,
              fullyQualifyGlobalConstantsAndFunctions = false,
              triggerParameterHints = true,
            },
          },
        },
      }

      return opts
    end,
  },

  -- Make sure PHP is included in Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      if type(opts.ensure_installed) == 'table' then
        vim.list_extend(opts.ensure_installed, { 'php', 'phpdoc' })
      end
      return opts
    end,
  },

  -- Configure Laravel Pint for formatting (if you're using conform)
  {
    'stevearc/conform.nvim',
    optional = true,
    opts = function(_, opts)
      if type(opts.formatters_by_ft) == 'table' then
        opts.formatters_by_ft.php = { 'pint' }
      end
      return opts
    end,
  },
}
