# Nixvim template

This template gives you a good starting point for configuring nixvim standalone.

## Profiles

gmarlervim exposes profile presets through the `gmarlervim.profile` module
option.

The important detail is that the flake's default package and `nix run` use the
profile selected by `mkNixvimConfig`, which currently defaults to `standard`.
Changing the option default in `modules/gmarlervim/options/profiles.nix` only
changes the module fallback; it does not change the flake's default package on
its own.

In practice:

- `nix run` and `nix build` use the default flake package, which currently
  evaluates the `standard` profile.
- To select another profile, evaluate the package or config through
  `gmarlervim.lib.mkNixvimPackage` or `gmarlervim.lib.mkNixvimConfig` and pass
  `profile = "..."`.
- Available profiles are `minimal`, `basic`, `standard`, `full`, and `debug`.
  See the generated profile matrix in the docs for the evaluated differences.

Build and run the `debug` profile from a local checkout:

```bash
nix build --impure --expr '
let
  f = builtins.getFlake (toString ./.);
in
  f.lib.mkNixvimPackage {
    system = builtins.currentSystem;
    profile = "debug";
  }'
./result/bin/nvim
```

Use a specific profile from Home Manager:

```nix
{
  home.packages = [
    (let
      debugConfig = gmarlervim.lib.mkNixvimConfig {
        system = pkgs.system;
        profile = "debug";
      };
    in
      debugConfig.config.build.package)
  ];
}
```

## Configuring

To start configuring, just add or modify the nix files in `./config`. If you add
a new configuration file, remember to add it to the
[`config/default.nix`](./config/default.nix) file

## Testing your new configuration

To test your configuration simply run the following command

```
nix run .
```

## Config changes needed

- Format any language upon file save

## Inspirational Config Implementations:

- https://github.com/khaneliman/khanelivim
