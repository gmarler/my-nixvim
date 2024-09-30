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
    };
  };
}
