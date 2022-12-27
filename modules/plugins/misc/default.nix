{ pkgs, config, lib, ...}:
with lib;
with builtins;

let
    cfg = config.customNeovim.plugins.misc;
in {
    options.customNeovim.plugins.misc = {
        enableIndentBlankline = mkEnableOption "Enable indent-blankline-nvim";
    };

    config = let
        writeIf = { c, v1, v2 ? "" }: if c then v1 else v2;
    in {
        customNeovim.startupPlugins = with pkgs.neovimPlugins; [
            ( if cfg.enableIndentBlankline then indent-blankline-nvim else null )
        ];

        customNeovim.luaConfigRC = ''
            ${writeIf {
                c = cfg.enableIndentBlankline;
                v1 = ''
                    require("indent_blankline").setup {
                        show_current_context = true,
                    }
                '';
            }}
        '';
    };
}

