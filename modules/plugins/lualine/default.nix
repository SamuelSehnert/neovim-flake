{ pkgs, config, lib, ...}:
with lib;
with builtins;

let
    cfg = config.customNeovim.plugins.lualine;
in {
    options.customNeovim.plugins.lualine = {
        enable = mkEnableOption "Enable lualine";
        icons = mkEnableOption "Enable Icons";
    };

    config = let
        writeIf = { c, v1, v2 ? "" }: if c then v1 else v2;
        boolConvert = bool: if bool then "true" else "false";
    in mkIf cfg.enable {
        customNeovim.startupPlugins = with pkgs.neovimPlugins; [
            lualine-nvim
            ( if cfg.icons then nvim-web-devicons else null )
        ];

        customNeovim.luaConfigRC = ''
            require'lualine'.setup {
                icons_enabled = ${boolConvert cfg.icons},
            }
        '';
    };
}

