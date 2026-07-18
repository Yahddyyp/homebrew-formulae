class PassTomb < Formula
  desc "pass extension: keep passwords encrypted inside a tomb (macOS DMG)"
  homepage "https://github.com/Yahddyyp/pass-tomb-osx"
  url "https://github.com/Yahddyyp/pass-tomb-osx.git",
      tag:      "v1.0.0",
      revision: "HEAD"
  license "GPL-3.0-or-later"
  head "https://github.com/Yahddyyp/pass-tomb-osx.git", branch: "main"

  depends_on "rust" => :build
  depends_on "pass"
  depends_on "gnupg"

  def install
    system "cargo", "install", *std_cargo_args

    # Create wrapper scripts so `pass open/close/timer/tomb` work natively
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
      Add these to your shell config (~/.zshrc or ~/.bashrc):

        export PASSWORD_STORE_ENABLE_EXTENSIONS=true
        export PASSWORD_STORE_EXTENSIONS_DIR="#{opt_share}/pass-extensions"

      Then create your first tomb:

        pass tomb <gpg-id>
        pass open
        pass close
        pass timer 30m

      Made by Yahddyyp
    EOS
  end
end
