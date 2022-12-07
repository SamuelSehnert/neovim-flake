{ pkgs, lib, config, ... }:
with lib;
with builtins;

let
  cfg = config.customNeovim.keymaps;
in
{
  options.customNeovim.keymaps = {
    leader = mkOption {
      description = "";
      type = types.str;
      default = ",";
    };
    silent = mkOption {
      description = "";
      type = types.bool;
      default = true;
    };
    noremap = mkOption {
      description = "";
      type = types.bool;
      default = true;
    };
  };

  config = {
    customNeovim.coreKeymaps = let
      vimBoolConvert = input: if input then "true" else "false";
      ops = " { noremap = ${ vimBoolConvert cfg.noremap }, silent = ${ vimBoolConvert cfg.silent } } ";
    in
      ''
      local options = ${ops}
      vim.api.nvim_set_keymap("", "${cfg.leader}", "<Nop>", options )
      vim.g.mapleader = "${cfg.leader}"
      vim.g.maplocalleader = "${cfg.leader}"
      '';
  };
}

