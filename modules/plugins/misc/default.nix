{ pkgs, config, lib, functions, ...}:
with lib;
with builtins;

let
    cfg = config.customNeovim.plugins.misc;
in {
    options.customNeovim.plugins.misc = {
        enable-indent-blankline = mkEnableOption "Enable indent-blankline-nvim";
        enable-comment-nvim = mkEnableOption "Enable comment-nvim";
    };

    config = {
        customNeovim.startupPlugins = with pkgs.neovimPlugins; [
            ( if cfg.enable-indent-blankline then indent-blankline-nvim else null )
            ( if cfg.enable-comment-nvim then comment-nvim else null )
        ];

        customNeovim.luaConfigRC = ''
            ${functions.writeIf cfg.enable-indent-blankline
                ''
                    require("indent_blankline").setup {
                    }
                ''
            }
            ${functions.writeIf cfg.enable-comment-nvim
                ''
                    require("Comment").setup {}
                ''
            }
        '';
    };
}

