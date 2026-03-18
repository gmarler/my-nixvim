{ config, lib, ... }:
{
  plugins.mini-cursorword =
    lib.mkIf (config.gmarlervim.ui.referenceHighlighting == "mini-cursorword")
      {
        enable = true;
        settings = {
          delay = 100; # Delay in milliseconds before highlighting
        };
      };
}
