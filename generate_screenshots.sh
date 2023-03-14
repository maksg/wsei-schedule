#!/bin/sh

#  generate_screenshots.sh
#  WSEISchedule
#
#  Created by Maksymilian Galas on 21/01/2021.
#  Copyright © 2021 Infinity Pi Ltd. All rights reserved.

# The Xcode project to create screenshots for
projectName="./WSEISchedule.xcodeproj"

# The scheme to run tests for
schemeName="WSEI Schedule Mock"


# All the simulators we want to screenshot
# Copy/Paste new names from Xcode's
# "Devices and Simulators" window
# or from `xcrun simctl list`.
simulators=(
    "iPhone 8 Plus"
    "iPhone 12 Pro Max"
    "iPad Pro (12.9-inch) (2nd generation)"
    "iPad Pro (12.9-inch) (6th generation)"
    "iPhone 14 Pro Max"
)

# All the languages we want to screenshot (ISO 3166-1 codes)
languages=(
    "en"
    "pl"
)

# All the appearances we want to screenshot
# (options are "light" and "dark")
appearances=(
    "light"
    "dark"
)

# Save final screenshots into this folder (it will be created)
targetFolder="Screenshots"


## Start screenshot taking

# macOS
defaults write com.apple.finder CreateDesktop false
killall Finder

for appearance in "${appearances[@]}"
do
    for language in "${languages[@]}"
    do
        rm -rf /tmp/WSEIScheduleDerivedData/Logs/Test
        echo "📲  Building and Running for Mac in $language"

        # Set the correct appearance
        [[ $appearance == "dark" ]] && darkMode="true" || darkMode="false"
        osascript -e "tell app \"System Events\" to tell appearance preferences to set dark mode to $darkMode"
        sudo date 0941

        # Build and Test
        xcodebuild -testLanguage $language -scheme "$schemeName" -project $projectName -derivedDataPath "/tmp/WSEIScheduleDerivedData/" -destination "platform=macOS,variant=Mac Catalyst,arch=arm64" build test
        echo "🖼  Collecting Results..."
        mkdir -p "$targetFolder/macOS/$language/$appearance"
        find /tmp/WSEIScheduleDerivedData/Logs/Test/*.xcresult -maxdepth 0 -type d -exec xcparse screenshots {} "$targetFolder/macOS/$language/$appearance" \;
    done
done

defaults write com.apple.finder CreateDesktop true
killall Finder

sudo sntp -sS time.apple.com

echo "✅  Done"


# iOS
for simulator in "${simulators[@]}"
do
    for appearance in "${appearances[@]}"
    do
        for language in "${languages[@]}"
        do
            rm -rf /tmp/WSEIScheduleDerivedData/Logs/Test
            echo "📲  Building and Running for $simulator in $language"

            # Boot up the new simulator and set it to
            # the correct appearance
            xcrun simctl boot "$simulator"
            xcrun simctl ui "$simulator" appearance $appearance
            xcrun simctl status_bar "$simulator" override --time "9:41" --batteryState charged --batteryLevel 100

            # Build and Test
            xcodebuild -testLanguage $language -scheme "$schemeName" -project $projectName -derivedDataPath "/tmp/WSEIScheduleDerivedData/" -destination "platform=iOS Simulator,name=$simulator" build test
            echo "🖼  Collecting Results..."
            mkdir -p "$targetFolder/$simulator/$language/$appearance"
            find /tmp/WSEIScheduleDerivedData/Logs/Test/*.xcresult -maxdepth 0 -type d -exec xcparse screenshots {} "$targetFolder/$simulator/$language/$appearance" \;
        done
    done

    echo "✅  Done"
done
