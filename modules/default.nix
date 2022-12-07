{ pkgs, lib, config, ... }:
{
  imports = [
    ./core
    ./options
    ./keymap
    ./plugins
  ];
}
