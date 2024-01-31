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
    qbittorrent-qt5
    spotify
    steam
    telegram-desktop
    vesktop
    vscodium
    winetricks
    yt-dlp
  ];
}
