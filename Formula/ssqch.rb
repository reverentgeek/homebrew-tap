class Ssqch < Formula
  desc "The SiteSquatch command-line tool, configured by ssqch.config.js or sitesquatch.toml"
  homepage "https://github.com/reverentgeek/sitesquatch"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/reverentgeek/sitesquatch/releases/download/v0.5.0/ssqch-aarch64-apple-darwin.tar.gz"
      sha256 "92ad3390ebc63217a25a95af66af15adbb26101d67977f2f5a8be669a9ffd197"
    end
    if Hardware::CPU.intel?
      url "https://github.com/reverentgeek/sitesquatch/releases/download/v0.5.0/ssqch-x86_64-apple-darwin.tar.gz"
      sha256 "cf03aff399792a122212f38809a97ed32972432e14ddba1b81326be13ebfa8e8"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/reverentgeek/sitesquatch/releases/download/v0.5.0/ssqch-x86_64-unknown-linux-musl.tar.gz"
    sha256 "b7103e38b8f1d512002aaafe29ecf34d805af368447b4e0f5439e78af611a6c9"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "ssqch"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "ssqch"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "ssqch"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
