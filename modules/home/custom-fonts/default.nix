{ stdenv, inputs, ... }:

stdenv.mkDerivation {
  name = "custom-fonts";
  src = ./.;

  installPhase = ''
    mkdir -p $out/share/fonts/truetype/
    cp -r $src/*.{ttf,otf} $out/share/fonts/truetype/
    cp -r ${inputs.rofi-theme}/fonts/*.{ttf,otf} $out/share/fonts/truetype/
  '';
}
