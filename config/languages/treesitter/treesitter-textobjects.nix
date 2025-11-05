{
  plugins.treesitter-textobjects = {
    settings = {
      move = {
        enable = true;
        goto_next_start = {
          "]m" = "@function.outer";
          "]]" = "@class.outer";
        };
        goto_next_end = {
          "]M" = "@function.outer";
          "][" = "@class.outer";
        };
        goto_previous_start = {
          "[m" = "@function.outer";
          "[[" = "@class.outer";
        };
        goto_previous_end = {
          "[M" = "@function.outer";
          "[]" = "@class.outer";
        };

      };
      select = {
        enable = true;
        lookahead = true;
        keymaps = {
          "aa" = "@parameter.outer";
          "ia" = "@parameter.inner";
          "af" = "@function.outer";
          "if" = "@function.inner";
          "ac" = "@class.outer";
          "ic" = "@class.inner";
          "ii" = "@conditional.inner";
          "ai" = "@conditional.outer";
          "il" = "@loop.inner";
          "al" = "@loop.outer";
          "at" = "@comment.outer";
        };
      };

      swap = {
        enable = true;
        swap_next = {
          "<leader>a" = "@parameters.inner";
        };
        swap_previous = {
          "<leader>A" = "@parameter.outer";
        };
      };
    };

    enable = false;
  };
}
