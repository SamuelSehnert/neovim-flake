{ pkgs, config, lib, functions, ...}:
with lib;
with builtins;

let
    cfg = config.customNeovim.plugins.gitsigns;
in {
    options.customNeovim.plugins.gitsigns = {
        enable = mkEnableOption "Enable gitsigns";
        blame = mkEnableOption "Enable git blame";
        signs = {
            add = mkOption {
                description = "Char to use for adding";
                type = types.str;
                default = "+";
            };
            change = mkOption {
                description = "Char to use for adding";
                type = types.str;
                default = "~";
            };
            delete = mkOption {
                description = "Char to use for adding";
                type = types.str;
                default = "_";
            };
            topdelete = mkOption {
                description = "Char to use for adding";
                type = types.str;
                default = "‾";
            };
            changedelete = mkOption {
                description = "Char to use for adding";
                type = types.str;
                default = "~";
            };

        };
    };

    config = mkIf cfg.enable {
        customNeovim.startupPlugins = with pkgs.neovimPlugins; [
            gitsigns-nvim
        ];

        customNeovim.luaConfigRC = ''
            require('gitsigns').setup{
                ${ functions.writeIf cfg.blame "current_line_blame = true" },
                signs = {
                    add = { text = '${cfg.signs.add}' },
                    change = { text = '${cfg.signs.change}' },
                    delete = { text = '${cfg.signs.delete}' },
                    topdelete = { text = '${cfg.signs.topdelete}' },
                    changedelete = { text = '${cfg.signs.changedelete}' },
                },
            }
        '';
    };
}

