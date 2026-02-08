# Custom CSS and number formatting for gnome-shell system-monitor extension.
_final: prev: {
  gnomeExtensions =
    prev.gnomeExtensions
    // {
      system-monitor = prev.gnomeExtensions.system-monitor.overrideAttrs (_oldAttrs: {
        postInstall = ''
          cp ${./gnome-ext-system-monitor.css} $out/share/gnome-shell/extensions/system-monitor@gnome-shell-extensions.gcampax.github.com/stylesheet.css
        '';
      });
    };
}
