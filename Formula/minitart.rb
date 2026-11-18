class Minitart < Formula
  desc "GitHub Actions runners on your own Mac, every job in a fresh Tart VM"
  homepage "https://minitart.rovira.sh"
  url "https://github.com/zurfyx/minitart/releases/download/v0.1.1/minitart-0.1.1.tar.gz"
  version "0.1.1"
  sha256 "0698a0b5750915b2c343c28a4c48f62e409e0062a4df2ec9f094ee99bc3271ee"
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
      minitart drives Tart and Softnet, which come from their own tap:
        brew install openai/tools/tart openai/tools/softnet
        brew pin softnet

      Then `minitart doctor` says what is left to set up, and
      `minitart doctor --fix` does the parts that need your password.
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
