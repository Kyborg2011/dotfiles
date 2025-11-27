{ config, pkgs, lib, params, ... }:

{
  xdg.mimeApps = {
    enable = true;
    defaultApplications = params.xdg-mime-default-apps;
    associations.added = params.xdg-mime-default-apps;
  };
}
