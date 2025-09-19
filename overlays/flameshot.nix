# https://flameshot.org/docs/guide/wayland-help/#gnome-shortcut-does-not-trigger-flameshot
final: prev: {
  flameshot-wayland = (prev.flameshot.override {enableWlrSupport = true;}).overrideAttrs (oldAttrs: {
    buildInputs = oldAttrs.buildInputs ++ [prev.makeWrapper];
    preFixup = ''
      qtWrapperArgs+=("--set QT_QPA_PLATFORM wayland")
    '';
  });
}
