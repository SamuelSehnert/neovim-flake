{ pkgs, lib, config, ... }:
{
  imports = [
    ./core
    ./options
    ./plugins
  ];
}
