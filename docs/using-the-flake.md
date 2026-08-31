# Using the Flake

my-nixvim supports four main ways of working with the config.

## 1. Run The Default Package

This is the fastest way to try it. The default package currently builds the
`standard` profile.

```bash
nix run github:gmarler/my-nixvim
```

From a local checkout:

```bash
nix run
```

`nix run` does not create a garbage collection root. The closure it builds is
dead as soon as the command exits, so the next garbage collection deletes it and
the following `nix run` downloads it all again. Use `nix run` to try the config
or to test a change, not as an everyday launcher.

## 2. Install It Into A Nix Profile

This is the supported way to use the config day to day without Home Manager. A
profile generation is a persistent garbage collection root, so the closure is
built once and then kept.

```bash
just install
```

That is equivalent to:

```bash
nix profile install \
  --profile "${XDG_STATE_HOME:-$HOME/.local/state}/nix/profiles/gmarlervim" .
```

The dedicated profile is deliberate. It keeps `nix profile upgrade --all` scoped
to this config, and it leaves the default profile (`~/.nix-profile`) alone,
which matters if another tool has already claimed it.

Launch Neovim by absolute path, so `PATH` ordering never matters:

```bash
"${XDG_STATE_HOME:-$HOME/.local/state}/nix/profiles/gmarlervim/bin/nvim"
```

That path is a symlink into the profile's current generation. It stays valid
across upgrades, so it is safe to hard-code in a shell alias, a desktop entry,
or `$EDITOR`.

### Upgrading

Rebuild the profile from the current working tree:

```bash
just upgrade
```

Uncommitted work is included. Nix reads the working tree rather than `HEAD`, so
modified, staged, and untracked files are all picked up; only paths matched by
`.gitignore` are excluded. Nothing has to be committed or `git add`ed first.

After the first install from a dirty tree the recorded flake URL carries no
`rev`, so every later upgrade re-reads the working tree too.

Working from a dirty tree has two costs:

- Each upgrade re-evaluates the whole flake, because the evaluation cache needs
  the stable fingerprint that only a clean tree provides. The builds that follow
  evaluation are still incremental.
- Old generations stay pinned. They share most store paths, so growth is modest,
  but `just wipe-history` drops them when you want the disk back.

## 3. Install It From Home Manager

The supported Home Manager workflow is to install the built Neovim package via
`home.packages`.

```nix
{
  home.packages = [
    gmarlervim.packages.${pkgs.system}.default
  ];
}
```

This repo does not expose a dedicated Home Manager module for configuration. Use
the package or build a customized package through the flake `lib` helpers.

## 4. Build A Customized Config

Use `gmarlervim.lib.mkNixvimConfig` when you want an evaluated config you can
extend with modules, or `gmarlervim.lib.mkNixvimPackage` when you only need the
final package.

Pick a non-default profile directly:

```nix
let
  debugConfig = gmarlervim.lib.mkNixvimConfig {
    system = pkgs.system;
    profile = "debug";
  };
in
  debugConfig.config.build.package
```

Extend a base profile with your own overrides:

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

Prefer the high-level `gmarlervim.*` options when possible. Drop to `plugins.*`
or raw Lua only when the curated option surface does not already cover what you
need.
