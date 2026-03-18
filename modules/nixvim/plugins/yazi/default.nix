{ config, lib, ... }:
{
  plugins = {
    yazi = {
      # yazi.nvim documentation
      # See: https://github.com/mikavilpas/yazi.nvim
      enable = config.gmarlervim.editor.fileManager == "yazi";

      lazyLoad = {
        settings = {
          cmd = [
            "Yazi"
          ];
        };
      };
    };

    which-key.settings.spec = lib.optionals (config.gmarlervim.editor.fileManager == "yazi") [
      {
        __unkeyed-1 = "<leader>e";
        icon = "󰪶";
      }
      {
        __unkeyed-1 = "<leader>E";
        icon = "󰪶";
      }
    ];
  };

  keymaps = lib.optionals (config.gmarlervim.editor.fileManager == "yazi") [
    {
      mode = "n";
      key = "<leader>e";
      action = "<CMD>Yazi<CR>";
      options = {
        desc = "Yazi (current file)";
      };
    }
    {
      mode = "n";
      key = "<leader>E";
      action = "<CMD>Yazi toggle<CR>";
      options = {
        desc = "Yazi (resume)";
      };
    }
  ];
}
