{
  config,
  lib,
  self,
  system,
  ...
}:
let
  cfg = config.plugins.pairup;

  luaConfig = ''
    require('pairup').setup(${lib.nixvim.toLuaObject cfg.settings})
  '';
in
{
  # TODO: Consider upstreaming this module to nixvim
  options.plugins.pairup = {
    enable = lib.mkEnableOption "pairup" // {
      default = builtins.elem "pairup" config.gmarlervim.ai.plugins;
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = self.packages.${system}.pairup;
      defaultText = lib.literalExpression "self.packages.\${system}.pairup";
      description = "The pairup.nvim plugin package to use.";
    };

    settings = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = {
        provider = "claude";

        git = {
          enabled = true;
          diff_context_lines = 10;
        };

        terminal = {
          split_position = "left";
          split_width = 0.4;
          auto_insert = false;
          auto_scroll = true;
        };

        inline = {
          quickfix = true;
          auto_process = true;
        };

        # pairup's operator keys are registered globally by setup(). "gC" and
        # "g!" are unused here, but its default plan key "g?" would shadow
        # debugprint, which owns that whole prefix and lazy-loads on it.
        operator = {
          command_key = "gC";
          constitution_key = "g!";
          plan_key = "gZ";
        };

        # Writing straight into 'statusline' fights lualine. pairup ships
        # lua/lualine/components/pairup.lua for that instead.
        statusline.auto_inject = false;
      };
      description = ''
        Configuration for pairup.

        See <https://github.com/Piotr1215/pairup.nvim>
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # pairup drives the claude CLI directly, not the ACP bridge.
    dependencies.claude-code.enable = lib.mkDefault true;

    extraConfigLua = lib.mkIf (!config.plugins.lz-n.enable) luaConfig;

    extraPlugins = [
      {
        plugin = cfg.package;
        optional = config.plugins.lz-n.enable;
      }
    ];

    plugins = {
      lz-n.plugins = [
        {
          __unkeyed-1 = "pairup.nvim";
          cmd = [ "Pairup" ];
          after = ''
            function()
              ${luaConfig}
            end
          '';
        }
      ];

      which-key.settings.spec = [
        {
          __unkeyed-1 = "<leader>ap";
          group = "Pairup";
          icon = "";
          mode = [
            "n"
            "v"
          ];
        }
      ];
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>apt";
        action = "<cmd>Pairup toggle<CR>";
        options = {
          desc = "Toggle Pairup Terminal";
        };
      }
      {
        mode = "n";
        key = "<leader>aps";
        action = "<cmd>Pairup start<CR>";
        options = {
          desc = "Start Pairup Session";
        };
      }
      {
        mode = "n";
        key = "<leader>apS";
        action = "<cmd>Pairup stop<CR>";
        options = {
          desc = "Stop Pairup Session";
        };
      }
      {
        mode = "n";
        key = "<leader>apd";
        action = "<cmd>Pairup diff<CR>";
        options = {
          desc = "Send Git Diff";
        };
      }
      {
        mode = "n";
        key = "<leader>apl";
        action = "<cmd>Pairup lsp<CR>";
        options = {
          desc = "Send LSP Diagnostics";
        };
      }
      {
        mode = "n";
        key = "<leader>api";
        action = "<cmd>Pairup inline<CR>";
        options = {
          desc = "Process Inline Markers";
        };
      }
      {
        mode = "n";
        key = "<leader>apm";
        action = "<cmd>Pairup markers claude<CR>";
        options = {
          desc = "List Claude Markers";
        };
      }
      {
        mode = "n";
        key = "<leader>apq";
        action = "<cmd>Pairup markers user<CR>";
        options = {
          desc = "List User Questions";
        };
      }
      {
        mode = "n";
        key = "<leader>apP";
        action = "<cmd>Pairup markers proposals<CR>";
        options = {
          desc = "List Proposals";
        };
      }
      {
        mode = "n";
        key = "<leader>apa";
        action = "<cmd>Pairup accept<CR>";
        options = {
          desc = "Accept Proposal At Cursor";
        };
      }
      {
        mode = "n";
        key = "<leader>ape";
        action = "<cmd>Pairup edit<CR>";
        options = {
          desc = "Edit Proposal";
        };
      }
      {
        mode = "n";
        key = "<leader>apn";
        action = "<cmd>Pairup next<CR>";
        options = {
          desc = "Next Proposal";
        };
      }
      {
        mode = "n";
        key = "<leader>app";
        action = "<cmd>Pairup prev<CR>";
        options = {
          desc = "Previous Proposal";
        };
      }
      {
        mode = "n";
        key = "<leader>apz";
        action = "<cmd>Pairup suspend<CR>";
        options = {
          desc = "Suspend Auto-Processing";
        };
      }
    ];
  };
}
