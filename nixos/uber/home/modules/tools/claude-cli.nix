{ config, lib, pkgs, ... }:

let
  cfg = config.claude;
  configOps = import ../../../lib/config-ops.nix { inherit lib pkgs; };
  claudePkg = (import (builtins.fetchTarball {
    url = "https://github.com/kumulustech/claude-nix/archive/refs/heads/main.tar.gz";
  }) { inherit pkgs; }).claude-code;

  tokenPath =
    if config ? age && config.age.secrets ? claude && config.age.secrets.claude ? path
    then config.age.secrets.claude.path
    else null;

  settingsPath = "${config.home.homeDirectory}/.claude/settings.json";
  rootPath = "${config.home.homeDirectory}/.claude.json";

  settingsFile = {
    path = settingsPath;
    format = "json";
    ops = [
      { op = "set"; path = "env.ANTHROPIC_AUTH_TOKEN"; fromFile = tokenPath; }
      { op = "set"; path = "env.ANTHROPIC_BASE_URL"; value = "https://open.bigmodel.cn/api/anthropic"; }
      { op = "set"; path = "env.API_TIMEOUT_MS"; value = "3000000"; }
      { op = "set"; path = "env.CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC"; value = 1; }
    ];
  };

  rootFile = {
    path = rootPath;
    format = "json";
    ops = [
      { op = "set"; path = "hasCompletedOnboarding"; value = true; }
    ];
  };
in
{
  options.claude = {
    enable = lib.mkEnableOption "Claude CLI";

    provider = lib.mkOption {
      type = lib.types.enum [ "anthropic" "glm" ];
      default = "anthropic";
      description = "Claude provider configuration to apply.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.provider != "glm" || tokenPath != null;
        message =
          "claude.provider is set to \"glm\" but age.secrets.claude is not configured.";
      }
    ];

    home.packages = [ claudePkg ];

    home.activation.claudeSettings = lib.mkIf (cfg.provider == "glm" && tokenPath != null) (configOps.mkActivation {
      name = "claude";
      files = [ settingsFile rootFile ];
    });
  };
}
