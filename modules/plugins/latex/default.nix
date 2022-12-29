{ pkgs, config, lib, functions, ...}:
with lib;
with builtins;

let
    cfg = config.customNeovim.plugins.latex;
in {
    options.customNeovim.plugins.latex = {
        enable = mkEnableOption "Enable Latex plugins";

        texMapLeader = mkOption {
            description = "Map leader for tex commands. Default: If blank, defaults to keymaps.mapLeader. If blank, and keymaps.mapLeader blank, defaults to backslash";
            type = types.str;
            default = config.customNeovim.keymaps.leader;
        };

        viewer = mkOption {
            description = "Which program to view live changes";
            type = types.str;
            default = "";
        };
    };

    config = mkIf cfg.enable {
        customNeovim.startupPlugins = with pkgs.neovimPlugins; [
            vimtex
        ];

        customNeovim.configRC = ''
            let g:vimtex_view_method = '${cfg.viewer}'
            ${functions.writeIf (cfg.texMapLeader != "") "let maplocalleader = \"${cfg.texMapLeader}\""}
        '';

        customNeovim.luaConfigRC = ''
        '';
    };
}

