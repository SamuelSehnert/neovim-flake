{ pkgs, lib, config, ...}:

with lib;
with builtins;

let
    cfg = config.customNeovim;
in {
    options.customNeovim = {
        viAlias = mkOption {
            description = "Enable vi alias";
            type = types.bool;
            default = false;
        };

        vimAlias = mkOption {
            description = "Enable vim alias";
            type = types.bool;
            default = false; 
        };

        luaConfigRC = mkOption {
            description = "Lua Config";
            type = types.lines;
            default = "";
        };

        configRC = mkOption {
            description = "Vimrc Config";
            type = types.lines;
            default = "";
        };

        coreKeymaps = mkOption {
            description = "Core keymaps";
            type = types.lines;
            default = "";
        };

        startupPlugins = mkOption {
            description = "Plugins to load on start";
            type = with types; listOf (nullOr package);
            default = [];
        };

        optionalPlugins = mkOption {
            description = "Plugins to be optionally loaded";
            type = with types; listOf (nullOr package);
            default = [];
        };
    };

    config = {
        customNeovim.configRC = ''
            lua << EOF
                ${cfg.coreKeymaps}
                ${cfg.luaConfigRC}
            EOF
        '';
    };
}
