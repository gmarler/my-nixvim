{
  lib,
  config,
  pkgs,
  ...
}:
let
  neovimVersion = pkgs.neovim.version or "0.0";
  hasNeovim012OrNewer = lib.versionAtLeast neovimVersion "0.12";
in
{
  # ALWAYS use the clipboard for ALL operations (instead of interacting with
  # the "+" and/or "*" registers explicitly)
  # Note: The basic clipboard setup below is overridden by vim.g.clipboard in globals
  # to add timeout wrappers that prevent wl-copy from freezing Neovim
  clipboard = {
    register = "unnamedplus";
  };

  colorscheme = config.gmarlervim.ui.theme;
  colorschemes.catppuccin.enable = config.gmarlervim.ui.theme == "catppuccin";
  colorschemes.nord.enable = config.gmarlervim.ui.theme == "nord";
  luaLoader.enable = true;

  globals = {
    # Disable useless providers
    loaded_ruby_provider = 0; # Ruby
    loaded_perl_provider = 0; # Perl
    loaded_python_provider = 0; # Python 2

    # Custom toggles for UI features
    disable_autoformat = false;
    spell_enabled = true;
    colorizing_enabled = false;
    first_buffer_opened = false;
    whitespace_character_enabled = false;
  };

  opts = {
    # Performance & Timing
    updatetime = 100; # CursorHold delay; faster completion and git signs
    lazyredraw = false; # Breaks noice plugin
    synmaxcol = 240; # Disable syntax highlighting for long lines
    timeoutlen = 500; # Key sequence timeout (ms)
    smoothscroll = true; # Smooth scrolling with Ctrl-D/U

    # Project-local config
    exrc = true; # Enable .nvim.lua, .nvimrc, .exrc in project directories

    # UI & Appearance
    number = true;
    relativenumber = true;
    # Highlight the location of the cursor with "crosshairs"
    cursorline = true;
    cursorcolumn = true;
    signcolumn = "yes";
    colorcolumn = "100"; # Columns to highlight
    laststatus = 3; # Global statusline
    showtabline = 2;
    showmode = false;
    showmatch = true;
    matchtime = 1; # Flash duration in deciseconds
    termguicolors = true;
    winborder = "rounded";

    # Windows & Splits
    splitbelow = true;
    splitright = true;
    splitkeep = "screen";

    # Mouse
    # Enable mouse support for 'a'll previous modes
    mouse = "a";
    # Mouse right-click extends the current selection
    mousemodel = "extend"; # Right-click extends selection

    # Search
    incsearch = true;
    ignorecase = true; # Case-insensitive search
    smartcase = true; # Unless pattern contains uppercase
    iskeyword = "@,48-57,_,192-255,-"; # Treat dash-separated text as a single word

    # Files & Buffers
    swapfile = false;
    undofile = true;
    autoread = true;
    writebackup = false;
    # File-content encoding for the current buffer
    fileencoding = "utf-8";
    modeline = true; # Scan for editor directives like 'vim: set ft=nix:'
    modelines = 100; # Scan first/last 100 lines for modelines

    # Spelling
    spell = true;
    spelllang = lib.mkDefault [ "en_us" ];

    # Indentation & Formatting
    tabstop = 2;
    shiftwidth = 2;
    # Expand TABs to SPACEs
    expandtab = true;
    autoindent = true;
    breakindent = true;
    copyindent = true;
    preserveindent = true;
    # How autoformat should be done:
    # r: ????
    # q: Allow formatting of comments with "qq"
    # n: When formatting text, recognize numbered lists
    # l: Long lines are NOT broken in Insert mode - TBD: may need to revisit this
    # 1: ???
    # j: Where it makes sense, remove a comment leader when joining lines
    # t: Auto-wrap text using "textwidth" (DISABLED)
    formatoptions = "rqnl1j";
    formatlistpat = "^\\s*[0-9\\-\\+\\*]\\+[\\.)]*\\s\\+";
    linebreak = true;
    wrap = false;

    # Folding
    foldlevel = 10; # Keep most folds open, but preserve structure
    foldcolumn = "1"; # Use 1 fixed column to show a fold
    foldenable = true; # folds enabled by default
    foldmethod = "indent";
    foldnestmax = 10;
    foldlevelstart = -1; # -1 uses foldlevel value
    # foldtext = ""; # Empty uses builtin foldtext
    fillchars = {
      horiz = "━";
      horizup = "┻";
      horizdown = "┳";
      vert = "┃";
      vertleft = "┫";
      vertright = "┣";
      verthoriz = "╋";

      eob = " ";
      diff = "╱";

      fold = " ";
      foldopen = "";
      foldclose = "";

      msgsep = "‾";
    };

    # Completion & Popup
    pumheight = 10; # Max popup menu items
    infercase = true;
    # Options for Insert mode completion
    completeopt = [
      "menu"
      "menuone"
      "noselect"
    ]
    ++ lib.optionals (config.gmarlervim.completion.tool != "blink") [
      "popup"
    ]; # Native completion options

    # Command Line & Messages
    cmdheight = 0; # Hide command line when not in use
    history = 100; # Command history limit
    report = 9001; # Disable "x more/fewer lines" messages

    # Editor Behavior
    virtualedit = "block";
    startofline = true;
    title = true;
  }
  // lib.optionalAttrs hasNeovim012OrNewer {
    # Use 0.12+/nightly popup capabilities when available.
    completeitemalign = "abbr,kind,menu";
    # completepopup = "height:12,width:60,border:single";
    jumpoptions = "stack";
    pumborder = "single";
    pummaxwidth = 100;
    completetimeout = 100;
  };
}
