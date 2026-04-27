# Nixvim template

This is a fully customized Neovim configuration, built with Nix and the powerful
[Nixvim flake](https://github.com/nix-community/nixvim). It is meant to be
reproducible, portable, and easy to extend without maintaining a separate Lua
config per machine.

## Key Features

- **Nixvim for Declarative Configuration:** Leverage Nix expressions for a clean
  and maintainable Neovim setup with 100+ carefully configured plugins.
- **AI-Powered Development:** Integrated GitHub Copilot, Claude Code, Avante,
  and Blink completion for intelligent coding assistance.
- **Modern Plugin Architecture:** Modular plugin system with lazy loading and
  comprehensive language support for 20+ programming languages.
- **Advanced Navigation:** Multiple fuzzy finders (FZF-Lua, Snacks Picker) for
  quick file and symbol searching.
- **Comprehensive Git Integration:** Full Git workflow support with Gitsigns,
  Diffview, Git Conflict resolution, and worktree management.
- **Debugging & Testing:** Complete debugging setup with DAP and Neotest for
  multiple languages.
- **Consistent Environments:** Reproduce your Neovim setup on any system with
  Nix installed.

## Prerequisites

- **Nix Package Manager:** Ensure Nix is installed on your system. Follow the
  instructions at
  [https://nixos.org/download.html](https://nixos.org/download.html).

## Installation

Run the default `standard` profile directly:

```bash
nix run --extra-experimental-features 'nix-command flakes' github:gmarler/my-nixvim
```

Build and run from a local checkout:

```bash
git clone https://github.com/gmarler/gmarlervim.git
cd my-nixvim
nix run
```

Install it from Home Manager via `home.packages`:

```nix
{
  home.packages = [
    my-nixvim.packages.${pkgs.system}.default
  ];
}
```

## Docs

The generated docs are the canonical reference for profiles, options, and
workflow details.

```bash
nix build .#docs-html
nix run .#docs
```

Start here:

- `Using the Flake` for the supported ways to run, install, and customize this
  config
- `Selecting Profiles` for `minimal`, `basic`, `standard`, `full`, and `debug`
- `Options Reference` for the `gmarlervim.*` module surface
- `Profile Matrix` for the evaluated differences between profiles
- `Language Tooling Workflows` for the runtime LSP and language-tooling model

## Profiles

my-nixvim exposes profile presets through the `gmarlervim.profile` module
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

## Development Commands

```bash
# Update flake dependencies
nix flake update

# Check flake for issues
nix flake check

# Format/Lint code
nix fmt
deadnix -e
statix fix .

# Enter development shell
nix develop

# Run Neovim
nix run
```

### LSP Servers

The configuration includes a comprehensive list of LSP servers to support
various programming languages, including:

- **Bash/Shell** - bashls
- **C/C++** - ccls, clangd with extensions
- **C#/.NET** - roslyn, csharp-ls
- **CSS/SCSS/Less** - cssls
- **Docker** - dockerls
- **Go** - gopls
- **HTML** - html
- **Java** - jdtls (dedicated plugin)
- **JavaScript/TypeScript** - typescript-tools, eslint
- **JSON** - jsonls
- **Lua** - lua-ls with lazydev
- **Markdown** - marksman, harper-ls
- **Nix** - nil-ls, nixd
- **Python** - basedpyright, ruff
- **Rust** - rust-analyzer (via rustaceanvim)
- **SQL** - sqls
- **TOML** - taplo
- **YAML** - yamlls
- **Helm** - helm-ls
- **Typos** - typos-lsp

Each server has specific settings tailored to its language, such as filetype
associations, initialization options, and formatting configurations.

### LSP Keymappings

my-nixvim splits runtime tooling into two groups:

- `<leader>l` for generic LSP and diagnostics actions
- `<leader>z` for language-specific tooling in the current buffer

- **Code Navigation:**
  - `gd`, `grr`, `gri`, `K`, and `gx` still use Neovim's built-in LSP motions
  - `<leader>ld`, `<leader>li`, `<leader>lt` expose definition, implementation,
    and type definition in the LSP group

- **Code Actions:**
  - `<leader>la` - Code actions
  - `<leader>lr` - Rename symbol
  - `<leader>lf` - Format code
  - `<leader>lT` - Show current buffer tooling details
  - `<leader>lI` / `<leader>lX` - LSP health and restart

- **Diagnostics:**
  - `<leader>l[` / `<leader>l]` - Previous/next diagnostic
  - `<leader>lH` - Show line diagnostics
  - `<leader>lq`, `<leader>le`, `<leader>lE`, `<leader>lW` - Buffer/workspace
    diagnostics and error lists
  - `<leader>lQ` - Request workspace diagnostics when the attached LSP supports
    them

- **Language-specific tooling:**
  - TypeScript, Rust, Python, and .NET add buffer-local actions under
    `<leader>z`
  - Examples include import organization, Rust runnables, Python env/test
    helpers, and .NET build/debug/test flows

### Additional Features:

- **Automatic formatting** via conform.nvim with workspace-aware formatter
  ownership for Biome and Prettier
- **Linting integration** with various linters through nvim-lint
- **Code completion** powered by Blink with LSP, Copilot, and snippet sources
- **Debugging support** via DAP with UI and virtual text
- **Testing integration** through Neotest with multiple language adapters
- **Workspace-aware diagnostics ownership** so Biome and ESLint do not both stay
  active in the same JS/TS workspace
- **Project-wide search** and refactoring tools (Spectre, Grug-far,
  Refactoring.nvim)

## Key Mappings

### Essential Navigation

| Key       | Action         | Description                    |
| --------- | -------------- | ------------------------------ |
| `<Space>` | Leader key     | Primary prefix for custom maps |
| `<Esc>`   | Clear search   | Clear search highlighting      |
| `<C-c>`   | Switch buffer  | Toggle between recent buffers  |
| `j/k`     | Smart movement | Visual line aware movement     |
| `Y`       | Yank to end    | Yank to end of line            |

### Window & Buffer Management

| Key               | Action            | Description          |
| ----------------- | ----------------- | -------------------- |
| `<TAB>`           | Next buffer       | Navigate buffers     |
| `<S-TAB>`         | Previous buffer   | Navigate buffers     |
| `\|`              | Vertical split    | Split window         |
| `-`               | Horizontal split  | Split window         |
| `<leader>[/]/,/.` | Window nav        | Move between windows |
| `<leader>w`       | Save file         | Write current buffer |
| `<leader>q`       | Quit with confirm | Safe quit            |
| `<C-w>`           | Close buffer      | Smart buffer close   |

### File Finding & Search

| Key               | Action            | Description              |
| ----------------- | ----------------- | ------------------------ |
| `<leader><space>` | Smart find files  | Main file finder         |
| `<leader>ff`      | Find files        | Standard file finder     |
| `<leader>fo`      | Recent files      | Recently opened files    |
| `<leader>fb`      | Find buffers      | List open buffers        |
| `<leader>fw`      | Live grep         | Search in files          |
| `<leader>f/`      | Buffer fuzzy find | Search in current buffer |
| `<leader>fh`      | Find help         | Search help tags         |
| `<leader>fk`      | Find keymaps      | Search keybindings       |
| `<leader>fc`      | Find commands     | Search commands          |

### File Management

| Key          | Action        | Description            |
| ------------ | ------------- | ---------------------- |
| `<leader>e`  | File explorer | Open Yazi file manager |
| `<leader>E`  | File explorer | Toggle Neo-tree/Yazi   |
| `<leader>fe` | File explorer | Snacks file explorer   |

### Git Integration

| Key               | Action         | Description            |
| ----------------- | -------------- | ---------------------- |
| `<leader>gg`      | Lazygit        | Open Lazygit interface |
| `<leader>gs`      | Git status     | Find git status        |
| `<leader>gC`      | Git commits    | Browse commits         |
| `<leader>gb`      | Git blame      | Toggle git blame       |
| `<leader>gd`      | Git diff hunks | Show git diff hunks    |
| `<leader>ghn/p`   | Hunk nav       | Next/previous git hunk |
| `<leader>ghs/u/r` | Hunk ops       | Stage/undo/reset hunk  |

### Code Navigation (LSP)

| Key          | Action               | Description                    |
| ------------ | -------------------- | ------------------------------ |
| `gd`         | Go to definition     | Jump to definition             |
| `grr`        | Find references      | Show all references            |
| `gri`        | Go to implementation | Jump to implementation         |
| `gy`         | Go to type def       | Jump to type definition        |
| `K`          | Hover docs           | Show documentation             |
| `gx`         | Open document link   | Follow LSP document links      |
| `<leader>la` | Code actions         | Show code actions              |
| `<leader>lr` | Rename               | Rename symbol                  |
| `<leader>lT` | Tooling info         | Inspect current buffer tooling |
| `<leader>lI` | LSP health           | Run `:checkhealth vim.lsp`     |
| `<leader>lX` | Restart LSP          | Restart attached LSP clients   |

### Diagnostics & Debugging

| Key          | Action                  | Description                        |
| ------------ | ----------------------- | ---------------------------------- |
| `<leader>xx` | Diagnostics             | Toggle diagnostics list            |
| `<leader>fd` | Find diagnostics        | Buffer diagnostics                 |
| `<leader>fD` | Find diagnostics        | Workspace diagnostics              |
| `<leader>l[` | Diagnostic jump         | Previous diagnostic                |
| `<leader>l]` | Diagnostic jump         | Next diagnostic                    |
| `<leader>lH` | Diagnostic hover        | Open float at current position     |
| `<leader>lq` | Buffer diagnostics list | Send buffer diagnostics to loclist |
| `<leader>le` | Buffer errors list      | Send buffer errors to loclist      |
| `<leader>lE` | Workspace diagnostics   | Send diagnostics to quickfix       |
| `<leader>lW` | Workspace errors list   | Send errors to quickfix            |
| `<leader>lx` | Run code lens           | Execute code lens when supported   |
| `<leader>db` | Debug breakpoint        | Toggle breakpoint                  |
| `<leader>dc` | Debug continue          | Start/continue debug               |
| `<leader>di` | Debug step              | Step into                          |
| `<leader>do` | Debug step              | Step over                          |
| `<leader>dO` | Debug step              | Step out                           |

### Language Workflows

Language-specific actions live under `<leader>z` and are buffer-local.

- TypeScript uses `<leader>z` for actions like add imports, fix all, organize
  imports, source definition, and tsserver logs.
- Rust uses `<leader>z` for runnables, debuggables, crate graph, cargo,
  rust-analyzer logs, and macro tools.
- Python uses `<leader>zv`, `<leader>zc`, `<leader>zL`, `<leader>zt`,
  `<leader>zT`, `<leader>zl`, and `<leader>zd` for env/test/debug workflows.
- .NET uses `<leader>z` for build, run, debug, test, watch, diagnostics, and
  outdated-package flows.

### Quick Navigation

| Key          | Action           | Description            |
| ------------ | ---------------- | ---------------------- |
| `s`          | Flash jump       | Quick jump to location |
| `S`          | Flash treesitter | Treesitter-aware jump  |
| `<leader>Ha` | Harpoon add      | Add file to harpoon    |
| `<leader>He` | Harpoon menu     | Quick harpoon menu     |

### Toggle Options

| Key           | Action                       | Description                   |
| ------------- | ---------------------------- | ----------------------------- |
| `<leader>ud`  | Toggle diagnostics           | Buffer diagnostics            |
| `<leader>uf`  | Toggle formatting            | Auto-formatting               |
| `<leader>uw`  | Toggle word wrap             | Text wrapping                 |
| `<leader>uS`  | Toggle spell check           | Spell checking                |
| `<leader>uT`  | Toggle terminal              | Terminal interface            |
| `<leader>ueI` | Toggle diagnostics in insert | Show diagnostics while typing |
| `<leader>uev` | Toggle virtual lines         | Diagnostic virtual lines      |
| `<leader>ueC` | Toggle code lens             | Code lens display             |
| `<leader>uec` | Toggle document colors       | LSP document colors           |
| `<leader>ueS` | Toggle semantic tokens       | Semantic token highlighting   |

### Utility

| Key          | Action          | Description             |
| ------------ | --------------- | ----------------------- |
| `<leader>fy` | Yank history    | Paste from yank history |
| `<leader>f'` | Find marks      | Search marks            |
| `<leader>ft` | Find TODOs      | Search TODO comments    |
| `<leader>:`  | Command history | Recent command history  |

_Note: Use `<leader>` (Space) and wait to see all available options via
which-key. Many plugins provide additional context-specific keybindings. See
`docs/language-tooling.md` for the current runtime tooling model._

## Inspirational Config Implementations:

- https://github.com/khaneliman/khanelivim
