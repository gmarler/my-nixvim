{
  extraFiles = {
    "lua/gmarlervim/tooling_info.lua".source = ./lua/gmarlervim/tooling_info.lua;
    "lua/gmarlervim/web_tools.lua".source = ./lua/gmarlervim/web_tools.lua;
  };

  # Just a small boolean function to convert a boolean to a string
  extraConfigLuaPre = ''
    function bool2str(bool) return bool and "on" or "off" end
  '';
}
