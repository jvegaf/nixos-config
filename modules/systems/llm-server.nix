{
  flake.nixosModules.llm-server =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      # Modelo fijado por URL + hash (reproducible, verificado)
      model = pkgs.fetchurl {
        name = "qwen3.5-4b-q4_k_m.gguf";
        url = "https://huggingface.co/bartowski/Qwen_Qwen3.5-4B-GGUF/resolve/main/Qwen_Qwen3.5-4B-Q4_K_M.gguf";
        hash = lib.fakeHash; # sustituir por el hash real (ver abajo)
      };
    in
    {
      # --- Headless, sin suspensión ---
      systemd.targets.sleep.enable = false;
      systemd.targets.suspend.enable = false;
      systemd.targets.hibernate.enable = false;
      systemd.targets.hybrid-sleep.enable = false;
      # services.logind.settings.Login = {
      #   HandleLidSwitch = "ignore";
      #   HandleLidSwitchExternalPower = "ignore";
      # };

      services.thermald.enable = true;

      # --- Servidor llama.cpp ---
      services.llama-cpp = {
        enable = true;
        # package = pkgs.llama-cpp.override { vulkanSupport = true; };  # solo si usas la MX150
        model = "${model}";
        host = "0.0.0.0";
        port = 8080;
        extraFlags = [
          "-t"
          "4"
          "-c"
          "8192"
          "-np"
          "1"
          "--jinja"
        ];
      };

      # --- Firewall: solo tu subred ---
      networking.nftables.enable = true;
      networking.firewall.extraInputRules = ''
        ip saddr 192.168.8.0/24 tcp dport 8080 accept
      '';

      services.avahi = {
        enable = true;
        nssmdns4 = true;
        publish = {
          enable = true;
          addresses = true;
        };
      };
    };
}
