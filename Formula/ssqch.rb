# Written by reverentgeek/sitesquatch's release workflow (scripts/release-files.mjs) for 0.10.1.
class Ssqch < Formula
  desc "Fast, pluggable static site generator, configured with JavaScript"
  homepage "https://github.com/reverentgeek/sitesquatch"
  url "https://registry.npmjs.org/ssqch/-/ssqch-0.10.1.tgz"
  sha256 "a69f8597fdb4bf279a80a0e7613a175a7ae825a596f35f0cfe6ae1f7ce140abf"
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
