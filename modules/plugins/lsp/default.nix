{ pkgs, lib, config, ... }:
with lib;
with builtins;

let
  cfg = config.customNeovim.plugins.lsp;
in
{
  options.customNeovim.plugins.lsp = {
    enable = mkEnableOption "Enable LSP";

    nix = {
      enable = mkEnableOption "Nix LSP";
    };
  };

  config = mkIf cfg.enable {

    customNeovim.startupPlugins = with pkgs.neovimPlugins; [
      nvim-lspconfig
      nil
    ];

    customNeovim.luaConfigRC = let
      writeIf = { c, v1, v2 ? "" }: if c then v1 else v2;
    in
    ''
      local lspconfig = require('lspconfig')

      ${writeIf { c = cfg.nix.enable; v1 = ''
        lspconfig.nil_ls.setup{
          capabilities = capabilities,
          on_attach=default_on_attach,
          cmd = {"${pkgs.nil}/bin/nil"},
        }
      ''; } }

    '';
  };
}

