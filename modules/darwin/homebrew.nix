{ ... }:
{
  homebrew = {
    enable = true;

    onActivation = {
      cleanup = "none";
      autoUpdate = false;
      upgrade = false;
    };

    casks = [
      "cmux"
      "dbeaver-community"
      "raycast"
    ];
  };
}
