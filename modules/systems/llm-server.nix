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
        name = "DeepSeek-V4-Pro-Qwen3.5-4B-UNCENSORED-heretic.Q4_K_M.gguf";
        # url = "https://huggingface.co/bartowski/Qwen_Qwen3.5-4B-GGUF/resolve/main/Qwen_Qwen3.5-4B-Q4_K_M.gguf";
        # hash = "sha256-E8FvQmBH4t44zQdb2t5Ke8vIx3Q4SHb2d3QM2mX4qYM=";
        url = "https://huggingface.co/mradermacher/DeepSeek-V4-Pro-Qwen3.5-4B-UNCENSORED-heretic-GGUF/resolve/main/DeepSeek-V4-Pro-Qwen3.5-4B-UNCENSORED-heretic.Q4_K_M.gguf";
        hash = "sha256-H0/HJgpTbz+7ub8j/oX2/n5US3qFi+22/H9wAOdiK4E=";

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
      systemd.services.llama-server = {
        description = "llama.cpp server";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig = {
          ExecStart = lib.escapeShellArgs [
            "${pkgs.llama-cpp}/bin/llama-server"
            "-m"
            "${model}"
            "--host"
            "0.0.0.0"
            "--port"
            "8080"
            "-t"
            "4"
            "-c"
            "8192"
            "-np"
            "1"
            "--jinja"
            "--alias"
            # "qwen3.5-4b"
            "qwen3.5-4b-uncensored"
          ];
          Restart = "on-failure";
          RestartSec = 5;

          # Endurecimiento básico
          DynamicUser = true;
          StateDirectory = "llama-server";
          Environment = "HOME=/var/lib/llama-server";
          NoNewPrivileges = true;
          ProtectSystem = "strict";
          ProtectHome = true;
          PrivateTmp = true;
        };
      };

      services.open-webui = {
        enable = true;
        host = "0.0.0.0";
        port = 5000;
        environment = {
          # Sin Ollama: hablamos solo con llama-server en local
          ENABLE_OLLAMA_API = "False";
          OPENAI_API_BASE_URL = "http://127.0.0.1:8080/v1";
          OPENAI_API_KEY = "none"; # cualquier valor no vacío si llama-server no usa --api-key

          # Con -np 1 y una CPU lenta, las peticiones auxiliares compiten con tu chat
          ENABLE_TITLE_GENERATION = "False";
          ENABLE_TAGS_GENERATION = "False";
          ENABLE_FOLLOW_UP_GENERATION = "False";
          ENABLE_AUTOCOMPLETE_GENERATION = "False";
          ENABLE_SEARCH_QUERY_GENERATION = "False";
          ENABLE_RETRIEVAL_QUERY_GENERATION = "False";
        };
      };

      # --- Firewall: solo tu subred ---
      networking.nftables.enable = true;
      networking.firewall.extraInputRules = ''
        ip saddr 192.168.8.0/24 tcp dport { 5000, 8080 } accept
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
