class Vlang < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  # NOTE: Keep this in sync with V compiler below when updating
  url "https://github.com/vlang/v/archive/0.2.tar.gz"
  sha256 "edc4685e1919d337fc390a87a268030b2b816ab0818f5f7727ccb9c0b6a8baa1"
  license "MIT"

  livecheck do
    url "https://raw.githubusercontent.com/vlang/v/master/CHANGELOG.md"
    regex(/## v?\s?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "c23cedc60c6004cb453fefeba70473fd56b5d856da6dd4c7ae8f57c92d8ca95b" => :big_sur
    sha256 "c1cd351872627566b1da7fd2d2759dd255aa99021a57d8b4e950ac7b96e7c175" => :catalina
    sha256 "d12d4bd7226aa06f7be1632455db6c85b20b996d85fc9f913645381607ba37e8" => :mojave
  end

  resource "vc" do
    # For every vlang release there is a matching commit of the V compiler in the format
    # "[v:master] {short SHA of the vlang release commit} - {vlang version number}".
    # The sources of this V compiler commit need to be used here
    url "https://github.com/vlang/vc.git",
        revision: "047460a4ae5f4a1ba8c31dc50ec5e50ebe80b7f6"
  end

  def install
    resource("vc").stage do
      system ENV.cc, "-std=gnu11", "-w", "-o", buildpath/"v", "v.c", "-lm"
    end
    system "./v", "self"
    libexec.install "cmd", "thirdparty", "v", "v.mod", "vlib"
    bin.install_symlink libexec/"v"
    pkgshare.install "examples"
  end

  test do
    cp pkgshare/"examples/hello_world.v", testpath
    system bin/"v", "-o", "test", "hello_world.v"
    assert_equal "Hello, World!", shell_output("./test").chomp
  end
end
