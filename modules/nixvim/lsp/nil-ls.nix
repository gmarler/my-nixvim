{
  config,
  lib,
  pkgs,
  ...
}:
{
  # nil documentation
  # See: https://github.com/oxalica/nil
  lsp.servers.nil_ls = {
    enable = config.gmarlervim.lsp.nix == "nil-ls";

    config.settings = {
      formatting = {
        command = [ "${lib.getExe pkgs.nixfmt}" ];
      };
      nix = {
        flake = {
          autoArchive = true;
        };
      };
    };
  };
}
