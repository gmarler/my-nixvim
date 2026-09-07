{ config, lib, ... }:
let
  gate = config.gmarlervim.integrations.accountBacked;

  # These plugins reach a local endpoint, so they need no account, token, or
  # API key. The account-backed gate must keep them.
  localPlugins = [ "minuet" ];
in
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
          "minuet"
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
      # The account-backed gate filters the merged value here. It cannot force
      # this option instead, because reading the list to filter it would create
      # an evaluation cycle.
      apply =
        plugins: if gate.enable && gate.ai.enable then plugins else lib.intersectLists plugins localPlugins;

      description = ''
        List of AI plugins to enable.
        Multiple plugins can be enabled simultaneously.
        Set to [] to disable all AI features.

        Disabling gmarlervim.integrations.accountBacked.ai keeps only the
        plugins that serve completions from a local endpoint.

        Available plugins:
        - avante: Claude AI interface with inline editing
        - claudecode: Claude Code integration
        - codecompanion: Chat/inline AI assistant; available adapters are
          chosen at runtime from the home or work adapter list configured by
          gmarlervim.ai.location
        - codex: OpenAI Codex integration
        - copilot: GitHub Copilot (includes chat)
        - copilot-lsp: GitHub Copilot LSP integration
        - minuet: Local completion at the cursor, served by ollama
        - opencode: OpenCode AI assistant with snacks integration
        - pairup: Claude-driven pair programming with inline markers; needs the
          claude CLI, so it is only usable where Claude is available
        - sidekick: Multi-provider AI suggestion system (Claude, Codex, Copilot,
          Antigravity, Opencode, PI). Each toggle binds only when its CLI is on
          PATH; only Antigravity's is shipped by this config
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
        ];
        description = ''
          CodeCompanion adapters allowed at work. Use "claude_code" for Claude
          via the claude-agent-acp bridge, which drives an already-authenticated
          CLI over ACP, so it works with enterprise sign-in and needs no API key.
          This list is independent of homeAdapters so work-specific services
          and credentials do not appear among the home choices. The first entry
          is the default.

          "gemini_cli" used to be here. nixpkgs flagged gemini-cli for removal
          after Google replaced it with Antigravity CLI, and `agy` has no ACP
          mode, so there is nothing to point the adapter at. Antigravity is
          reachable through sidekick instead.
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

    localEndpoint = lib.mkOption {
      type = lib.types.str;
      default = "http://127.0.0.1:8080/v1";
      example = "http://gpu-host.lan:8090/v1";
      description = ''
        OpenAI-compatible base URL for locally served models.

        The default points at a proxy on this machine, so the flake works on
        its own. A host that runs the model elsewhere, or on another port, sets
        this once and every plugin that reads it follows. minuet names ollama
        directly, because it needs a fill-in-the-middle endpoint the proxy does
        not serve.
      '';
    };

    duetEnable = lib.mkEnableOption "minuet next edit prediction" // {
      description = ''
        Predict the next edit with a local model through minuet's duet module.

        Needs "minuet" in gmarlervim.ai.plugins. Upstream calls duet
        experimental, so this stays off until a user opts in.

        Duet rewrites a region through a chat endpoint. Completion at the
        cursor uses a separate provider and a separate model.
      '';
    };
  };
}
