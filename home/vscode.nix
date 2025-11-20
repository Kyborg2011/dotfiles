{ config, pkgs, lib, params, ... }:

{
  home.file = {
    ".config/Code/User/settings.json".source = lib.mkForce (
      config.lib.file.mkOutOfStoreSymlink "${params.config_base_path}/home/dotfiles/Code/settings.json"
    );
    ".config/code-flags.conf".text = ''
      --ozone-platform=wayland
      --enable-features=UseOzonePlatform,WaylandLinuxDrmSyncobj,TouchpadOverscrollHistoryNavigation
      --enable-wayland-ime
      --gtk-version=4
      --ignore-gpu-blocklist
      --password-store=gnome-libsecret
    '';
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhsWithPackages (ps: with ps; [ rustup zlib openssl.dev pkg-config ]);
    profiles.default = {
      extensions = []
        ++ (with pkgs.vscode-extensions; [
          ms-python.python
          ms-toolsai.jupyter
          ms-vscode.cpptools
          golang.go
          james-yu.latex-workshop
          redhat.java
          rust-lang.rust-analyzer
        ]);
    };
  };
}
