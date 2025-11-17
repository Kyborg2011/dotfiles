{ pkgs-unstable, inputs, ... }:

let
  qs = inputs.quickshell.packages.${pkgs-unstable.stdenv.hostPlatform.system}.default;
in pkgs-unstable.stdenv.mkDerivation {
  name = "quickshell-wrapper";
  meta = with pkgs-unstable.lib; {
    description = "Quickshell wrapped + bundled Qt deps";
    license = licenses.gpl3Only;
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = with pkgs-unstable; [
    makeWrapper
    qt6.wrapQtAppsHook
  ];

  buildInputs = with pkgs-unstable; [
    qs
    kdePackages.qtwayland
    kdePackages.qtpositioning
    kdePackages.qtlocation
    kdePackages.syntax-highlighting
    gsettings-desktop-schemas
    qt6.qtbase 
    qt6.qtdeclarative 
    qt6.qt5compat 
    qt6.qtimageformats 
    qt6.qtmultimedia 
    qt6.qtpositioning 
    qt6.qtquicktimeline 
    qt6.qtsensors 
    qt6.qtsvg 
    qt6.qttools 
    qt6.qttranslations 
    qt6.qtvirtualkeyboard 
    qt6.qtwayland 
    kdePackages.kirigami 
    kdePackages.kdialog 
    kdePackages.syntax-highlighting 
  ];

  installPhase = ''
    mkdir -p $out/bin
    ls -l ${qs}/bin || true
    makeWrapper ${qs}/bin/qs $out/bin/qs \
      --prefix XDG_DATA_DIRS : ${pkgs-unstable.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs-unstable.gsettings-desktop-schemas.name}
    chmod +x $out/bin/qs
  '';
}
