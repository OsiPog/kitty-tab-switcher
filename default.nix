{
  pkgs,
  ...
}:

pkgs.writeShellApplication {
  name = "kitty-tab-switcher";
  
  runtimeInputs = with pkgs; [
    kitty
    jq
    fzf
  ];

  text = ''
    bash ${./kitty-tab-switcher} "$@"    
  '';
}
