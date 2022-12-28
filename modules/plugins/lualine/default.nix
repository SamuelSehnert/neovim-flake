{ pkgs, config, lib, functions, ...}:
with lib;
with builtins;

let
    cfg = config.customNeovim.plugins.lualine;
in {
    options.customNeovim.plugins.lualine = {
        enable = mkEnableOption "Enable lualine";
        icons = mkEnableOption "Enable Icons";
    };

    config = mkIf cfg.enable {
        customNeovim.startupPlugins = with pkgs.neovimPlugins; [
            lualine-nvim
            ( if cfg.icons then nvim-web-devicons else null )
        ];

        customNeovim.luaConfigRC = ''
            require'lualine'.setup {
                icons_enabled = ${boolToString cfg.icons},
            }
        '';
    };
}

