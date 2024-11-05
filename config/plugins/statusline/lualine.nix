{
  # Possible alternatives:
  # https://github.com/elythh/nixvim/blob/main/config/plug/statusline/lualine.nix
  # https://github.com/dc-tec/nixvim/blob/main/config/plugins/ui/lualine.nix
  plugins.lualine = {
    enable = true;
    settings = {

      alwaysDivideMiddle = true;
      globalstatus = true;
      ignoreFocus = [ "neo-tree" ];
      extensions = [ "fzf" ];
      theme = "auto";
      componentSeparators = {
        left = "|";
        right = "|";
      };
      sectionSeparators = {
        left = "█"; # 
        right = "█"; # 
      };
      sections = {
        lualine_a = [ "mode" ];
        lualine_b = [
          {
            __unkeyed-1 = "branch";
            icon = "";
          }
          "diff"
          "diagnostics"
        ];
        lualine_c = [ "filename" ];
        lualine_x = [
          { __unkeyed = "encoding"; }
          { __unkeyed = "fileformat"; }
          { __unkeyed = "filetype"; }
          { __unkeyed = "progress"; }
        ];
        lualine_y = [ ''" " .. os.date("%R")'' ];
        lualine_z = [ "location" ];
      };
    };
  };
}
