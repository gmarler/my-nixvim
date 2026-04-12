{
  config,
  lib,
  ...
}:
{
  plugins = {
    snacks = {
      settings = {
        scope = {
          enabled = lib.elem "snacks-scope" config.gmarlervim.editor.textObjects;

          treesitter = {
            blocks = {
              enabled = true; # use treesitter for semantic scope detection
            };
          };
        };
      };
    };
  };
}
