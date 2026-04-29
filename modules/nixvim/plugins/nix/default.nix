{ pkgs, ... }:
{
  plugins = {
    # nixvim (nvim-nix) documentation
    # See: https://github.com/nix-community/nixvim
    direnv.enable = true;
    nix.enable = pkgs.stdenv.hostPlatform.isLinux;
    nix-develop.enable = true;
  };
}
