{
  config,
  lib,
  ...
}:
let
  loc = config.gmarlervim.ai.location;

  # Fallback adapter when envVar is unset or holds an unrecognized value.
  defaultAdapter = if loc.default == "work" then loc.workAdapter else loc.homeAdapter;

  # Resolved once when CodeCompanion's setup() table is built (i.e. at
  # startup/lazy-load), so setting the envVar before launching Neovim is
  # enough to switch location without a rebuild.
  adapterExpr = ''
    (os.getenv('${loc.envVar}') == 'work' and '${loc.workAdapter}')
      or (os.getenv('${loc.envVar}') == 'home' and '${loc.homeAdapter}')
      or '${defaultAdapter}'
  '';
in
{
  plugins = {
    codecompanion = {
      # codecompanion.nvim documentation
      # See: https://github.com/olimorris/codecompanion.nvim
      enable = builtins.elem "codecompanion" config.gmarlervim.ai.plugins;

      lazyLoad.settings = {
        cmd = [
          "CodeCompanion"
          "CodeCompanionChat"
          "CodeCompanionActions"
          "CodeCompanionAdd"
        ];
      };

      settings = {
        adapters.http.ollama.__raw = ''
          function()
            return require("codecompanion.adapters").extend("ollama", {
              schema = {
                model = {
                  default = os.getenv("${loc.ollamaModelEnvVar}") or "${loc.ollamaModel}",
                },
                num_ctx = {
                  default = ${toString loc.ollamaNumCtx},
                },
              },
            })
          end
        '';

        strategies = {
          chat = {
            adapter.__raw = adapterExpr;
          };
          inline = {
            adapter.__raw = adapterExpr;
          };
          cmd = {
            adapter.__raw = adapterExpr;
          };
        };
        display.chat.show_settings = true;
        opts = {
          send_code = true;
        };
      };
    };

    which-key.settings.spec = lib.optionals config.plugins.codecompanion.enable [
      {
        __unkeyed-1 = "<leader>ai";
        group = "CodeCompanion";
        icon = "";
        mode = [
          "n"
          "v"
        ];
      }
    ];
  };

  keymaps = lib.mkIf config.plugins.codecompanion.enable [
    {
      mode = "n";
      key = "<leader>ait";
      action = "<cmd>CodeCompanionChat Toggle<CR>";
      options = {
        desc = "Toggle Chat";
      };
    }
    {
      mode = "n";
      key = "<leader>aic";
      action = "<cmd>CodeCompanionChat<CR>";
      options = {
        desc = "New Chat";
      };
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>aia";
      action = "<cmd>CodeCompanionActions<CR>";
      options = {
        desc = "Actions";
      };
    }
    {
      mode = "v";
      key = "<leader>aie";
      action = "<cmd>CodeCompanion<CR>";
      options = {
        desc = "Inline Edit";
      };
    }
    {
      mode = "n";
      key = "<leader>aiq";
      action = "<cmd>CodeCompanion /commit<CR>";
      options = {
        desc = "Quick Commit Message";
      };
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>air";
      action = "<cmd>CodeCompanionAdd<CR>";
      options = {
        desc = "Add to Chat";
      };
    }
  ];
}
