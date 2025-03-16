{ config, pkgs, lib, ... }:
# Sourced from https://nixos.wiki/wiki/Blocky
{
  services.blocky = {
    enable = true; 
    settings = {
      ports.dns = 53;
      upstreams.groups.default = [
	"https://dns.quad9.net/dns-query"
        "https://one.one.one.one/dns-query"
      ];

      bootstrapDns = {
        upstream = "https://dns.quad9.net/dns-query";
        ips = [ "9.9.9.9" "149.112.112.112" ];
      };

      blocking = {
        blackLists = {
	  ads = ["https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"];
	};

	clientGroupsBlock = {
	  default = [ "ads" ];
	};
      };

      caching = {
        minTime = "5m";
	maxTime = "30m";
      };
    };
  };
};

