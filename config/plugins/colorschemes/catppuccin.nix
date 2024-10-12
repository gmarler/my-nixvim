{
  colorschemes = {
    catppuccin = {
      enable = false;
      settings = {
        background = {
          light = "macchiato";
          dark = "mocha";
        };
        flavour = "mocha"; # "latte", "mocha", "frappe", "macchiato" or raw lua code
        disable_bold = false;
        disable_italic = false;
        disable_underline = false;
        transparent_background = true;
        term_colors = true;
        integrations = {
          cmp = true;
          diffview = true;
          fidget = true;
          gitsigns = true;
          harpoon = true;
          illuminate = {
            enabled = true;
          };
          indent_blankline.enabled = true;
          lsp_trouble = true;
          markdown = true;
          mason = true;
          treesitter = true;
          treesitter_context = true;
          telescope.enabled = true;
          mini.enabled = true;
          native_lsp = {
            enabled = true;
            inlay_hints = {
              background = true;
            };
            underlines = {
              errors = ["underline"];
              hints = ["underline"];
              information = ["underline"];
              warnings = ["underline"];
            };
          };
          neogit = true;
          neotree = true;
          noice = true;
          notify = true;
          which_key = true;
        };
      };
    };
  };
}
