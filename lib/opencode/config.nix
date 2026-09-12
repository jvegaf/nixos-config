{
  inputs,
  lib,
  pkgs,
}:
let
  aiTools = ./ai-tools;
  commandFiles = (import (aiTools + "/commands.nix") { inherit lib; }).toOpenCodeMarkdown;
  agentFiles = (import (aiTools + "/agents.nix") { inherit lib; }).toOpenCodeMarkdown;

  textFile = name: content: {
    inherit name;
    path = pkgs.writeText (lib.replaceStrings [ "/" ] [ "-" ] name) content;
  };

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

  generatedFiles =
    lib.mapAttrsToList (name: content: textFile "commands/${name}.md" content) commandFiles
    ++ lib.mapAttrsToList (name: content: textFile "agents/${name}.md" content) agentFiles
    ++ [
      (textFile "AGENTS.md" (builtins.readFile (aiTools + "/base.md")))
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
  ++ treeEntries (aiTools + "/skills") "skills"
  ++ treeEntries (inputs.superpowers + "/skills") "skills/superpowers"
  ++ treeEntries (inputs.matt-pocock-skills + "/skills/engineering") "skills/matt-pocock/engineering"
  ++ treeEntries (inputs.matt-pocock-skills + "/skills/productivity") "skills/matt-pocock/productivity"
)
