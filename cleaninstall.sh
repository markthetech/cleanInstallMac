#!/bin/bash

# Clean Install Script for Mac afer re-install.
# Check if running as root.
if [ $(id -u) = 0 ]; then
   echo "This script cannot be run with sudo or as root. Re-run without sudo"
   exit 1
fi

# Change Hostname
echo "Please type in the name you want your computer to be called: /n"
read newName
sudo scutil --set ComputerName $newName
sudo scutil --set HostName $newName
sudo scutil --set LocalHostName $newName
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string $newName

# Homebrew fixes
sudo chown -R "$USER":admin /usr/local

# Installs CommandLine Tools silently using other script in folder
sudo ./installCommandlineTool.sh

# Install Homebrew
echo "Installing homebrew"
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew update --fetch-HEAD

# Homebrew tools and apps install
echo "Installing cask/caskroom"
brew update
brew install cask
brew tap caskroom/cask

# Tool installs
brew install python3
brew install git
brew install wget
brew install speedtest-cli

# Application installs
brew cask install 1password
brew cask install appcleaner
brew cask install atom
brew cask install balenaetcher
brew cask install bartender
brew cask install disk-inventory-x
brew cask install diskmaker-x
brew cask install fantastical
brew cask install firefox
brew cask install impactor
brew cask install iterm2
brew cask install kap
brew cask install karabiner-elements
brew cask install keka
brew cask install nextcloud
brew cask install nordvpn
brew cask install onyx
brew cask install pocket-casts
brew cask install screens
brew cask install slack
brew cask install stay
brew cask install superduper
brew cask install steam
brew cask install suspicious-package
brew cask install torbrowser
brew cask install tunnelblick
brew cask install tuxera-ntfs
brew cask install transmission
brew cask install transmit
brew cask install unetbootin
brew cask install vlc
brew cask install vmware-fusion
brew cask install microsoft-office

# Quit System Preferences so that the script's changes can't be overwritten
osascript -e 'tell application "System Preferences" to quit'

# System Wide Changes/Preferences

# Turn off the sound at boot so it's less awkward during class
sudo nvram SystemAudioVolume=" "

# Show the full save panel everytime
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Show the full print panel everytime
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Save to my computer instead of iCloud everytime
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Quit the printer everytime it finishes printing
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Turn off the “Are you sure you want to open this application?” when opening apps
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Stop duplicates from appearing in "Open With"
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user

# Disable the sudden motion sensor. Usually only needed for HDDs
sudo pmset -a sms 0

# Enabe tap to click for current user
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Switch to the correct scrolling style not "Natural/inverted"
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# Better sound quality with bluetooth headphones
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Save screenshots to the desktop
defaults write com.apple.screencapture location -string "${HOME}/Desktop"

# Save screenshots as PNG
defaults write com.apple.screencapture type -string "png"

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

# Fix blury text in Mojave on non-retina screens
defaults write -g CGFontRenderingFontSmoothingDisabled -bool NO
defaults write NSGlobalDomain AppleFontSmoothing -int 3

# Set Desktop as the default location for new Finder windows
defaults write com.apple.finder NewWindowTarget -string "PfDe"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Desktop/"

# Show icons for external disks, internal disks, and other drives connected on the Desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Show full file path in Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# When searching search the current folder not whole computer
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# No .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Disable disk image verification because it's unproductive
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

# Show item info near icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist

# Disable the warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Show the ~/Library folder
chflags nohidden ~/Library

# Show the /Volumes folder
sudo chflags nohidden /Volumes

# Disable Dashboard because it should be gone anyways
defaults write com.apple.dashboard mcx-disabled -bool true

# Don’t show Dashboard as a Space again because it shouldn't be there
defaults write com.apple.dock dashboard-in-overlay -bool true

# Don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

#turn off IPV6
sudo networksetup -setv6off Wi-Fi
sudo networksetup -setv6off Ethernet

# Privacy: don’t send search queries to Apple via Safari
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true

# Show the full URL in the address bar
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

# Set Safari’s home page to `about:blank` for faster loading
defaults write com.apple.Safari HomePage -string "about:blank"

# Prevent Safari from opening ‘safe’ files automatically after downloading
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

# Enable Safari’s debug menu
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

# Enable the Develop menu and the Web Inspector in Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

# Add a context menu item for showing the Web Inspector in web views
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

# Enable continuous spellchecking
defaults write com.apple.Safari WebContinuousSpellCheckingEnabled -bool true

# Enable “Do Not Track”
defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true

# Update extensions automatically
defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true

# Disable send and reply animations in Mail.app
defaults write com.apple.mail DisableReplyAnimations -bool true
defaults write com.apple.mail DisableSendAnimations -bool true

# Copy email addresses as `foo@example.com` instead of `Foo Bar <foo@example.com>` in Mail.app
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

# Disable inline attachments (just show the icons)
defaults write com.apple.mail DisableInlineAttachmentViewing -bool true

# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Disable local Time Machine backups
hash tmutil &> /dev/null && sudo tmutil disablelocal

# import terminal settings and color scheme
open custom.terminal

# make the new terminal import default
sudo -u $USER defaults write /Users/$USER/Library/Preferences/com.apple.Terminal.plist "Default Window Settings" "a1p1n3"
sudo -u $USER defaults write /Users/$USER/Library/Preferences/com.apple.Terminal.plist "Startup Window Settings" "a1p1n3"

# Show the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# Show CPU usage on dock icon
defaults write com.apple.ActivityMonitor IconType -int 5

# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Sort Activity Monitor results by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

# Enable the automatic update check
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

# Check for software updates daily, not just once per week
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Download newly available updates in background
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

# Install System data files & security updates
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

# Turn on app auto-update
defaults write com.apple.commerce AutoUpdate -bool true

# Prevent Photos from opening automatically when devices are plugged in
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

# Use `~/Torrents` to store incomplete downloads in Transmission
defaults write org.m0k.transmission UseIncompleteDownloadFolder -bool true
mkdir ~/Torrents
defaults write org.m0k.transmission IncompleteDownloadFolder -string "${HOME}/Torrents"

# Don’t prompt for confirmation before downloading Torrents
defaults write org.m0k.transmission DownloadAsk -bool false
defaults write org.m0k.transmission MagnetOpenAsk -bool false

# Trash original torrent files
defaults write org.m0k.transmission DeleteOriginalTorrent -bool true

# Hide the donate message
defaults write org.m0k.transmission WarningDonate -bool false
# Hide the legal disclaimer
defaults write org.m0k.transmission WarningLegal -bool false

# IP block list for Transmission
# Source: https://giuliomac.wordpress.com/2014/02/19/best-blocklist-for-transmission/
defaults write org.m0k.transmission BlocklistNew -bool true
defaults write org.m0k.transmission BlocklistURL -string "http://john.bitsurge.net/public/biglist.p2p.gz"
defaults write org.m0k.transmission BlocklistAutoUpdate -bool true

# Fix Gatekeeper
sudo spctl --master-disable

# Kill apps and reboot
for app in "Activity Monitor" "cfprefsd" \
	"Dock" "Finder" "Mail" "Messages" \ "Photos" "Safari" "SystemUIServer" \
	"Transmission"; do
	killall "${app}" &> /dev/null
done
echo "Done. Note that some of these changes require a logout/restart to take effect."
osascript -e 'tell app "loginwindow" to «event aevtrrst»'
