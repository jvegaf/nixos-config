{ self, inputs, ... }: {
  flake.nixosModules.agents = { pkgs, lib, ... }: {
    environment.systemPackages = with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
        opencode
        pi
        # claude-plugins
        # skills
        # skills-installer
        # plannotator
        # workmux
        # ... other tools
      ];
  };

  flake.homeModules.agents = { pkgs, lib, ...}:
  let

    remote = url: headers: { inherit url headers; };
    local = command: args: { inherit command args; };

    # Every client gets these. The token placeholders resolve at activation from
    # the secret env files below, so nothing here reaches the Nix store as a
    # credential.
    sharedServers = {
      context7 = remote "https://mcp.context7.com/mcp" {
        CONTEXT7_API_KEY = "@CONTEXT7_API_KEY@";
      };
      gh_grep = remote "https://mcp.grep.app" { };

      codegraph = local "codegraph" [
        "serve"
        "--mcp"
      ];

      rea = local "npx" [
        "-y"
        "rea-agents@6.7.0"
        "mcp"
      ];
      # penpot = remote "https://penpot.iperez.dev/mcp/stream?userToken=@PENPOT_API_KEY@" { };
      # aws = (local "uvx" [ "awslabs.aws-documentation-mcp-server@latest" ]) // {
      #   env = {
      #     AWS_DOCUMENTATION_PARTITION = "aws";
      #     FASTMCP_LOG_LEVEL = "ERROR";
      #   };
      # };
      # maestro = local "maestro" [ "mcp" ];
      # "open-pencil" = local (lib.getExe pkgs.open-pencil-mcp) [ ];
      # obsidian = local "pnpx" [
      #   "@mauricio.wolff/mcp-obsidian@latest"
      #   "${config.home.homeDirectory}/Atlas"
      # ];
      # "dbflux-ui" = local "/home/iperez/dev/personal/Rust/dbflux-worktree/main/target/debug/gpui-mcp" [
      #   "--app-id"
      #   "dbflux"
      # ];
    };

  in
  {

    imports = [ inputs.gentle-ai-nix.homeManagerModules.default ];

    programs.gentle-ai = {
      enable = true;

      providers = {
        opencode = {
          enable = true;
          mcpServers = sharedServers;
        };

        # Pi keeps its harness in packages its own tool installs rather than in
        # files, so rendering produces the configuration around it and activation
        # runs the installation Gentle AI declares for it.
        pi = {
          enable = true;

          # The tip of gentle-shell's main branch, pinned by gentle-ai-nix,
          # instead of the npm release that flake supports.
          release = "main";

          # Launch through the standalone `gentle-shell`, which runs the Pi its
          # package carries under Node; gentle-pi is then provisioned from that
          # same package, so `pi` and `gentle-shell` load one copy. Under the
          # standalone Pi binary, gentle-pi's helper processes (its notification
          # audio among them) cannot start. `gentle-shell home link` makes it use
          # ~/.pi/agent, which is what this configuration renders.
          launcher.enable = true;
          mcpServers = sharedServers;
          provisionPackages = true;

          # The install commands name packages without naming versions, so their
          # text never changes while what npm resolves them to does. Stamped by
          # that text they run once, which froze gentle-pi at the version the
          # first activation happened to install.
          provisionRefresh = true;

          # gentle-pi's postinstall downloads its private, package-pinned Gentle AI
          # binary and extracts it with /usr/bin/tar or /bin/tar by absolute path.
          # NixOS lacks those host paths, so normal provisioning defers that lifecycle
          # to the compatibility repair below; the global CLI is not an equivalent.
          provisionEnvironment.GENTLE_PI_SKIP_GENTLE_AI_INSTALL = "1";
          settings.theme = "Gentleman-Cute";
          # gentle-shell provides the compact codemode tool; loading Pi's built-in
          # implementation as well emits an extension collision at startup.
          settings.extensions = [ "-builtin:codemode" ];
          # gentle-pi agent profiles carry the whole routing: the orchestrator Pi
          # itself runs on and the model each phase agent gets. Naming one active
          # is the declarative form of applying it in /gentle:profiles, so a
          # switch is what a profile change takes. An agent a profile does not
          # name inherits whatever routing is in force outside the profile.

          # activeProfile = "claude";
          # profiles =
          #   let
          #     # The provider ids Pi resolves on this machine; `for` turns each one
          #     # into the constructor the profiles below name their models with, so
          #     # a binding reads as the model rather than as the pair it builds.
          #     models = inputs.gentle-ai-nix.lib.models;
          #     providers = models.for {
          #       codex = "openai-codex";
          #       nan = "nan";
          #       claude = "claude-bridge";
          #     };
          #     sol = providers.onCodex "gpt-6.1-sol";
          #     luna = providers.onCodex "gpt-6-luna";
          #     terra = providers.onCodex "gpt-5.6-terra";
          #     astra = providers.onCodex "gpt-6-astra";
          #     glm53Flash = providers.onNan "glm5.3-flash";
          #     deepseekV4Flash = providers.onNan "deepseek-v4-flash";
          #     qwen38Flash = providers.onNan "qwen3.8-flash";
          #     opus = providers.onClaude "claude-opus-5-5";
          #     sonnet = providers.onClaude "claude-sonnet-5";
          #   in
          #   {
          #     codex = {
          #       orchestrator = models.effort.medium sol;
          #       phases = {
          #         jd-judge-a = models.effort.medium sol;
          #         jd-judge-b = models.effort.medium sol;
          #         jd-fix-agent = models.effort.low sol;
          #         gentle-ai-explore = models.effort.medium luna;
          #         gentle-ai-verify = models.effort.medium sol;
          #         gentle-ai-worker = models.effort.low sol;
          #         review-readability = models.effort.medium sol;
          #         review-refuter = models.effort.medium sol;
          #         review-reliability = models.effort.medium sol;
          #         review-resilience = models.effort.medium sol;
          #         review-risk = models.effort.medium sol;
          #         review-validator = models.effort.medium sol;
          #       };
          #     };
          #
          #     nan = {
          #       orchestrator = models.effort.high deepseekV4Flash;
          #       phases = {
          #         jd-judge-a = models.effort.high glm53Flash;
          #         jd-judge-b = models.effort.high deepseekV4Flash;
          #         jd-fix-agent = models.effort.high glm53Flash;
          #         review-risk = models.effort.high glm53Flash;
          #         gentle-ai-worker = models.effort.high glm53Flash;
          #         gentle-ai-explore = models.effort.high deepseekV4Flash;
          #         gentle-ai-verify = models.effort.high deepseekV4Flash;
          #         review-refuter = models.effort.high deepseekV4Flash;
          #         review-readability = models.effort.high deepseekV4Flash;
          #         review-reliability = models.effort.high deepseekV4Flash;
          #         review-resilience = models.effort.high deepseekV4Flash;
          #         review-validator = models.effort.high deepseekV4Flash;
          #       };
          #     };
          #
          #     mixedCodex = {
          #       orchestrator = models.effort.medium sol;
          #       phases = {
          #         jd-judge-a = models.effort.high sol;
          #         jd-judge-b = models.effort.high deepseekV4Flash;
          #         jd-fix-agent = models.effort.high glm53Flash;
          #         gentle-ai-explore = models.effort.high deepseekV4Flash;
          #         gentle-ai-worker = models.effort.high glm53Flash;
          #         gentle-ai-verify = models.effort.high sol;
          #         review-readability = models.effort.high sol;
          #         review-refuter = models.effort.high sol;
          #         review-reliability = models.effort.high sol;
          #         review-resilience = models.effort.high sol;
          #         review-risk = models.effort.high sol;
          #         review-validator = models.effort.high sol;
          #       };
          #     };
          #
          #     mixedClaude = {
          #       orchestrator = models.effort.medium opus;
          #       phases = {
          #         jd-judge-a = models.effort.medium opus;
          #         jd-judge-b = models.effort.high deepseekV4Flash;
          #         jd-fix-agent = models.effort.high deepseekV4Flash;
          #         gentle-ai-explore = models.effort.high deepseekV4Flash;
          #         gentle-ai-worker = models.effort.high deepseekV4Flash;
          #         gentle-ai-verify = models.effort.medium opus;
          #         review-readability = models.effort.medium opus;
          #         review-refuter = models.effort.medium opus;
          #         review-reliability = models.effort.medium opus;
          #         review-resilience = models.effort.medium opus;
          #         review-risk = models.effort.medium opus;
          #         review-validator = models.effort.medium opus;
          #       };
          #     };
          #
          #     claude = {
          #       orchestrator = models.effort.medium opus;
          #       phases = {
          #         gentle-ai-explore = models.effort.low opus;
          #         gentle-ai-worker = models.effort.low opus;
          #         gentle-ai-verify = models.effort.medium opus;
          #         jd-judge-a = models.effort.medium opus;
          #         jd-judge-b = models.effort.medium opus;
          #         jd-fix-agent = models.effort.low opus;
          #         review-readability = models.effort.medium opus;
          #         review-refuter = models.effort.medium opus;
          #         review-reliability = models.effort.medium opus;
          #         review-resilience = models.effort.medium opus;
          #         review-risk = models.effort.medium opus;
          #         review-validator = models.effort.medium opus;
          #       };
          #     };
          #   };
        };
      };

      components = {
        skills.enable = true;
        persona.enable = true;
        permissions.enable = true;
        sdd.enable = false;
        theme.enable = true;
        engram.enable = true;
      };

      install.channel = "beta";

      communityTools.codegraph.enable = true;

      persona = "Gentleman";

      # TODO: add opencode plugins
      # "plugin": [
      #   "@mohak34/opencode-notifier@latest",
      #   "@tarquinen/opencode-smart-title"
      # ]
    };

  };
}
