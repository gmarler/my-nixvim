{
  extraFiles = {
    "ftplugin/teal.vim".source = builtins.toFile "teal.vim" ''
      " Register Teal as a known runtime filetype so vim.lsp health checks stop
      " flagging it as unknown. Real detection still comes from vim.filetype.add().
    '';
    "ftplugin/gd.vim".source = builtins.toFile "gd.vim" ''
      " nvim-lspconfig's gdscript config advertises this legacy GDScript alias.
      " Keep *.gd detection on Neovim's gdscript filetype.
    '';
    "ftplugin/yaml.docker-compose.vim".source = builtins.toFile "yaml.docker-compose.vim" ''
      " nvim-lspconfig's yamlls config advertises this YAML subtype.
      " Real detection still comes from vim.filetype.add().
    '';
    "ftplugin/yaml.gitlab.vim".source = builtins.toFile "yaml.gitlab.vim" ''
      " nvim-lspconfig's yamlls config advertises this YAML subtype.
      " Real detection still comes from vim.filetype.add().
    '';
    "ftplugin/yaml.helm-values.vim".source = builtins.toFile "yaml.helm-values.vim" ''
      " nvim-lspconfig's yamlls config advertises this YAML subtype.
      " Real detection still comes from vim.filetype.add().
    '';
    "lua/gmarlervim/tooling_info.lua".source = ./lua/gmarlervim/tooling_info.lua;
    "lua/gmarlervim/web_tools.lua".source = ./lua/gmarlervim/web_tools.lua;
  };

  # Just a small boolean function to convert a boolean to a string
  extraConfigLuaPre = ''
    function bool2str(bool) return bool and "on" or "off" end
  '';
}
