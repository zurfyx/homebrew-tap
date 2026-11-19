cask "minitart-app" do
  version "0.1.0"
  sha256 "e096f7e3ff724418d1b475719d0621ab86b09876c0aad79381a6bfa74915f2cb"

  url "https://github.com/zurfyx/minitart/releases/download/app-v#{version}/minitart-app-#{version}.zip"
  name "minitart"
  desc "Menu bar companion for minitart, GitHub Actions runners in Tart VMs"
  homepage "https://minitart.rovira.sh/"

  depends_on arch: :arm64
  # One install sets up both: the app watches the minitart on this Mac.
  depends_on formula: "zurfyx/tap/minitart"
  depends_on macos: :sonoma

  app "minitart.app"

  uninstall quit: "sh.rovira.minitart.app"

  zap trash: "~/Library/Preferences/sh.rovira.minitart.app.plist"
end
