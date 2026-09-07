_: {
  perSystem =
    { pkgs, lib, ... }:
    {
      # Recipes in ./justfile only shell out to nix, git and bash, so shipping
      # just itself is enough to run them on a machine that has nothing but
      # Nix installed: `nix run .#just -- <recipe>`.
      apps.just = {
        type = "app";
        program = lib.getExe pkgs.just;
        meta.description = "Run justfile recipes without installing just";
      };
    };
}
