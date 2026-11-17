class Ssqch < Formula
  desc "The SiteSquatch command-line tool, configured by ssqch.config.js or sitesquatch.toml"
  homepage "https://github.com/reverentgeek/sitesquatch"
  version "0.6.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/reverentgeek/sitesquatch/releases/download/v0.6.3/ssqch-aarch64-apple-darwin.tar.gz"
      sha256 "2cd34d2cbb4067e9d58cf2dd20f1dbeac22e768b1a56fa9b5c0e8399ee47e8c5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/reverentgeek/sitesquatch/releases/download/v0.6.3/ssqch-x86_64-apple-darwin.tar.gz"
      sha256 "16a151cdb6822ce6e459a80622ff9bc17d137ba024c3b097259ffcd55680da62"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/reverentgeek/sitesquatch/releases/download/v0.6.3/ssqch-x86_64-unknown-linux-musl.tar.gz"
    sha256 "fd745f41f41bfe1fb52c136a965308b25f69eb476b6a1598c14f585ca7542302"
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
