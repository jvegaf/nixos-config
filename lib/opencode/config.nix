{
  inputs,
  lib,
  pkgs,
}:
let
  aiTools = ./ai-tools;

  treeEntries = root: prefix:
    lib.concatLists (
      lib.mapAttrsToList (
        name: type:
        let
          source = root + "/${name}";
          destination = "${prefix}/${name}";
        in
        if type == "directory" then treeEntries source destination else [ { name = destination; path = source; } ]
      ) (builtins.readDir root)
    );

  generatedFiles = [
    {
      name = "AGENTS.md";
      path = pkgs.writeText "opencode-agents" (builtins.readFile (aiTools + "/base.md"));
    }
  ];
in
pkgs.linkFarm "opencode-config" (
  generatedFiles
  ++ [
    {
      name = "skills/.keep";
      path = pkgs.writeText "opencode-skills-keep" "";
    }
  ]
  ++ treeEntries (aiTools + "/commands") "commands"
  ++ treeEntries (aiTools + "/agents") "agents"
  ++ treeEntries (aiTools + "/skills") "skills"
  ++ treeEntries (inputs.superpowers + "/skills") "skills/superpowers"
  # ++ treeEntries (inputs.matt-pocock-skills + "/skills/engineering") "skills/matt-pocock/engineering"
  # ++ treeEntries (inputs.matt-pocock-skills + "/skills/productivity") "skills/matt-pocock/productivity"
)
