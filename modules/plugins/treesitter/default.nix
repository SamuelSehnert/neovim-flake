{ pkgs, config, lib, functions, ...}:
with lib;
with builtins;

let
    cfg = config.customNeovim.plugins.treesitter;
in {
    options.customNeovim.plugins.treesitter = {
        enable = mkEnableOption "Enable tree-sitter";
        folding = mkEnableOption "Enable folding";
        context = mkEnableOption "Enable context";
    };

    config = mkIf cfg.enable {
        customNeovim.startupPlugins = with pkgs.neovimPlugins; [
            nvim-treesitter
            (if cfg.context then nvim-treesitter-context else null)
        ];

        customNeovim.configRC = functions.writeIf cfg.folding ''
            " Tree-sitter based folding
            set foldmethod=expr
            set foldexpr=nvim_treesitter#foldexpr()
            set nofoldenable
        '';

        customNeovim.luaConfigRC = ''
            -- Treesitter config
            require'nvim-treesitter.configs'.setup {
                highlight = {
                    enable = true,
                    disable = {},
                },

                auto_install = false,
                ensure_isntalled = {},

                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "gnn",
                        node_incremental = "grn",
                        scope_incremental = "grc",
                        node_decremental = "grm",
                    },
                },
            }
            ${functions.writeIf cfg.context
            ''
                -- Treesitter Context config
                require'treesitter-context'.setup {
                    enable = true,
                    throttle = true,
                    max_lines = 0
                }
            ''}
        '';
    };
}

