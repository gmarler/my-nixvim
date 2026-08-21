{
  config,
  lib,
  pkgs,
  ...
}:
let
  loc = config.gmarlervim.ai.location;

  luaList = values: "{ ${lib.concatMapStringsSep ", " builtins.toJSON values} }";

  # Select only from the adapters allowed for the active location. The first
  # item provides a deterministic fallback for an unset or invalid selection.
  adapterExpr = ''
    (function()
      local profile = os.getenv(${builtins.toJSON loc.envVar})
      if profile ~= "home" and profile ~= "work" then
        profile = ${builtins.toJSON loc.default}
      end
      local adapters = profile == "work"
        and ${luaList loc.workAdapters}
        or ${luaList loc.homeAdapters}
      local selected = os.getenv(${builtins.toJSON loc.adapterEnvVar})

      for _, adapter in ipairs(adapters) do
        if adapter == selected then
          return adapter
        end
      end

      return adapters[1]
    end)()
  '';
in
{
  assertions = [
    {
      assertion = builtins.elem loc.localModel loc.localModels;
      message = "gmarlervim.ai.location.localModel must be included in localModels";
    }
  ];

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
        adapters.acp.codex.__raw = ''
          function()
            return require("codecompanion.adapters").extend("codex", {
              defaults = {
                auth_method = "chatgpt",
              },
            })
          end
        '';

        adapters.http.llamacpp.__raw = ''
          function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              env = {
                url = ${builtins.toJSON loc.localEndpoint},
                api_key = "unused",
              },

              schema = {
                model = {
                  default = os.getenv(${builtins.toJSON loc.localModelEnvVar})
                    or ${builtins.toJSON loc.localModel},
                  choices = ${luaList loc.localModels},
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

  extraPackages = lib.optionals config.plugins.codecompanion.enable [ pkgs.codex-acp ];

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
