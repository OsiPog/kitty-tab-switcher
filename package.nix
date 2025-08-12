{
  lib,
  writeShellApplication,
  kitty,
  jq,
  fzf,
}:
writeShellApplication {
  name = "kitty-tab-switcher";

  runtimeInputs = [kitty jq fzf];

  text = builtins.readFile ./kitty-tab-switcher;

  meta = with lib; {
    description = "Fuzzy finder for switching between kitty terminal tabs";
    homepage = "https://github.com/osipog/kitty-tab-switcher";
    license = licenses.mit;
    maintainers = with maintainers; [];
    platforms = platforms.unix;
  };
}
