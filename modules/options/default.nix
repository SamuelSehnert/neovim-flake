{ pkgs, lib, config, functions, ...}:
with lib;
with builtins;

let
    cfg = config.customNeovim.options;
in
{
    options.customNeovim.options = {
        colorscheme = mkOption {
            description = "Set the colorscheme. If left default or blank, default vim colorscheme will be uesd";
            type = types.str;
            default = "default";
        };

        syntax = mkOption {
            description = "To enable syntax highlighting or not";
            type = types.bool;
            default = false;
        };

        lineNumber = mkOption {
            description = "Set line number";
            type = with types; enum [ "relative" "relativenumber" "number" "" ];
            default = "";
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

        autoindent = mkOption {
            description = "Set autoindent";
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
            default = true;
        };

        scrolloff = mkOption {
            description = "Point at which to start moving page when scrolling";
            type = types.int;
            default = 8;
        };

        hlsearch = mkOption {
            description = "To highlight search results";
            type = types.bool;
            default = false;
        };

        ignorecase = mkOption {
            description = "To ignore case when searching";
            type = types.bool;
            default = false;
        };

        mouse = mkOption {
            description = "Enable Mouse";
            type = with types; enum ["a" "n" "v" "i" "c" ""];
            default = "";
        };
    };

    config = {
        customNeovim.configRC = ''
            syntax ${ if cfg.syntax then "on" else "off" }

            ${ functions.writeIf (cfg.lineNumber == "number") "set number" }
            ${ functions.writeIf (cfg.lineNumber == "relativenumber") "set relativenumber number" }
        '';
        customNeovim.luaConfigRC = ''
            vim.cmd [[colorscheme ${
                if config.customNeovim.themes.enable then
                    config.customNeovim.themes.theme
                else
                    cfg.colorscheme 
                }]]

            vim.opt.tabstop = ${toString cfg.tabstop}
            vim.opt.softtabstop = ${toString cfg.softtabstop}
            vim.opt.shiftwidth = ${toString cfg.shiftwidth}
            vim.opt.expandtab = ${boolToString cfg.expandtab}
            vim.opt.autoindent = ${boolToString cfg.autoindent}
            vim.opt.smartindent = ${boolToString cfg.smartindent}
            vim.opt.smarttab = ${boolToString cfg.smarttab}
            vim.opt.smartcase = ${boolToString cfg.smartcase}
            vim.opt.wrap = ${boolToString cfg.wrap}
            vim.opt.scrolloff = ${toString cfg.scrolloff}

            vim.opt.hlsearch = ${boolToString cfg.hlsearch}
            vim.opt.ignorecase = ${boolToString cfg.ignorecase}

            vim.opt.mouse = '${toString cfg.mouse}'
        '';
    };
}
