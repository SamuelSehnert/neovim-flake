{ pkgs, lib, config, functions, ... }:
with lib;
with builtins;

let
    cfg = config.customNeovim.plugins.lsp;
in
{
    options.customNeovim.plugins.lsp = {
        enable = mkEnableOption "Enable LSP";

        languages = {
            all = mkEnableOption "Enable all LSP options";
            c = mkEnableOption "C LSP";
            nix = mkEnableOption "Nix LSP";
            ocaml = mkEnableOption "Ocaml LSP";
            python = mkEnableOption "Python LSP";
            lua = mkEnableOption "Lua LSP";
        };
    };

    config = mkIf cfg.enable {

        customNeovim.startupPlugins = with pkgs.neovimPlugins; [
            nvim-lspconfig
        ];

        customNeovim.luaConfigRC = ''
            local lspconfig = require('lspconfig')
            local capabilities = vim.lsp.protocol.make_client_capabilities()

            local on_attach = function(_, bufnr)
                local nmap = function(keys, func, desc)
                    if desc then
                        desc = 'LSP: ' .. desc
                    end
                    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
                end

                nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
                nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

                nmap('<leader>gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
                nmap('<leader>gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
                nmap('<leader>gi', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
                nmap('<leader>td', vim.lsp.buf.type_definition, 'Type [D]efinition')
                nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
                nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

                -- See `:help K` for why this keymap
                nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
                nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
            end

            ${functions.writeIf (cfg.languages.nix || cfg.languages.all) ''
                -- Nix config
                lspconfig.nil_ls.setup{
                    capabilities = capabilities,
                    on_attach=on_attach,
                    cmd = {"${pkgs.nil}/bin/nil"},
                }
            ''}

            ${functions.writeIf (cfg.languages.python || cfg.languages.all) ''
                -- Python config
                lspconfig.pyright.setup{
                    capabilities = capabilities,
                    on_attach=on_attach,
                    cmd = {"${pkgs.nodePackages.pyright}/bin/pyright-langserver", "--stdio"}
                }
            ''}

            ${functions.writeIf ( cfg.languages.c || cfg.languages.all ) ''
                -- CCLS (clang) config
                lspconfig.ccls.setup{
                    capabilities = capabilities,
                    on_attach=on_attach,
                    cmd = {"${pkgs.ccls}/bin/ccls"}
                }
            ''}

            ${functions.writeIf ( cfg.languages.ocaml || cfg.languages.all ) ''
                 -- Ocaml (ocaml-lsp) config
                lspconfig.ocamllsp.setup{
                    capabilities = capabilities,
                    on_attach=on_attach,
                    cmd = {"${pkgs.ocamlPackages.ocaml-lsp}/bin/ocamllsp"}
                }
            ''}

            ${functions.writeIf ( cfg.languages.lua || cfg.languages.all ) ''
                -- Lua config
                lspconfig.sumneko_lua.setup {
                    capabilities = capabilities,
                    on_attach=on_attach,
                    cmd = {"${pkgs.sumneko-lua-language-server}/bin/lua-language-server"}
                }
            ''}
        '';
    };
}

