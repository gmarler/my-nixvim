{
  # Import all your configuration modules here
  imports = [
    ./keys.nix
    ./bufferline.nix
    ./settings.nix

    ./plugins/git/gitsigns.nix
    ./plugins/git/diffview.nix
    #./plugins/git/neogit.nix

    ./plugins/lsp/conform.nix
    ./plugins/lsp/fidget.nix
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
