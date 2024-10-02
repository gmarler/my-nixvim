{
  # Import all your configuration modules here
  imports = [
    ./keys.nix
    ./bufferline.nix
    ./settings.nix

    ./plugins/colorschemes/gruvbox.nix
    ./plugins/colorschemes/catppuccin.nix
    ./plugins/colorschemes/tokyonight.nix

    ./plugins/completion/cmp.nix
    ./plugins/completion/lspkind.nix

    ./plugins/dap/dap.nix

    ./plugins/git/gitsigns.nix
    ./plugins/git/diffview.nix
    ./plugins/git/neogit.nix

    ./languages/nvim-lint.nix
    ./languages/typescript-tools-nvim.nix
    ./languages/treesitter/treesitter.nix
    ./languages/treesitter/treesitter-context.nix
    ./languages/treesitter/treesitter-textobjects.nix
    ./languages/treesitter/ts-autotag.nix
    ./languages/treesitter/ts-context-commentstring.nix

    ./plugins/lsp/conform.nix
    ./plugins/lsp/fidget.nix
    ./plugins/lsp/lsp.nix
    ./plugins/lsp/lspsaga.nix
    ./plugins/lsp/trouble.nix

    ./plugins/none-ls/none-ls.nix

    ./plugins/utils/harpoon.nix
    ./plugins/utils/markdown-preview.nix
    ./plugins/utils/mini.nix
    ./plugins/utils/nvim-autopairs.nix
    ./plugins/utils/nvim-colorizer.nix
    ./plugins/utils/nvim-surround.nix
    ./plugins/utils/persistence.nix
    ./plugins/utils/plenary.nix
    ./plugins/utils/undotree.nix
    ./plugins/utils/whichkey.nix

    ./plugins/snippets/luasnip.nix

    ./plugins/statusline/lualine.nix
    ./plugins/statusline/staline.nix

    ./plugins/telescope/telescope.nix

    ./ui/noice.nix
    ./ui/nui.nix
    ./ui/nvim-notify.nix
    ./ui/web-devicons.nix
  ];
}
