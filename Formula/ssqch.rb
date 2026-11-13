class Ssqch < Formula
  desc "The SiteSquatch command-line tool, configured by ssqch.config.js or sitesquatch.toml"
  homepage "https://github.com/reverentgeek/sitesquatch"
  version "0.5.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/reverentgeek/sitesquatch/releases/download/v0.5.2/ssqch-aarch64-apple-darwin.tar.gz"
      sha256 "1d8c01aa687e9b1ac662d77c7c22aa7d1592ef4c54b88bdba6cd3f56493bfe71"
    end
    if Hardware::CPU.intel?
      url "https://github.com/reverentgeek/sitesquatch/releases/download/v0.5.2/ssqch-x86_64-apple-darwin.tar.gz"
      sha256 "ed3725dcdf2b0fab60c162dfbfa1d448ed004d34b9da3760f5cb9c96b68d8470"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/reverentgeek/sitesquatch/releases/download/v0.5.2/ssqch-x86_64-unknown-linux-musl.tar.gz"
    sha256 "158dabe3781f124984985d2cb010267c96fcbdbafe238be1924e54cbfddf37b1"
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
