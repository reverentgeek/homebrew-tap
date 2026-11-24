# Written by reverentgeek/sitesquatch's release workflow (scripts/release-files.mjs) for 0.15.0.
class Ssqch < Formula
  desc "Fast, pluggable static site generator, configured with JavaScript"
  homepage "https://github.com/reverentgeek/sitesquatch"
  url "https://registry.npmjs.org/ssqch/-/ssqch-0.15.0.tgz"
  sha256 "33a7245d334cb31aa2460d926e60559df1ef14e69bf6462a9be051a509eff52b"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match "ssqch #{version}", shell_output("#{bin}/ssqch --version")
    (testpath/"index.md").write "# Fresh tracks\n"
    system bin/"ssqch", "build"
    assert_match "Fresh tracks", (testpath/"_site/index.html").read
  end
end
