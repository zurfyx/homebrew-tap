class Minitart < Formula
  desc "GitHub Actions runners on your own Mac, every job in a fresh Tart VM"
  homepage "https://minitart.rovira.sh"
  url "https://github.com/zurfyx/minitart/releases/download/v0.1.21/minitart-0.1.21.tar.gz"
  version "0.1.21"
  sha256 "b469ed47edbc9f3d0fad8a27798710800176bc447e83fd087aa647fc6734f756"
  license "MIT"

  depends_on arch: :arm64
  depends_on :macos
  depends_on "node"

  def install
    libexec.install "src", "dashboard", "images", "firewall", "package.json", "VERSION"
    (bin/"minitart").write <<~SH
      #!/bin/sh
      exec "#{formula_opt_bin("node")}/node" "#{libexec}/src/main.ts" "$@"
    SH
    pkgshare.install "README.md", "LICENSE", "docs"
  end

  def caveats
    <<~EOS
      One command sets the rest up:
        minitart doctor --fix

      It installs Tart and Softnet from their tap if they are missing, and does
      the parts that need your password. `minitart doctor` alone only looks.
      The whole setup, step by step: #{opt_pkgshare}/docs/setup.md

      To upgrade, run `minitart upgrade` rather than `brew upgrade`: it waits
      for running jobs, and puts Softnet's permission back afterwards.
    EOS
  end

  service do
    run [opt_bin/"minitart", "start"]
    keep_alive true
    environment_variables PATH: std_service_path_env
    log_path var/"log/minitart.log"
    error_log_path var/"log/minitart.log"
  end

  test do
    assert_equal "minitart #{version}", shell_output("#{bin}/minitart --version").strip
    assert_match "minitart upgrade", shell_output("#{bin}/minitart --help")
    assert_path_exists libexec/"firewall/install.sh"
    refute_path_exists testpath/".minitart"
  end
end
