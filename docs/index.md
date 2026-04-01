[book] authors = ["gmarler"] language = "en" src = "." title = "gmarlervim Docs"

[output.html] default-theme = "navy" preferred-dark-theme = "navy"
git-repository-url = "https://gitlab.com/gmarler/gmarlervim" site-url = "/"

# gmarlervim Docs

This site is built from the flake and the evaluated profile configuration.

The profile matrix is generated from `mkNixvimConfig`, so it tracks the
effective `gmarlervim.profile` behavior instead of hand-maintained README prose.

## Commands

```bash
nix build .#docs-html
nix run .#docs
```

# Included Pages

- `Selecting Profiles` explains how the flake default is chosen and how to build
  a non-default profile.
- `Options Reference` documents the `gmarlervim.*` option surface from the
  evaluated module tree.
- `Profile Matrix` shows the evaluated enablement for each profile.
- `Docs Pipeline` explains how the generated site is built.
