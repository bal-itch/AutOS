_: {
  # enable programs
  programs = {
    git = {
	enable = true;
	userName = "Sarah Martini";
        userEmail = "hiden64@protonmail.com";
	extraConfig = {
		#commit.gpgsign = true;
		#gpg.format = "ssh";
		#user.signingkey = "~/.ssh/id_ed25519.pub";
		init.defaultBranch = "master";
        };
    };
  };
}
