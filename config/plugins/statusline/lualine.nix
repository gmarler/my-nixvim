{
  # Possible alternatives:
  # https://github.com/elythh/nixvim/blob/main/config/plug/statusline/lualine.nix
  # https://github.com/dc-tec/nixvim/blob/main/config/plugins/ui/lualine.nix
  plugins.lualine = {
    enable = true;

    # lazyLoad.settings.event = "BufEnter";

    settings = {
      options = {
        disabled_filetypes = {
          __unkeyed-1 = "startify";
          __unkeyed-2 = "neo-tree";
          winbar = [
            "aerial" "dap-repl" "neotest-summary"
          ];
        };
        globalstatus = true;
      };

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
        lualine_c = [ "filename" "diff" ];

        lualine_x = [
          "diagnostics"

          # Show active language server
          {
            __unkeyed.__raw = ''
              function()
                local msg = ""
                local buf_ft = vim.api.nvim_buf_get_options(0, 'filetype')
                local clients = vim.lsp.get_active_clients()
                if next(clients) == nul then
                  return msg
                end
                for _, client in ipairs(clients) do 
                  local filetypes = client.config.filetypes
                  if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                    return client.name
                  end
                end
                return msg
              end
            '';
            icon = "";
            #color.fg = "#ffffff";
          }
          { __unkeyed = "encoding"; }
          { __unkeyed = "fileformat"; }
          { __unkeyed = "filetype"; }
          { __unkeyed = "progress"; }
        ];

        lualine_y = [ ''" " .. os.date("%R")'' ];
        lualine_z = [
          {
            __unkeyed = "location";
            # inherit cond;
          }
        ];
      };
    };
  };
}
