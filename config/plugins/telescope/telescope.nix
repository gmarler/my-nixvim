{
  # Drawn from example:
  # https://github.com/redyf/Neve/blob/main/config/telescope/telescope.nix
  plugins.telescope = {
    enable = true;

    extensions = {
      fzf-native = {
        enable = true;
      };
      ui-select = {
        settings = {
          specific_opts = {
              codeactions = true;
          };
        };
      };
      undo = {
        enable = true;
      };
    };

    # If you'd prefer Telesceop not to enter a normal-like mode when hitting
    # <Esc> (and instead exiting), you can map <Esc> to do so via:
    settings = {
      pickers = { colorscheme.enable_preview = true; };
      defaults = {
        mappings = {
          i = {
            "<esc>" = {
              __raw = ''
                function(...)
                  return require("telescope.actions").close(...)
                end'';
            };
          };
        };
      };
    };

    keymaps = {
      "<leader>fg" = {
        action = "live_grep";
        options.desc = "Grep (root dir)";
      };
      "<leader>zc" = {
        action = "colorscheme";
        options.desc = "Colorscheme preview";
      };
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>fb";
      action = "<cmd>Telescope buffers sort_mru=true ignore_current_buffer=true<cr>";
      options = {
        #silent = true;
        desc = "Buffers";
      };
    }
    {
      mode = "n";
      key = "<leader>fm";
      action = "<cmd>Telescope marks<cr>";
      options = {
        #silent = true;
        desc = "Marks";
      };
    }
    {
      mode = "n";
      key = "<leader>fc";
      action = "<cmd>cd %:p:h<cr>";
      options = {
        #silent = true;
        desc = "Change WorkDir";
      };
    }
  ];
}
