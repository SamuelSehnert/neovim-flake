{ pkgs, config, lib, functions, ...}:
with lib;
with builtins;

let
    cfg = config.customNeovim.plugins.misc;
in {
    options.customNeovim.plugins.misc = {
        indent-blankline = {
            enable = mkEnableOption "Enable indent-blankline-nvim";
            char = mkOption {
                description = "Character to use for indent-blankline";
                type = types.str;
                default = "";
            };
          };
        comment-nvim.enable = mkEnableOption "Enable comment-nvim";
        vim-sleuth.enable = mkEnableOption "Enable vim-sleuth";
    };

    config = {
        customNeovim.startupPlugins = with pkgs.neovimPlugins; [
            ( if cfg.indent-blankline.enable then indent-blankline-nvim else null )
            ( if cfg.comment-nvim.enable then comment-nvim else null )
            ( if cfg.vim-sleuth.enable then vim-sleuth else null )
        ];

        customNeovim.luaConfigRC = ''
            ${functions.writeIf cfg.indent-blankline.enable
                ''
                    require("indent_blankline").setup {
                        ${functions.writeIf (cfg.indent-blankline.char != "")
                            "char = '${toString cfg.indent-blankline.char}',"
                        }
                    }
                ''
            }
            ${functions.writeIf cfg.comment-nvim.enable
                ''
                    require("Comment").setup {}
                ''
            }
        '';
    };
}

