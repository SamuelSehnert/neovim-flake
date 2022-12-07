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
        default = "";
      };

      syntax = mkOption {
        description = "To enable syntax highlighting or not";
        type = types.bool;
        default = true;
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

      smarttab = mkOption {
        description = "Try to be smart about tab placement";
        type = types.bool;
        default = true;
      };
  };

  config = let 
    writeIf = { c, v1, v2 ? "" }: if c then v1 else v2;
  in {
    customNeovim.configRC = ''
      ${ writeIf { c = ( cfg.colorscheme != "" ); v1 = "colorscheme ${cfg.colorscheme}"; } }
      ${ writeIf { c = cfg.syntax; v1 = "syntax on"; v2 = "syntax off"; } }

      set tabstop=${toString cfg.tabstop}
      set softtabstop=${toString cfg.softtabstop}
      set shiftwidth=${toString cfg.shiftwidth}
      ${ writeIf { c = cfg.expandtab; v1 = "set expandtab"; } }
      ${ writeIf { c = cfg.smarttab; v1 = "set smarttab"; } }
    '';
  };
}
