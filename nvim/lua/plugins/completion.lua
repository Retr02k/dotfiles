return {
  -- the completion engine
  {
    'saghen/blink.cmp',
    dependencies = { 'rafamadriz/friendly-snippets' }, -- optional: snippet library
    version = '1.*', -- pin to stable; v2 is still under active development

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
		  preset = 'default',
		  ['<CR>'] = {'accept', 'fallback'},
	  },	-- ENTER accept, C-n/C-p navigate, C-space open, C-e dismiss
      completion = { documentation = { auto_show = false } }, -- flip to true to see docs as you type
      sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },
    },
    opts_extend = { 'sources.default' },
  },

  -- language servers: Mason installs them, lspconfig ships their configs
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'saghen/blink.cmp',
      'mason-org/mason.nvim',
      'mason-org/mason-lspconfig.nvim',
    },
    config = function()
      -- advertise blink.cmp's extra capabilities (snippets etc.) to every server
      vim.lsp.config('*', {
        capabilities = require('blink.cmp').get_lsp_capabilities(),
      })

      require('mason').setup()
      require('mason-lspconfig').setup({
        ensure_installed = { 'clangd', 'pyright', 'lua_ls' }, -- C, Python, Lua — add more as you need them
      })
    end,
  },
}
