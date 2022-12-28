{ pkgs, lib, config, functions, ... }:
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

        customNeovim.luaConfigRC = ''
            local lspconfig = require('lspconfig')

            ${functions.writeIf { c = cfg.nix; v1 = ''
                -- Nix config
                lspconfig.nil_ls.setup{
                    capabilities = capabilities,
                    on_attach=default_on_attach,
                    cmd = {"${pkgs.nil}/bin/nil"},
                }
            ''; } }

            ${functions.writeIf { c = cfg.python; v1 = ''
                -- Python config
                lspconfig.pyright.setup{
                    capabilities = capabilities;
                    on_attach=default_on_attach;
                    cmd = {"${pkgs.nodePackages.pyright}/bin/pyright-langserver", "--stdio"}
                }
            ''; } }

            ${functions.writeIf { c = cfg.c; v1 = ''
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

