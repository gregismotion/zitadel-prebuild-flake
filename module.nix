self: {
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.zitadel;
in {
  options.services.zitadel = {
    enable = mkEnableOption {
      description = "Enables Zitadel.";
    };
    package = mkOption {
      type = types.package;
      default = self.packages.${pkgs.system}.default;
      description = "Zitadel package to use.";
    };
    masterKey = mkOption {
      type = types.string;
      description = "Master key that Zitadel uses."
    }
  };

  config = mkIf cfg.enable {
    systemd.services.zitadel = {
      description = "Starts Zitadel.";
      wantedBy = ["multi-user.target"];
      serviceConfig.ExecStart = ''
        ${cfg.package}/bin/zitadel start-from-init --masterkey "${cfg.masterKey}"
      '';
    };
  };
}
