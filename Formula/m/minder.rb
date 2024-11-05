class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https://mindersec.github.io/"
  url "https://github.com/mindersec/minder/archive/refs/tags/v0.0.72.tar.gz"
  sha256 "b67a14c26c7577db9c00a04a1cb6a9311b63f8a5d4d88b40fff3149a437dcdad"
  license "Apache-2.0"
  head "https://github.com/mindersec/minder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02c69bb29ab2c8f4a906ab8b29eeb50f2b8cf120dfc289f459b6289112e6e0f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02c69bb29ab2c8f4a906ab8b29eeb50f2b8cf120dfc289f459b6289112e6e0f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "02c69bb29ab2c8f4a906ab8b29eeb50f2b8cf120dfc289f459b6289112e6e0f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ae480f9b10fb6c11fda5ab6520215eebf2294004f33057cc12128d6c0802cb1"
    sha256 cellar: :any_skip_relocation, ventura:       "89c5cbce0544b03f5310f4abb3134cf03ecd4ab0e096e1b7d9d941d4351c5fa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8d9ab2adab3082a419cb804eb66b2e606bfe9023dbd2ff3115c2e7f782b53e2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/mindersec/minder/internal/constants.CLIVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"

    generate_completions_from_executable(bin/"minder", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/minder version")

    output = shell_output("#{bin}/minder artifact list -p github 2>&1", 3)
    assert_match "No config file present, using default values", output
  end
end
