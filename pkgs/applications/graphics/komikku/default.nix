{ lib
, fetchFromGitLab
, desktop-file-utils
, gettext
, glib
, gobject-introspection
, gtk4
, libadwaita
, libnotify
, webkitgtk_5_0
, meson
, ninja
, pkg-config
, python3
, wrapGAppsHook4
, nix-update-script
}:

python3.pkgs.buildPythonApplication rec {
  pname = "komikku";
  version = "1.15.0";

  format = "other";

  src = fetchFromGitLab {
    owner = "valos";
    repo = "Komikku";
    rev = "v${version}";
    hash = "sha256-dmi8a9Gf4ixq5oW6ewDGZYRmxY2qmUrD42DfjskRpHk=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    gettext
    glib # for glib-compile-resources
    desktop-file-utils
    gobject-introspection
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    libnotify
    webkitgtk_5_0
    gobject-introspection
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pygobject3
    beautifulsoup4
    brotli
    cloudscraper
    dateparser
    emoji
    keyring
    lxml
    python-magic
    natsort
    piexif
    pillow
    pure-protobuf
    rarfile
    unidecode
  ];

  # Tests require network
  doCheck = false;

  # Prevent double wrapping.
  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
    )
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = "komikku";
    };
  };

  meta = with lib; {
    description = "Manga reader for GNOME";
    homepage = "https://valos.gitlab.io/Komikku/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ chuangzhu infinitivewitch ];
  };
}
