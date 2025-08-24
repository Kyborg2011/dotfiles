{ config, pkgs, lib, ... }:

{
  home.file = {
    ".config/Code/User/settings.json".source = lib.mkForce (
      config.lib.file.mkOutOfStoreSymlink "/etc/nixos/modules/home/dotfiles/Code/settings.json"
    );
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
