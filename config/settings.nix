{
  # Based off of https://github.com/dc-tec/nixvim/blob/main/config/settings.nix
  config = {
    opts = {
      autoindent = true;
      breakindent = true;
      # ALWAYS use the clipboard for ALL operations (instead of interacting with
      # the "+" and/or "*" registers explicitly)
      clipboard = "unnamedplus"; # Use the system clipboard
      # Hide the command-line - we'll be using something else to display the
      # messages that would normally appear there (TBD)
      cmdheight = 0;
      # Columns to highlight
      colorcolumn = "100";
      # Options for Insert mode completion
      completeopt = [
        "menu"
        "menuone"
        "noselect"
      ];
      # Show text with "conceal" syntax attribute anyway
      conceallevel = 0;
      confirm = true;
      # Hilight the location of the cursor with "crosshairs"
      cursorcolumn = true;
      cursorline = true;
      # Expand TABs to SPACEs
      expandtab = true;
      # File-content encoding for the current buffer
      fileencoding = "utf-8";
      # Characters to fill special roles in the statuslines, special lines and
      # vertical separators in any buffer
      # - eob:       End lines at the end of a buffer
      # - foldopen:  Mark the beginning of a fold
      # - foldsep:   open fold middle marker
      # - foldclose: Show a closed fold
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
        foldsep = " ";
        foldclose = "";

        msgsep = "‾";
      };
      # Use 1 fixed column to show a fold
      foldcolumn = "1"; # '0' is not bad
      # folds enabled by default
      foldenable = true;
      # No folds will be closed - all open
      foldlevel = 99; # Using ufo provider need a large value, feel free to decrease the value
      # Also when switching to another buffer in a window
      foldlevelstart = 99;
      # How autoformat should be done:
      # j: Where it makes sense, remove a comment leader when joining lines
      # q: Allow formatting of comments with "gq"
      # l: Long lines are NOT broken in Insert mode - TBD: may need to revisit this
      # n: When formatting text, recognize numbered lists
      # t: Auto-wrap text using "textwidth"
      formatoptions = "jqlnt"; # tcqj
      # Which font do I want to use?
      guifont = "FiraCode\ Nerd\ Font\ Mono:h14";
      # When a buffer is abandoned, it remains loaded, and the undo history is kept
      #hidden = trueh;
      history = 100;
      # Previous searches are NOT continuously highlighted
      hlsearch = false;
      # Ignore case in search patterns - match both upper and lower case patterns
      ignorecase = true;
      # Show the effects of a command incrementally in the buffer
      inccommand = "nosplit";
      # Incremental search: show match for partly typed search command
      incsearch = true;
      infercase = true;
      # Do NOT insert two spaces afer a ".", "?", or "!" with a join command
      joinspaces = false;
      # Always and ONLY the last window will have a status line
      laststatus = 3;
      # Faster scrolling if enabled, breaks noice 
      lazyredraw = false;
      linebreak = true;
      # Show tabs, trailing spaces, and non-breakable spaces specially
      # HOW these are shown is configurable via 'listchars'
      list = true;
      # Enable mouse support for 'a'll previous modes
      mouse = "a";
      # Mouse right-click extends the current selection
      mousemodel = "extend";
      # Print line number before every line
      number = true;
      preserveindent = true;
      # Enable 10% pseudo transparency for the pop-up window
      pumblend = 10;
      # Max number of items to show in the popup menu
      pumheight = 10;
      # Don't show line numbers relative to the cursor's position
      # TODO: It may be beneficial to learn to enable this over time
      relativenumber = false;
      # Disable "x more/fewer lines" messages
      report = 9001;
      # Max number of lines kept beyond the visible screen
      scrollback = 100000;
      # Min number of screen lines to keep above/below the cursor.
      scrolloff = 8;
      # Alter what gets saved by a mksession command
      # buffers: hidden and unloaded buffers in addition to those in windows
      # curdir: the current directory
      # tabpages: all tab pages
      # winsize: window sizes
      sessionoptions = [ "buffers" "curdir" "tabpages" "winsize" ];
      # Round indent to multiple of 'shiftwidth'
      shiftround = true;
      # Number of spaces to use for each step of (auto)indent.
      shiftwidth = 2;
      # TODO: use extraConfigLua to make this config change
      ## Add to existing to eliminate prompts caused by file messages:
      ## W: Don't give "written" or "[w]" when writing a file
      ## I: Don't give intro message when starting Neovim
      ## c: Don't give ins-completion-menu messages
      ## C: Don't give messages when scanning for ins-completion items
      #shortmess:append { W = true, I = true, c = true, C = true }
      # Don't show partial command in the last line of the screen
      showcmd = false;
      # When closing a brackent, briefly flash the matching one
      showmatch = true;
      # Don't show mode message on last line
      showmode = false;
      showtabline = 2;
      # Minimal # of screen colums to keep to the left/right if 'nowrap' is set
      sidescrolloff = 8;
      # Always draw the signcolumn
      signcolumn = "yes";
      # If a search pattern contains upper case chars, ignore 'ignorecase' option
      smartcase = true;
      # Do smart autoindenting when starting new lines. Used instead of cindent
      smartindent = true;
      # Puts new window below current window when 'split'ting
      splitbelow = true;
      # Keep text on same screen line when opening/closing/resizing horizontal
      # splits
      splitkeep = "screen";
      # Puts new window to the right of the current one for vsplit
      splitright = true;
      # Motions like "G" also move to the first chars
      startofline = true;
      # Max column for syntax highlight
      synmaxcol = 240;
      # Number of spaces each <Tab> represents
      tabstop = 2;
      # Enable 24-bit RGB color in the TUI, if possible
      termguicolors = true;
      # Time (ms) to wait for a mapped sequence to complete
      timeoutlen = 500;
      # Set the title of the window
      title = true;
      # Automatically Save/Restore undo history to/from an undo file
      undofile = true;
      # write swap file to disk if no activity in this many ms
      updatetime = 100;
      virtualedit = "block";
      # Complete til longest common string, if that fails, complete the next full
      # match, and possibly start the wildmenu if enabled.
      wildmode = "longest:full,full";
      # Prevent text from wrapping
      wrap = false;
      writebackup = false;
    };

    extraConfigLua = ''
      local opt = vim.opt
      local g = vim.g
      local o = vim.o
      --Neovide
      if g.neovide then
        -- Neovide options
        g.neovide_fullscreen = false
        g.neovide_hide_mouse_when_typing = false
        g.neovide_refresh_rate = 165
        g.neovide_cursor_vfx_mode = "ripple"
        g.neovide_cursor_animate_command_line = true
        g.neovide_cursor_animate_in_insert_mode = true
        g.neovide_cursor_vfx_particle_lifetime = 5.0
        g.neovide_cursor_vfx_particle_density = 14.0
        g.neovide_cursor_vfx_particle_speed = 12.0
        g.neovide_transparency = 0.8

        -- Neovide Fonts
        -- o.guifont = "MonoLisa Trial:Medium:h15"
        -- o.guifont = "CommitMono:Medium:h15"
        -- o.guifont = "JetBrainsMono Nerd Font:h14:Medium:i"
        o.guifont = "FiraMono Nerd Font:Medium:h14"
        -- o.guifont = "CaskaydiaCove Nerd Font:h14:b:i"
        -- o.guifont = "BlexMono Nerd Font Mono:h14:Medium:i"
        -- o.guifont = "Liga SFMono Nerd Font:b:h15"
      end
    '';
  };
}
