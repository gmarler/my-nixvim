# Customizing my-nixvim

my-nixvim is meant to be customized in layers, from the highest-level option
surface down to raw plugin or Lua overrides when needed.

## Preferred Order

Use the narrowest layer that solves the problem cleanly:

1. `gmarlervim.*` options
2. `plugins.*` overrides
3. `extraConfigLua`

This keeps customizations easier to reason about and less likely to break when
internal plugin wiring changes.

## 1. Use `gmarlervim.*` First

The curated `gmarlervim.*` options are the intended public surface for choosing
major workflows, UI components, and language tooling.

Examples:

```nix
{
  gmarlervim.editor.fileManager = "yazi";
  gmarlervim.ui.keybindingHelp = "which-key";
  gmarlervim.lsp.java = "nvim-java";
}
```

Use the generated `Options Reference` when looking for the supported knobs.

## 2. Override `plugins.*` When The Public Surface Is Too Coarse

Drop to plugin-specific settings when the feature already exists in the plugin,
but gmarlervim does not expose a dedicated `gmarlervim.*` option for it.

Examples:

```nix
{
  plugins.lualine.settings.options.theme = "gruvbox";
  plugins.typescript-tools.settings.settings.tsserver_max_memory = "auto";
}
```

This is still a Nix-level override, so it is usually safer than patching things
with raw Lua.

## 3. Use `extraConfigLua` For Truly Local Behavior

Use `extraConfigLua` when you need editor behavior that is:

- specific to your own setup
- too small to justify a dedicated option
- not cleanly expressed through existing module settings

Example:

```nix
{
  extraConfigLua = ''
    vim.opt.relativenumber = false
  '';
}
```

Prefer small, targeted Lua additions over large private rewrites of the config.

## Extend Instead Of Forking

The normal customization model is to evaluate a base config, then extend it with
your own module overrides.

```nix
let
  customConfig = (gmarlervim.lib.mkNixvimConfig {
    system = pkgs.system;
    profile = "minimal";
  }).extendModules {
    modules = [
      {
        gmarlervim.editor.fileManager = "yazi";
        gmarlervim.ui.keybindingHelp = "which-key";
        extraConfigLua = ''
          vim.opt.relativenumber = false
        '';
      }
    ];
  };
in
  customConfig.config.build.package
```

This lets you keep the upstream module graph and only replace the parts you
actually care about.

## What To Avoid

- Editing `modules/nixvim/plugins/*` just to customize your own local install
- Copying large chunks of generated or internal config into `extraConfigLua`
- Treating internal module layout as a stable public API

If the change is broadly useful, it should usually become a new `gmarlervim.*`
option rather than a permanent private patch.
