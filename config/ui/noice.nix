{
  plugins.noice = {
    enable = true;
    settings = {
      notify = {
        enabled = false;
      };
      popupmenu = {
        enabled = true;
        backend = "nui";
      };
      messages = {
        enabled = true; # Adds a padding-bottom to neovim statusline when set to false for some reason
      };
      format = {
        filter = {
          pattern = [":%s*%%s*s:%s*" ":%s*%%s*s!%s*" ":%s*%%s*s/%s*" "%s*s:%s*" ":%s*s!%s*" ":%s*s/%s*"];
          icon = "";
          lang = "regex";
        };
        replace = {
          pattern = [":%s*%%s*s:%w*:%s*" ":%s*%%s*s!%w*!%s*" ":%s*%%s*s/%w*/%s*" "%s*s:%w*:%s*" ":%s*s!%w*!%s*" ":%s*s/%w*/%s*"];
          icon = "󱞪";
          lang = "regex";
        };
      };
      lsp = {
        message = {
          enabled = true;
        };
        progress = {
          enabled = false;
          view = "mini";
        };
      };
    };
  };
}
