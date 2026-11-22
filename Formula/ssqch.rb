# Written by reverentgeek/sitesquatch's release workflow (scripts/release-files.mjs) for 0.13.3.
class Ssqch < Formula
  desc "Fast, pluggable static site generator, configured with JavaScript"
  homepage "https://github.com/reverentgeek/sitesquatch"
  url "https://registry.npmjs.org/ssqch/-/ssqch-0.13.3.tgz"
  sha256 "92501892252074ba990bda4650b28a397de01390c79b9a7b536f213a4b6681be"
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
