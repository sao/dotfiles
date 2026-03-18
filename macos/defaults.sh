#!/usr/bin/env zsh
#
# macos/defaults.sh
# Apply sensible macOS system preferences.
# Requires logout / restart for some to take effect.
#

echo "  Applying macOS defaults..."

# ── Finder ────────────────────────────────────────────────────────────────────
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder AppleShowAllFiles -bool true           # show hidden files
defaults write NSGlobalDomain AppleShowAllExtensions -bool true        # show all extensions
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"   # search current folder by default
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# ── Dock ──────────────────────────────────────────────────────────────────────
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock tilesize -int 48

# ── Screenshots ───────────────────────────────────────────────────────────────
defaults write com.apple.screencapture location -string "$HOME/Desktop"
defaults write com.apple.screencapture type -string "png"
defaults write com.apple.screencapture disable-shadow -bool true

# ── Keyboard ──────────────────────────────────────────────────────────────────
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false     # enable key repeat

# ── Trackpad ──────────────────────────────────────────────────────────────────
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1       # tap to click

# ── Activity Monitor ──────────────────────────────────────────────────────────
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true
defaults write com.apple.ActivityMonitor ShowCategory -int 0           # show all processes

# ── Misc ──────────────────────────────────────────────────────────────────────
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write com.apple.LaunchServices LSQuarantine -bool false       # disable "app downloaded from internet" warning

# Restart affected apps
for app in Finder Dock SystemUIServer; do
  killall "$app" &>/dev/null || true
done

echo "  ✓ macOS defaults applied"
