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
        # Upstream declares env.CLAUDE_CODE_OAUTH_TOKEN = "CLAUDE_CODE_OAUTH_TOKEN".
        # When that variable is unset, get_env_vars falls through to the literal
        # string, so handlers.auth sees a non-empty token, exports the literal
        # into the child environment and reports the session authenticated,
        # skipping ACP auth negotiation. Returning nil drops the key instead, so
        # negotiation proceeds against the already-authenticated CLI. A real
        # token, when present, still behaves as upstream.
        adapters.acp.claude_code.__raw = ''
          function()
            return require("codecompanion.adapters").extend("claude_code", {
              env = {
                CLAUDE_CODE_OAUTH_TOKEN = function()
                  return os.getenv("CLAUDE_CODE_OAUTH_TOKEN")
                end,
              },
            })
          end
        '';

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

  # ACP adapters spawn a CLI over stdio and inherit Neovim's environment, so an
  # already-authenticated CLI needs no API key. claude_code drives Zed's
  # claude-agent-acp bridge rather than the claude binary itself.
  extraPackages = lib.optionals config.plugins.codecompanion.enable [
    pkgs.claude-agent-acp
    pkgs.codex-acp
    pkgs.gemini-cli
  ];

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
