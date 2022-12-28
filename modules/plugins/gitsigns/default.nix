{ pkgs, config, lib, functions, ...}:
with lib;
with builtins;

let
    cfg = config.customNeovim.plugins.gitsigns;
in {
    options.customNeovim.plugins.gitsigns = {
        enable = mkEnableOption "Enable gitsigns";
        blame = mkEnableOption "Enable git blame";
    };

    config = mkIf cfg.enable {
        customNeovim.startupPlugins = with pkgs.neovimPlugins; [
            gitsigns-nvim
        ];

        customNeovim.luaConfigRC = ''
            require('gitsigns').setup{
                ${ functions.writeIf cfg.blame "current_line_blame = true" },
            }
        '';
    };
}

