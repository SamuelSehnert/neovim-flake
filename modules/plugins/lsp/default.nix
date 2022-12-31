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
            systemverilog = mkEnableOption "SystemVerilog LSP";
            typescript = mkEnableOption "Javascript/Typescript LSP";
            tex = mkEnableOption "Tex/LaTeX LSP";
            rust = mkEnableOption "Rust LSP";
            css = mkEnableOption "CSS LSP";
            json = mkEnableOption "JSON LSP";
        };

        trouble = mkEnableOption "Enable Trouble";
    };

    config = mkIf cfg.enable {

        customNeovim.startupPlugins = with pkgs.neovimPlugins; [
            nvim-lspconfig
            (if cfg.trouble then trouble else null )
            (pkgs.vimPlugins.nvim-code-action-menu)
        ];

        customNeovim.luaConfigRC = ''

            ${functions.writeIf cfg.trouble ''
                require('trouble').setup {}
                vim.keymap.set("n", "<leader>TT", "<cmd>TroubleToggle<cr>", {silent = true, noremap = true, desc = "[T]oggle[T]rouble"})
                vim.keymap.set("n", "<leader>TW", "<cmd>TroubleToggle workspace_diagnostics<cr>", {silent = true, noremap = true, desc = "[T]rouble [W]roup"})
                vim.keymap.set("n", "<leader>TD", "<cmd>TroubleToggle document_diagnostics<cr>", {silent = true, noremap = true, desc = "[T]rouble [D]ocument"})
            ''}

            local lspconfig = require('lspconfig')
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
            capabilities.textDocument.completion.completionItem.snippetSupport = true

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
                lspconfig.nil_ls.setup{
                    capabilities = capabilities,
                    on_attach=on_attach,
                    cmd = {"${pkgs.nil}/bin/nil"},
                }
            ''}
            ${functions.writeIf (cfg.languages.python || cfg.languages.all) ''
                lspconfig.pyright.setup{
                    capabilities = capabilities,
                    on_attach=on_attach,
                    cmd = {"${pkgs.nodePackages.pyright}/bin/pyright-langserver", "--stdio"}
                }
            ''}
            ${functions.writeIf ( cfg.languages.c || cfg.languages.all ) ''
                lspconfig.ccls.setup{
                    capabilities = capabilities,
                    on_attach=on_attach,
                    cmd = {"${pkgs.ccls}/bin/ccls"}
                }
            ''}
            ${functions.writeIf ( cfg.languages.ocaml || cfg.languages.all ) ''
                lspconfig.ocamllsp.setup{
                    capabilities = capabilities,
                    on_attach=on_attach,
                    cmd = {"${pkgs.ocamlPackages.ocaml-lsp}/bin/ocamllsp"}
                }
            ''}
            ${functions.writeIf ( cfg.languages.lua || cfg.languages.all ) ''
                lspconfig.sumneko_lua.setup {
                    capabilities = capabilities,
                    on_attach=on_attach,
                    cmd = {"${pkgs.sumneko-lua-language-server}/bin/lua-language-server"}
                }
            ''}
            ${functions.writeIf ( cfg.languages.systemverilog || cfg.languages.all ) ''
                lspconfig.svls.setup {
                    capabilities = capabilities,
                    on_attach=on_attach,
                    cmd = {"${pkgs.svls}/bin/svls"}
                }
            ''}
            ${functions.writeIf ( cfg.languages.typescript || cfg.languages.all ) ''
                lspconfig.tsserver.setup {
                    capabilities = capabilities;
                    on_attach=on_attach,
                    cmd = {
                        -- https://github.com/typescript-language-server/typescript-language-server/issues/411
                        "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server", "--stdio",
                        "--tsserver-path", "${pkgs.nodePackages.typescript}/lib/node_modules/typescript/lib"
                    }
                }
            ''}
            ${functions.writeIf ( cfg.languages.tex || cfg.languages.all ) ''
                lspconfig.texlab.setup {
                    capabilities = capabilities,
                    on_attach=on_attach,
                    cmd = {"${pkgs.texlab}/bin/texlab"}
                }
            ''}
            ${functions.writeIf ( cfg.languages.rust || cfg.languages.all ) ''
                lspconfig.rust_analyzer.setup {
                    capabilities = capabilities,
                    on_attach=on_attach,
                    cmd = {"${pkgs.rust-analyzer}/bin/rust-analyzer"}
                }
            ''}

            ${functions.writeIf ( cfg.languages.css || cfg.languages.all ) ''
                lspconfig.cssls.setup {
                    capabilities = capabilities,
                    on_attach=on_attach,
                    cmd = {"${pkgs.nodePackages.vscode-langservers-extracted}/bin/vscode-css-language-server", "--stdio"}
                }
            ''}

            ${functions.writeIf ( cfg.languages.json || cfg.languages.all ) ''
                lspconfig.jsonls.setup {
                    capabilities = capabilities,
                    on_attach=on_attach,
                    cmd = {"${pkgs.nodePackages.vscode-langservers-extracted}/bin/vscode-json-language-server", "--stdio"}
                }
            ''}
        '';
    };
}

