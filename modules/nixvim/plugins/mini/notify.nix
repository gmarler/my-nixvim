{ config, lib, ... }:
{
  plugins = lib.mkIf (config.gmarlervim.ui.notifications == "mini-notify") {
    mini = {
      enable = true;

      modules = {
        notify = {
          # Configuration for mini.notify
          # Uses vim.notify() interface
        };
      };
    };
  };
}
