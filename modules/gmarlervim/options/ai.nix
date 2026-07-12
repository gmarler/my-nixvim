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
          falls back to the local, credential-free Ollama adapter instead of
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
        default = "ollama";
        description = ''
          CodeCompanion adapter name used at "home". Defaults to the
          built-in "ollama" HTTP adapter, which always targets an Ollama
          server local to the host running Neovim.
        '';
      };

      ollamaModel = lib.mkOption {
        type = lib.types.str;
        default = "qwen2.5-coder:7b";
        description = ''
          Default Ollama model used by the home adapter. Overridable without
          a rebuild via the environment variable named by ollamaModelEnvVar.
        '';
      };

      ollamaModelEnvVar = lib.mkOption {
        type = lib.types.str;
        default = "NVIM_OLLAMA_MODEL";
        description = ''
          Name of the environment variable that, when set, overrides
          ollamaModel at Neovim startup, e.g. `export
          NVIM_OLLAMA_MODEL=llama3.1`.
        '';
      };

      ollamaNumCtx = lib.mkOption {
        type = lib.types.ints.positive;
        default = 65536;
        description = ''
          Context window size (num_ctx, in tokens) requested from the local
          Ollama server. Larger values need proportionally more memory for
          the KV cache and may exceed what a given model was actually
          trained/extended for, which can degrade quality past that point.
        '';
      };
    };
  };
}
