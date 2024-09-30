{
  # Import all your configuration modules here
  imports = [
    ./keys.nix
    ./bufferline.nix
    ./settings.nix

    ./plugins/git/gitsigns.nix
    ./plugins/git/diffview.nix
    #./plugins/git/neogit.nix

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

    ./plugins/utils/mini.nix
    ./plugins/utils/whichkey.nix
    ./plugins/utils/persistence.nix

    ./plugins/statusline/lualine.nix

    ./plugins/telescope/telescope.nix

    ./ui/nvim-notify.nix
    ./ui/web-devicons.nix
  ];
}
