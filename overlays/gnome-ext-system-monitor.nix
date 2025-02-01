# Custom CSS and number formatting for gnome-shell system-monitor extension.
final: prev: {
  gnomeExtensions =
    prev.gnomeExtensions
    // {
      system-monitor = prev.gnomeExtensions.system-monitor.overrideAttrs (oldAttrs: rec {
        postInstall = ''
          cp ${./gnome-ext-system-monitor.css} $out/share/gnome-shell/extensions/system-monitor@gnome-shell-extensions.gcampax.github.com/stylesheet.css
        '';
      });
    };
}
