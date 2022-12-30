{ pkgs, config, lib, functions, ...}:
with lib;
with builtins;

let
    cfg = config.customNeovim.themes;
in {
    options.customNeovim.themes = {
        enable = mkEnableOption "Enable themes";
        theme = mkOption {
            description = "Which downloaded theme to use";
            type = with types; enum [
                "onedark"
                "gruvbox"
            ];
            default = "";
        };
    };

    config = mkIf cfg.enable {
        customNeovim.startupPlugins = with pkgs.vimPlugins; [
            (if cfg.theme == "onedark" then onedark-nvim else null)
            (if cfg.theme == "gruvbox" then gruvbox-nvim else null)
        ];
    };
}

