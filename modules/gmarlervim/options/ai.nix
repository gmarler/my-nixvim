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
        "sidekick"
      ];
      description = ''
        List of AI plugins to enable.
        Multiple plugins can be enabled simultaneously.
        Set to [] to disable all AI features.

        Available plugins:
        - avante: Claude AI interface with inline editing
        - claudecode: Claude Code integration
        - codecompanion: Chat/inline AI assistant; adapter is chosen at
          runtime by gmarlervim.ai.location (Claude Code at work, local
          Ollama at home)
        - codex: OpenAI Codex integration
        - copilot: GitHub Copilot (includes chat)
        - copilot-lsp: GitHub Copilot LSP integration
        - opencode: OpenCode AI assistant with snacks integration
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

      workAdapter = lib.mkOption {
        type = lib.types.str;
        default = "claude_code";
        description = ''
          CodeCompanion adapter name used at "work". Defaults to the
          claude_code ACP adapter, which drives the Claude Code CLI/agent
          directly. Set to "anthropic" to use the plain HTTP adapter
          (ANTHROPIC_API_KEY only, no ACP bridge dependency) instead.
        '';
      };

      homeAdapter = lib.mkOption {
        type = lib.types.str;
        default = "llamacpp";
        description = ''
          CodeCompanion adapter name used at "home". Defaults to the
          local llama.cpp server exposed via llama-swap using the OpenAI-compatible API.
        '';
      };

      localModel = lib.mkOption {
        type = lib.types.str;
        default = "coder";
        description = ''
          Default llama-swap model alias. Override via localModelEnvVar.
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
