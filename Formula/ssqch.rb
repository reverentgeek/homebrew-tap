class Ssqch < Formula
  desc "The SiteSquatch command-line tool, configured by ssqch.config.js or sitesquatch.toml"
  homepage "https://github.com/reverentgeek/sitesquatch"
  version "0.3.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/reverentgeek/sitesquatch/releases/download/v0.3.4/ssqch-aarch64-apple-darwin.tar.gz"
      sha256 "88b8876c8fb107a2bf81f7676f27ff9f110d5eb484ad15983b52f0d79267700c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/reverentgeek/sitesquatch/releases/download/v0.3.4/ssqch-x86_64-apple-darwin.tar.gz"
      sha256 "c1dc5d314ddb7314391b9997e206fb637ccee50a9a235f46aa1f5d9f17aaa64d"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/reverentgeek/sitesquatch/releases/download/v0.3.4/ssqch-x86_64-unknown-linux-musl.tar.gz"
    sha256 "18d444b6f0b8202cdc5669b4d4da2a51d4241db41c58610334eab02033b5e7f0"
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
