{ pkgs, config, lib, ...}:
with lib;
with builtins;

let
    cfg = config.customNeovim.plugins.gitsigns;
in {
    options.customNeovim.plugins.gitsigns = {
        enable = mkEnableOption "Enable gitsigns";
        blame = mkEnableOption "Enable git blame";
    };

    config = let
        writeIf = { c, v1, v2 ? "" }: if c then v1 else v2;
    in mkIf cfg.enable {
        customNeovim.startupPlugins = with pkgs.neovimPlugins; [
            gitsigns-nvim
        ];

        customNeovim.luaConfigRC = ''
            require('gitsigns').setup{
                ${writeIf { c = cfg.blame; v1 = "current_line_blame = true"; }},
            }
        '';
    };
}

