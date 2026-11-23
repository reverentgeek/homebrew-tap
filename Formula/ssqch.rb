# Written by reverentgeek/sitesquatch's release workflow (scripts/release-files.mjs) for 0.14.0.
class Ssqch < Formula
  desc "Fast, pluggable static site generator, configured with JavaScript"
  homepage "https://github.com/reverentgeek/sitesquatch"
  url "https://registry.npmjs.org/ssqch/-/ssqch-0.14.0.tgz"
  sha256 "227b34d9a0fca4c0309845d90f8522f3fcbfc78e6826306dc7740e7bff6d755d"
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
