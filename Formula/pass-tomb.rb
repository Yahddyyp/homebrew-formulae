class PassTomb < Formula
  desc "The pass-tomb extension for macos"
  homepage "https://github.com/Yahddyyp/pass-tomb-osx"
  url "https://github.com/Yahddyyp/pass-tomb-osx.git",
      tag: "v1.0.0"
  license "MIT"
  head "https://github.com/Yahddyyp/pass-tomb-osx.git", branch: "main"

  depends_on "rust" => :build
  depends_on "pass"
  depends_on "gnupg"

  def install
    system "cargo", "install", *std_cargo_args

    (share/"pass-extensions").mkpath
    %w[tomb open close timer].each do |cmd|
      (share/"pass-extensions/#{cmd}.bash").write <<~EOS
        #!/bin/bash
        exec "#{bin}/pass-#{cmd}" "$@"
      EOS
      chmod 0755, share/"pass-extensions/#{cmd}.bash"
    end
  end

  def caveats
    <<~EOS
      Add to your shell config:

      bash/zsh (~/.bashrc or ~/.zshrc):
        export PASSWORD_STORE_ENABLE_EXTENSIONS=true
        export PASSWORD_STORE_EXTENSIONS_DIR="#{opt_share}/pass-extensions"

      fish (~/.config/fish/config.fish):
        set -x PASSWORD_STORE_ENABLE_EXTENSIONS true
        set -x PASSWORD_STORE_EXTENSIONS_DIR "#{opt_share}/pass-extensions"

      nushell (~/.config/nushell/env.nu):
        $env.PASSWORD_STORE_ENABLE_EXTENSIONS = "true"
        $env.PASSWORD_STORE_EXTENSIONS_DIR = "#{opt_share}/pass-extensions"

      elvish (~/.elvish/rc.elv):
        set-env PASSWORD_STORE_ENABLE_EXTENSIONS true
        set-env PASSWORD_STORE_EXTENSIONS_DIR #{opt_share}/pass-extensions

      xonsh (~/.xonshrc):
        $PASSWORD_STORE_ENABLE_EXTENSIONS = "true"
        $PASSWORD_STORE_EXTENSIONS_DIR = "#{opt_share}/pass-extensions"

      tcsh (~/.tcshrc):
        setenv PASSWORD_STORE_ENABLE_EXTENSIONS true
        setenv PASSWORD_STORE_EXTENSIONS_DIR #{opt_share}/pass-extensions

      oil (~/.oilrc):
        export PASSWORD_STORE_ENABLE_EXTENSIONS=true
        export PASSWORD_STORE_EXTENSIONS_DIR="#{opt_share}/pass-extensions"
    EOS
  end
end
