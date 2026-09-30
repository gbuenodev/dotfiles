{ lib, user, ... }:
let
  # Atalho 64 do macOS: ⌘Espaço abre o Spotlight. Desligado para o Raycast usar.
  # parameters = [ caractere (65535 = nenhum) código-da-tecla (49 = Espaço) modificadores (1048576 = ⌘) ]
  spotlightOff = lib.generators.toPlist { escape = true; } {
    enabled = false;
    value = {
      parameters = [
        65535
        49
        1048576
      ];
      type = "standard";
    };
  };

  asUser = cmd: ''launchctl asuser "$(id -u -- ${user})" sudo --user=${user} -- ${cmd}'';
in
{
  # system.defaults.CustomUserPreferences substituiria o dicionário
  # AppleSymbolicHotKeys inteiro; -dict-add altera só a entrada 64.
  system.activationScripts.postActivation.text = ''
    echo >&2 "configuring symbolic hotkeys..."
    ${asUser "defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 ${lib.escapeShellArg spotlightOff}"}
    ${asUser "/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u"}
  '';
}
