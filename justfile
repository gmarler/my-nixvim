# Like GNU `make`, but `just` rustier.
# https://just.systems/
# run `just` from this directory to see available commands

# Dedicated Nix profile managed by `install`, `upgrade`, and `wipe-history`.
# Kept separate from the default profile so `--all` only ever touches this config.
nvim_profile := "${XDG_STATE_HOME:-$HOME/.local/state}/nix/profiles/gmarlervim"

# Default command when 'just' is run without arguments
default:
  @just --list

# Update nix flake
[group('Main')]
update:
  nix flake update

# Lint nix files
[group('dev')]
lint:
  nix fmt

# Check nix flake
[group('dev')]
check:
  nix flake check

# Manually enter dev shell
[group('dev')]
dev:
  nix develop

# Activate the configuration
[group('Main')]
run:
  nix run

# Install the default package into the dedicated Nix profile
[group('Main')]
install:
  nix profile install --profile "{{nvim_profile}}" .
  @echo "Launch with: {{nvim_profile}}/bin/nvim"

# Rebuild the profile from the working tree, uncommitted changes included
[group('Main')]
upgrade:
  nix profile upgrade --profile "{{nvim_profile}}" --all
  @echo "Launch with: {{nvim_profile}}/bin/nvim"

# Drop old profile generations so their closures can be garbage collected
[group('Main')]
wipe-history:
  nix profile wipe-history --profile "{{nvim_profile}}"

# Benchmark key flake eval paths (single tree)
[group('perf')]
eval-bench:
  #!/usr/bin/env bash
  set -euo pipefail
  sys="$(XDG_CACHE_HOME=/tmp nix eval --impure --raw --expr 'builtins.currentSystem')"
  nix run nixpkgs#hyperfine -- --warmup 3 --runs 10 \
    "XDG_CACHE_HOME=/tmp nix eval --option eval-cache false .#packages.$sys.default.drvPath >/dev/null" \
    "XDG_CACHE_HOME=/tmp nix eval --option eval-cache false .#nixvimConfigurations.$sys.gmarlervim.config.build.package.drvPath >/dev/null" \
    "XDG_CACHE_HOME=/tmp nix flake show --option eval-cache false >/dev/null"

# Benchmark current tree against a git ref
[group('perf')]
eval-bench-against ref:
  #!/usr/bin/env bash
  set -euo pipefail
  base_rev="$(git rev-parse {{ref}})"
  base="git+file://$PWD?rev=$base_rev"
  sys="$(XDG_CACHE_HOME=/tmp nix eval --impure --raw --expr 'builtins.currentSystem')"
  echo "Comparing current tree against $base_rev on $sys"
  nix run nixpkgs#hyperfine -- --warmup 3 --runs 10 \
    "XDG_CACHE_HOME=/tmp nix eval --option eval-cache false .#packages.$sys.default.drvPath >/dev/null" \
    "XDG_CACHE_HOME=/tmp nix eval --option eval-cache false '$base#packages.$sys.default.drvPath' >/dev/null"
  nix run nixpkgs#hyperfine -- --warmup 3 --runs 10 \
    "XDG_CACHE_HOME=/tmp nix eval --option eval-cache false .#nixvimConfigurations.$sys.gmarlervim.config.build.package.drvPath >/dev/null" \
    "XDG_CACHE_HOME=/tmp nix eval --option eval-cache false '$base#nixvimConfigurations.$sys.gmarlervim.config.build.package.drvPath' >/dev/null"
  nix run nixpkgs#hyperfine -- --warmup 3 --runs 10 \
    "XDG_CACHE_HOME=/tmp nix flake show --option eval-cache false >/dev/null" \
    "XDG_CACHE_HOME=/tmp nix flake show --option eval-cache false '$base' >/dev/null"
