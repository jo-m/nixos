# Grafana and Prometheus.
# Default login is admin:admin.
{
  config,
  pkgs,
  unstablePkgs,
  ...
}: let
  grafanaDomain = "monitor";
  grafanaPort = 20000;
  promPort = 20001;
  promNodePort = 20002;
in {
  services.grafana = {
    enable = true;
    settings.server = {
      domain = "localhost:${toString grafanaPort}";
      http_port = grafanaPort;
      http_addr = "127.0.0.1";
    };
    openFirewall = false;

    provision = {
      enable = true;

      datasources.settings.datasources = [
        {
          name = "Prometheus";
          type = "prometheus";
          url = "http://${config.services.prometheus.listenAddress}:${toString config.services.prometheus.port}";
          isDefault = true;
          editable = false;
        }
      ];
    };
  };

  # https://nixos.org/manual/nixos/stable/#module-services-prometheus-exporters
  services.prometheus.exporters.node = {
    enable = true;
    port = promNodePort;
    openFirewall = false;
    # https://github.com/NixOS/nixpkgs/blob/nixos-24.05/nixos/modules/services/monitoring/prometheus/exporters.nix
    enabledCollectors = ["systemd"];
    # nix-shell -p prometheus-node-exporter --command 'node_exporter --help'
    extraFlags = [];
  };

  # https://wiki.nixos.org/wiki/Prometheus
  # https://nixos.org/manual/nixos/stable/#module-services-prometheus-exporters-configuration
  # https://github.com/NixOS/nixpkgs/blob/nixos-24.05/nixos/modules/services/monitoring/prometheus/default.nix
  services.prometheus = {
    enable = true;
    globalConfig.scrape_interval = "10s";
    listenAddress = "localhost";
    port = promPort;
    scrapeConfigs = [
      {
        job_name = "node";
        static_configs = [
          {
            targets = ["localhost:${toString config.services.prometheus.exporters.node.port}"];
          }
        ];
      }
    ];
  };
}
