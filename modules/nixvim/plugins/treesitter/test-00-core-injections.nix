{
  lib,
  pkgs,
  ...
}:

{
  test_case_nixvim_core = {
    rawLua = lib.mkRaw ''
      vim.opt.number = true
    '';

    extraConfigLua = ''
      vim.g.gmarlervim_core_query = true
    '';

    luaConfig = {
      pre = ''
        vim.api.nvim_create_user_command("CoreQuery", function() end, {})
      '';
    };

    extraConfigVim = ''
      set number
    '';
  };

  test_case_nixpkgs_core = {
    regex = builtins.match "^[a-z]+$" "gmarlervim";

    installPhase = ''
      echo "installing"
    '';

    customPhase = ''
      echo "custom phase"
    '';

    preCustom = ''
      echo "pre custom"
    '';

    postCustom = ''
      echo "post custom"
    '';

    script = ''
      echo "script hook"
    '';

    shellScript = pkgs.writeShellScript "gmarlervim-test" ''
      echo "shell script"
    '';

    shellApplication = pkgs.writeShellApplication {
      name = "gmarlervim-test";
      text = ''
        echo "shell application"
      '';
    };

    pythonTool = pkgs.writers.writePython3 "gmarlervim-test" { } ''
      print("python")
    '';
  };

}
