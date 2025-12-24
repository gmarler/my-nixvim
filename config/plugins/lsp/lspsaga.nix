{
  plugins.lspsaga = {
    enable = true;
    settings = {
      beacon = {
        enable = true;
      };
      ui = {
        border = "rounded"; # One of none, single, double, rounded, solid, shadow
        codeAction = "💡"; # Can be any symbol you want 💡
      };
      hover = {
        openCmd = "!floorp"; # Choose your browser
        openLink = "gx";
      };
      diagnostic = {
        borderFollow = true;
        diagnosticOnlyCurrent = false;
        showCodeAction = true;
      };
      symbolInWinbar = {
        enable = true; # Breadcrumbs
      };
      codeAction = {
        extendGitSigns = false;
        showServerName = true;
        onlyInCursor = true;
        numShortcut = true;
        keys = {
          exec = "<CR>";
          quit = [
            "<Esc>"
            "q"
          ];
        };
      };
      lightbulb = {
        enable = false;
        sign = false;
        virtualText = true;
      };
      implement = {
        enable = false;
      };
      rename = {
        autoSave = false;
        keys = {
          exec = "<CR>";
          quit = [
            "<C-k>"
            "<Esc>"
          ];
          select = "x";
        };
      };
      outline = {
        autoClose = true;
        autoPreview = true;
        closeAfterJump = true;
        layout = "normal"; # normal or float
        winPosition = "right"; # left or right
        keys = {
          jump = "e";
          quit = "q";
          toggleOrJump = "o";
        };
      };
      scrollPreview = {
        scrollDown = "<C-f>";
        scrollUp = "<C-b>";
      };
    };
  };
  plugins.which-key.settings.spec = [
    {
      __unkeyed-1 = "<leader>lc";
      mode = [
        "n"
        "v"
      ];
      # Grouping of keymaps starting with <leader>lc
      group = "+Call Hierarchy";
    }
    {
      __unkeyed-1 = "<leader>lci";
      __unkeyed-2 = "<cmd>Lspsaga incoming_calls<CR>";
      desc = "Call Hierarchy Incoming Calls";
    }
    {
      __unkeyed-1 = "<leader>lco";
      __unkeyed-2 = "<cmd>Lspsaga outgoing_calls<CR>";
      desc = "Call Hierarchy Outgoing Calls";
    }
    {
      __unkeyed-1 = "<leader>ld";
      __unkeyed-2 = "<cmd>Lspsaga finder def<CR>";
      desc = "Show Definition";
    }
    {
      __unkeyed-1 = "<leader>lD";
      __unkeyed-2 = "<cmd>Lspsaga goto_definition<CR>";
      desc = "Goto Definition";
    }
    {
      __unkeyed-1 = "<leader>lr";
      __unkeyed-2 = "<cmd>Lspsaga finder ref<CR>";
      desc = "Show References";
    }
    # Already done via lsp-conform config for now
    # {
    #   __unkeyed-1 = "<leader>lf";
    #   __unkeyed-2 = "<cmd>Format<CR>";
    #   desc = "Format the current buffer";
    # }
    {
      __unkeyed-1 = "<leader>lh";
      __unkeyed-2 = "<cmd>Lspsaga hover_doc<CR>";
      desc = "LSP Hover";
    }
    # There really isn't a need for this in lspsaga, it gets a hover already
    # {
    #   __unkeyed-1 = "<leader>lH";
    #   desc = "Diagnostic Hover";
    # }
    {
      __unkeyed-1 = "<leader>li";
      __unkeyed-2 = "<cmd>Lspsaga finder imp<CR>";
      desc = "Implementation";
    }
    # May be better to jump between diagnostics as below
    {
      __unkeyed-1 = "<leader>ll";
      __unkeyed-2 = "<cmd>Lspsaga show_line_diagnostics<CR>";
      mode = "n";
      desc = "Display Line Diagnostics";
    }
    {
      __unkeyed-1 = "<leader>lO";
      __unkeyed-2 = "<cmd>Lspsaga outline<CR>";
      desc = "Outline";
    }
    {
      __unkeyed-1 = "<leader>lR";
      __unkeyed-2 = "<cmd>Lspsaga rename<CR>";
      desc = "Rename";
    }
    {
      __unkeyed-1 = "<leader>lt";
      __unkeyed-2 = "<cmd>Lspsaga peek_type_definition<CR>";
      desc = "Peek at Type Definition";
    }
    {
      __unkeyed-1 = "<leader>lT";
      __unkeyed-2 = "<cmd>Lspsaga goto_type_definition<CR>";
      desc = "Go to Type Definition";
    }

    # Outside the LSP group submenu
    {
      __unkeyed-1 = "[d";
      __unkeyed-2 = "<cmd>Lspsaga diagnostic_jump_next<CR>";
      mode = "n";
      desc = "Next Diagnostic";
    }
    {
      __unkeyed-1 = "]d";
      __unkeyed-2 = "<cmd>Lspsaga diagnostic_jump_prev<CR>";
      mode = "n";
      desc = "Previous Diagnostic";
    }
  ];
  keymaps = [
    {
      mode = "n";
      key = "<leader>ca";
      action = "<cmd>Lspsaga code_action<CR>";
      options = {
        desc = "Code Action";
        silent = true;
      };
    }
  ];
}
