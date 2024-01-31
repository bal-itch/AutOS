{pkgs, ...}: {
  home.packages = with pkgs; [
    bitwarden
    chromium
    freetube
    hyfetch
    kate
    librewolf
    libsForQt5.kdenlive
    obs-studio
    plexamp
    spotify
    steam
    telegram-desktop
    transmission-qt
    vesktop
    vscodium
    winetricks
    yt-dlp
  ];
}
