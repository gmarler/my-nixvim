{ lib, ... }:
{
  options.gmarlervim.ai = {
    plugins = lib.mkOption {
      type = lib.types.listOf (
        lib.types.enum [
          "avante"
          "claudecode"
          "codecompanion"
          "codex"
          "copilot"
          "copilot-lsp"
          "gemini"
          "opencode"
          "pairup"
          "sidekick"
          "windsurf"
        ]
      );
      default = [
        "claudecode"
        "codecompanion"
        "copilot"
        "copilot-lsp"
        "codex"
        "gemini"
        "opencode"
        "pairup"
        "sidekick"
      ];
      description = ''
        List of AI plugins to enable.
        Multiple plugins can be enabled simultaneously.
        Set to [] to disable all AI features.

        Available plugins:
        - avante: Claude AI interface with inline editing
        - claudecode: Claude Code integration
        - codecompanion: Chat/inline AI assistant; available adapters are
          chosen at runtime from the home or work adapter list configured by
          gmarlervim.ai.location
        - codex: OpenAI Codex integration
        - copilot: GitHub Copilot (includes chat)
        - copilot-lsp: GitHub Copilot LSP integration
        - opencode: OpenCode AI assistant with snacks integration
        - pairup: Claude-driven pair programming with inline markers; needs the
          claude CLI, so it is only usable where Claude is available
        - sidekick: Multi-provider AI suggestion system (Claude, Copilot, Gemini, Opencode)
        - windsurf: Codeium Windsurf integration
      '';
    };

    chatEnable = lib.mkEnableOption "AI chat functionality" // {
      default = true;
    };

    location = {
      envVar = lib.mkOption {
        type = lib.types.str;
        default = "NVIM_AI_PROFILE";
        description = ''
          Name of the environment variable read at Neovim startup to decide
          whether CodeCompanion should behave as if it's running at "work"
          or at "home". Set it in your shell/host profile, e.g.
          `export NVIM_AI_PROFILE=work`. No rebuild is needed to switch.
        '';
      };

      default = lib.mkOption {
        type = lib.types.enum [
          "home"
          "work"
        ];
        default = "home";
        description = ''
          Fallback location used when the envVar above is unset or holds an
          unrecognized value. Defaults to "home" so an unconfigured machine
          falls back to the local, credential-free llama.cpp adapter instead of
          a cloud adapter that may not be authenticated.
        '';
      };

      adapterEnvVar = lib.mkOption {
        type = lib.types.str;
        default = "NVIM_AI_ADAPTER";
        description = ''
          Name of the environment variable used to select a CodeCompanion
          adapter from the active location's adapter list. The first adapter
          in the list is used when this is unset or does not name an allowed
          adapter.
        '';
      };

      homeAdapters = lib.mkOption {
        type = lib.types.nonEmptyListOf lib.types.str;
        default = [
          "llamacpp"
          "codex"
        ];
        description = ''
          CodeCompanion adapters allowed at home. Use "llamacpp" for the
          local llama-swap server and "codex" for Codex ACP authenticated
          through ChatGPT. The first entry is the default.
        '';
      };

      workAdapters = lib.mkOption {
        type = lib.types.nonEmptyListOf lib.types.str;
        default = [
          "claude_code"
          "gemini_cli"
        ];
        description = ''
          CodeCompanion adapters allowed at work. Use "claude_code" for Claude
          via the claude-agent-acp bridge and "gemini_cli" for Gemini via
          `gemini --experimental-acp`. Both drive an already-authenticated CLI
          over ACP, so they work with enterprise sign-in and need no API key.
          This list is independent of homeAdapters so work-specific services
          and credentials do not appear among the home choices. The first entry
          is the default.
        '';
      };

      localModel = lib.mkOption {
        type = lib.types.str;
        default = "coder";
        description = ''
          Default llama-swap model alias. Override it at runtime via
          localModelEnvVar. It should be one of localModels.
        '';
      };

      localModels = lib.mkOption {
        type = lib.types.nonEmptyListOf lib.types.str;
        default = [
          "coder"
          "fast"
        ];
        description = ''
          Models offered by the local llama-swap server. These defaults match
          the aliases currently returned by its /v1/models endpoint.
        '';
      };

      localModelEnvVar = lib.mkOption {
        type = lib.types.str;
        default = "NVIM_AI_MODEL";
      };

      localEndpoint = lib.mkOption {
        type = lib.types.str;
        default = "http://127.0.0.1:8080";
      };
    };
  };
}
