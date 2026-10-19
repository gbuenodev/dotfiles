# Work account on this Mac, managed by its own home-manager (only the Ghostty config).
# Self-contained: to drop it, delete this file and its line in flake.nix.
let
  name = "suaquadra";
  home = "/Users/${name}";
in
{
  # home-manager needs the home of every user it manages; nix-darwin does not
  # create the account (it is not in users.knownUsers), only reads this path
  users.users.${name}.home = home;

  home-manager.users.${name} = {
    imports = [ ../../home/ghostty.nix ];

    home.username = name;
    home.homeDirectory = home;
    home.stateVersion = "25.05";
  };
}
