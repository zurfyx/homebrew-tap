cask "minitart-app" do
  version "0.1.1"
  sha256 "ce6b250e1ebc9f0d5f0be2dd081e34f92efbdcdecb137351d574a1ecd17da875"

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
