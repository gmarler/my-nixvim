{
  plugins.typescript-tools = {
    enable = false;
    settings = {
      tsserverFilePreferences = {
        # Inlay Hints
        includeInlayParameterNameHints = "all";
        includeInlayParameterNameHintsWhenArgumentMatchesName = true;
        includeInlayFunctionParameterTypeHints = true;
        includeInlayVariableTypeHints = true;
        includeInlayVariableTypeHintsWhenTypeMatchesName = true;
        includeInlayPropertyDeclarationTypeHints = true;
        includeInlayFunctionLikeReturnTypeHints = true;
        includeInlayEnumMemberValueHints = true;
      };
      onAttach = ''
        function(client, bufnr)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false

          if vim.lsp.inlay_hint then
            vim.lsp.inlay_hint(bufnr, true)
          end
        end
      '';
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>co";
      action = "<cmd>TSToolsOrganizeImports<cr>";
      options = {
        desc = "Organize Imports";
      };
    }
    {
      mode = "n";
      key = "<leader>cR";
      action = "<cmd>TSToolsRemoveUnusedImports<cr>";
      options = {
        desc = "Remove Unused Imports";
      };
    }
  ];
}
