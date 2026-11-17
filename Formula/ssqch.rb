class Ssqch < Formula
  desc "The SiteSquatch command-line tool, configured by ssqch.config.js or sitesquatch.toml"
  homepage "https://github.com/reverentgeek/sitesquatch"
  version "0.6.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/reverentgeek/sitesquatch/releases/download/v0.6.2/ssqch-aarch64-apple-darwin.tar.gz"
      sha256 "e26d1e511225645b6e8c9ab1d4a92d8d37b65a7eac9183b1f300e347ce51fe36"
    end
    if Hardware::CPU.intel?
      url "https://github.com/reverentgeek/sitesquatch/releases/download/v0.6.2/ssqch-x86_64-apple-darwin.tar.gz"
      sha256 "57a27f77f2efed75a5818b57a806de8f57f8244b2d06c7d5c6aa3c267a50b53e"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/reverentgeek/sitesquatch/releases/download/v0.6.2/ssqch-x86_64-unknown-linux-musl.tar.gz"
    sha256 "548dae8de298e88b32aaaada747d9d2bb0ef764d1ffb9adf5edbfbd7cc34cf2b"
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
