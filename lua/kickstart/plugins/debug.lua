return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'williamboman/mason.nvim',
      'jay-babu/mason-nvim-dap.nvim',
      'mfussenegger/nvim-dap-python',
    },
    -- lazy = true,
    event = 'VeryLazy',
    config = function()
      require('mason-nvim-dap').setup {
        ensure_installed = {
          'debugpy', -- Python
          'codelldb', -- C, C++, Rust
          'js-debug-adapter', -- JavaScript/TypeScript
          'bash-debug-adapter',
          'delve', -- Go
        },
        automatic_installation = true,
      }

      local dap = require 'dap'

      dap.adapters.codelldb = {
        type = 'server',
        port = '${port}',
        executable = {
          command = 'codelldb', -- adjust as needed
          args = { '--port', '${port}' },
        },
      }

      dap.configurations.cpp = {
        {
          name = 'Launch file',
          type = 'codelldb',
          request = 'launch',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
        },
      }

      dap.configurations.c = dap.configurations.cpp
      dap.configurations.rust = dap.configurations.cpp

      dap.configurations.lua = {
        {
          type = 'nlua',
          request = 'attach',
          name = 'Attach to running Neovim instance',
        },
      }

      dap.adapters.nlua = function(callback, config)
        callback { type = 'server', host = config.host or '127.0.0.1', port = config.port or 8086 }
      end

      dap.adapters.bashdb = {
        type = 'executable',
        command = vim.fn.stdpath 'data' .. '/mason/packages/bash-debug-adapter/bash-debug-adapter',
        name = 'bashdb',
      }

      dap.configurations.sh = {
        {
          type = 'bashdb',
          request = 'launch',
          name = 'Launch file',
          showDebugOutput = true,
          pathBashdb = vim.fn.stdpath 'data' .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb',
          pathBashdbLib = vim.fn.stdpath 'data' .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir',
          trace = true,
          file = '${file}',
          program = '${file}',
          cwd = '${workspaceFolder}',
          pathCat = 'cat',
          pathBash = '/bin/bash',
          pathMkfifo = 'mkfifo',
          pathPkill = 'pkill',
          args = {},
          env = {},
          terminalKind = 'integrated',
        },
      }

      dap.adapters.python = function(cb, config)
        if config.request == 'attach' then
          ---@diagnostic disable-next-line: undefined-field
          local port = (config.connect or config).port
          ---@diagnostic disable-next-line: undefined-field
          local host = (config.connect or config).host or '127.0.0.1'
          cb {
            type = 'server',
            port = assert(port, '`connect.port` is required for a python `attach` configuration'),
            host = host,
            options = {
              source_filetype = 'python',
            },
          }
        else
          cb {
            type = 'executable',
            command = 'debugpy',
            args = { '-m', 'debugpy.adapter' },
            options = {
              source_filetype = 'python',
            },
          }
        end
      end

      require('dap-python').setup()

      dap.configurations.python = {
        {
          -- The first three options are required by nvim-dap
          type = 'python', -- the type here established the link to the adapter definition: `dap.adapters.python`
          request = 'launch',
          name = 'Launch file',

          -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

          program = '${file}', -- This configuration will launch the current file if used.
          pythonPath = function()
            local cwd = vim.fn.getcwd()
            if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
              return cwd .. '/venv/bin/python'
            elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
              return cwd .. '/.venv/bin/python'
            else
              return '/usr/bin/python'
            end
          end,
        },
      }

      dap.adapters.delve = {
        type = 'server',
        port = '${port}',
        executable = {
          command = 'dlv',
          args = { 'dap', '-l', '127.0.0.1:${port}' },
        },
      }

      -- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
      dap.configurations.go = {
        {
          type = 'delve',
          name = 'Debug',
          request = 'launch',
          program = '${file}',
        },
        {
          type = 'delve',
          name = 'Debug test', -- configuration for debugging test files
          request = 'launch',
          mode = 'test',
          program = '${file}',
        },
        -- works with go.mod packages and sub packages
        {
          type = 'delve',
          name = 'Debug test (go.mod)',
          request = 'launch',
          mode = 'test',
          program = './${relativeFileDirname}',
        },
      }

      dap.adapters['pwa-node'] = {
        type = 'server',
        host = 'localhost',
        port = '${port}',
        executable = {
          command = 'js-debug-adapter',
          args = { '${port}' },
        },
      }
      dap.configurations.javascript = {
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Launch file',
          program = '${file}',
          cwd = '${workspaceFolder}',
          runtimeExecutable = 'node',
        },
      }
      dap.configurations.typescript = dap.configurations.javascript
      dap.configurations.java = {
        {
          javaExec = 'java',
          request = 'launch',
          type = 'java',
        },
        {
          type = 'java',
          request = 'attach',
          name = 'Debug (Attach) - Remote',
          hostName = '127.0.0.1',
          port = 5005,
        },
      }
    end,
    keys = {
      {
        '<leader>dc',
        function()
          require('dap').continue()
        end,
        desc = 'Debug: Start/Continue',
      },
      {
        '<leader>dr',
        function()
          require('dap').run_last()
        end,
        desc = 'Debug: Rerun Last',
      },
      {
        '<leader>dq',
        function()
          require('dap').terminate()
        end,
        desc = 'Debug: Terminate',
      },
      {
        '<leader>dp',
        function()
          require('dap').pause()
        end,
        desc = 'Debug: Pause',
      },
      {
        '<leader>b',
        function()
          require('dap').toggle_breakpoint()
        end,
        desc = 'Debug: Toggle Breakpoint',
      },
      {
        '<leader>B',
        function()
          require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
        end,
        desc = 'Debug: Set Conditional Breakpoint',
      },
      {
        '<leader>di',
        function()
          require('dap').step_into()
        end,
        desc = 'Debug: Step Into',
      },
      {
        '<leader>do',
        function()
          require('dap').step_over()
        end,
        desc = 'Debug: Step Over',
      },
      {
        '<leader>ds',
        function()
          require('dap').step_out()
        end,
        desc = 'Debug: Step Out',
      },
      {
        '<leader>dt',
        function()
          require('dapui').toggle()
        end,
        desc = 'Debug: Toggle UI',
      },
    },
  },
  {
    'rcarriga/nvim-dap-ui',
    lazy = true,
    event = 'VeryLazy',
    opts = {},
    dependencies = { 'nvim-neotest/nvim-nio' },
  },
}
