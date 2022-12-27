{ pkgs, lib, config, ...}:
with lib;
with builtins;

let
    cfg = config.customNeovim.options;
in
{
    # Needs to be the same as cfg
    options.customNeovim.options = {
        colorscheme = mkOption {
            description = "Set the colorscheme. If left default or blank, default vim colorscheme will be uesd";
            type = types.str;
            default = "default";
        };

        syntax = mkOption {
            description = "To enable syntax highlighting or not";
            type = types.bool;
            default = true;
        };

        lineNumber = mkOption {
            description = "Set line number";
            type = with types; enum [ "relative" "relativenumber" "number" ];
            default = "number";
        };

        tabstop = mkOption {
            description = "How many columns of whitespace is a tab worth";
            type = types.int;
            default = 4;
        };

        softtabstop = mkOption {
            description = "How many columns of whitespace is a tab keypress or a backspace keypress worth";
            type = types.int;
            default = 4;
        };

        shiftwidth = mkOption {
            description = "How many columns of whitespace a “level of indentation” is worth";
            type = types.int;
            default = 4;
        };

        expandtab = mkOption {
            description = "To expand tabs out to spaces or not";
            type = types.bool;
            default = true;
        };

        smartindent = mkOption {
            description = "Try to be smart about indents";
            type = types.bool;
            default = true;
        };

        smarttab = mkOption {
            description = "Try to be smart about tab placement";
            type = types.bool;
            default = true;
        };

        smartcase = mkOption {
            description = "Try to be smart about cases when searching, etc";
            type = types.bool;
            default = true;
        };

        wrap = mkOption {
            description = "To wrap lines or not";
            type = types.bool;
            default = false;
        };

        scrolloff = mkOption {
            description = "Point at which to start moving page when scrolling";
            type = types.int;
            default = 8;
        };

        hlsearch = mkOption {
            description = "To highlight search results";
            type = types.bool;
            default = true;
        };

        ignorecase = mkOption {
            description = "To ignore case when searching";
            type = types.bool;
            default = true;
        };

        mouse = mkOption {
            description = "Enable Mouse";
            type = with types; enum ["a" "n" "v" "i" "c" ""];
            default = "";
        };
    };

    config = let 
        writeIf = { c, v1, v2 ? "" }: if c then v1 else v2;
        boolConvert = bool: if bool then "true" else "false";
    in {
        customNeovim.configRC = ''
            colorscheme ${toString cfg.colorscheme}
            syntax ${ writeIf { c = cfg.syntax; v1 = "on"; v2 = "off"; } }

            ${ writeIf { c = (cfg.lineNumber == "number"); v1 = "set number"; } }
            ${ writeIf { c = (cfg.lineNumber == "relativenumber"); v1 = "set relativenumber number"; } }
        '';
        customNeovim.luaConfigRC = ''
            local opt = vim.opt;
            opt.tabstop = ${toString cfg.tabstop};
            opt.softtabstop = ${toString cfg.softtabstop};
            opt.shiftwidth = ${toString cfg.shiftwidth};
            opt.expandtab = ${boolConvert cfg.expandtab};
            opt.smartindent = ${boolConvert cfg.smartindent};
            opt.smarttab = ${boolConvert cfg.smarttab};
            opt.smartcase = ${boolConvert cfg.smartcase};
            opt.wrap = ${boolConvert cfg.wrap};
            opt.scrolloff = ${toString cfg.scrolloff};

            opt.hlsearch = ${boolConvert cfg.hlsearch};
            opt.ignorecase = ${boolConvert cfg.ignorecase};

            opt.mouse = ${toString cfg.mouse};
        '';
    };
}
