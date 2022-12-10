{ pkgs, lib, config, ... }:
with lib;
with builtins;

let
  cfg = config.customNeovim.plugins.lsp;
in
{
  options.customNeovim.plugins.lsp = {
    enable = mkEnableOption "Enable LSP";

    nix = mkEnableOption "Nix LSP";
    python = mkEnableOption "Python LSP";
    c = mkEnableOption "C LSP";
  };

  config = mkIf cfg.enable {

    customNeovim.startupPlugins = with pkgs.neovimPlugins; [
      nvim-lspconfig
    ];

    customNeovim.luaConfigRC = let
      writeIf = { c, v1, v2 ? "" }: if c then v1 else v2;
    in
    ''
      local lspconfig = require('lspconfig')

      ${writeIf { c = cfg.nix; v1 = ''
        -- Nix config
        lspconfig.nil_ls.setup{
          capabilities = capabilities,
          on_attach=default_on_attach,
          cmd = {"${pkgs.nil}/bin/nil"},
        }
      ''; } }

      ${writeIf { c = cfg.python; v1 = ''
        -- Python config
        lspconfig.pyright.setup{
          capabilities = capabilities;
          on_attach=default_on_attach;
          cmd = {"${pkgs.nodePackages.pyright}/bin/pyright-langserver", "--stdio"}
        }
      ''; } }

      ${writeIf { c = cfg.c; v1 = ''
        -- CCLS (clang) config
        lspconfig.ccls.setup{
          capabilities = capabilities;
          on_attach=default_on_attach;
          cmd = {"${pkgs.ccls}/bin/ccls"}
        }
      ''; } }
    '';
  };
}

