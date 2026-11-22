# Written by reverentgeek/sitesquatch's release workflow (scripts/release-files.mjs) for 0.13.4.
class Ssqch < Formula
  desc "Fast, pluggable static site generator, configured with JavaScript"
  homepage "https://github.com/reverentgeek/sitesquatch"
  url "https://registry.npmjs.org/ssqch/-/ssqch-0.13.4.tgz"
  sha256 "a615ab3306f6289257af5b112f9c0d88e02392bdfa7effa95e24a098db536b12"
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
