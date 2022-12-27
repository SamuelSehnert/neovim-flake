{ pkgs, config, lib, ...}:
with lib;
with builtins;

let
    cfg = config.customNeovim.plugins.misc;
in {
    options.customNeovim.plugins.misc = {
        enable-indent-blankline = mkEnableOption "Enable indent-blankline-nvim";
        enable-comment-nvim = mkEnableOption "Enable comment-nvim";
    };

    config = let
        writeIf = { c, v1, v2 ? "" }: if c then v1 else v2;
    in {
        customNeovim.startupPlugins = with pkgs.neovimPlugins; [
            ( if cfg.enable-indent-blankline then indent-blankline-nvim else null )
            ( if cfg.enable-comment-nvim then comment-nvim else null )
        ];

        customNeovim.luaConfigRC = ''
            ${writeIf {
                c = cfg.enable-indent-blankline;
                v1 = ''
                    require("indent_blankline").setup {
                        show_current_context = true,
                    }
                '';
            }}
            ${writeIf {
                c = cfg.enable-comment-nvim;
                v1 = ''
                    require("Comment").setup {}
                '';
            }}
        '';
    };
}

