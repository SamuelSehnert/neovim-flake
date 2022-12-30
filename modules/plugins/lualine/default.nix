{ pkgs, config, lib, functions, ...}:
with lib;
with builtins;

let
    cfg = config.customNeovim.plugins.lualine;
in {
    options.customNeovim.plugins.lualine = {
        enable = mkEnableOption "Enable lualine";
        icons = mkEnableOption "Enable Icons";
        seperator = mkOption {
            description = "What character to use as a seperator";
            type = types.str;
            default = "";
        };
        section-seperator = mkOption {
            description = "What character to use as a section seperator";
            type = types.str;
            default = "";
        };

    };

    config = mkIf cfg.enable {
        customNeovim.startupPlugins = with pkgs.neovimPlugins; [
            lualine-nvim
            ( if cfg.icons then nvim-web-devicons else null )
        ];

        customNeovim.luaConfigRC = ''
            require'lualine'.setup {
                options = {
                    icons_enabled = ${boolToString cfg.icons},
                    ${functions.writeIf (cfg.seperator != "") "component_seperators = '${cfg.seperator}'"}
                    ${functions.writeIf (cfg.section-seperator != "") "section_seperators = '${cfg.section-seperators}'"}
                }
            }
        '';
    };
}

