#!/bin/bash
set -xe
swift build

mkdir -p dev

cd dev
ln -sf ../alfred/* ./
ln -sf ../.build/x86_64-apple-macosx/debug/systemaudio .

prefs=~/Library/Preferences/com.runningwithcrayons.Alfred-Preferences.plist
syncfolder=$(/usr/libexec/PlistBuddy -c "print :syncfolder" $prefs 2>/dev/null || echo)
if [ -z "$syncfolder" ]; then
  syncfolder=~/Library/Application\ Support/Alfred
fi

workflows=$syncfolder/Alfred.alfredpreferences/workflows
workflows=${workflows/\~/$HOME} # expand ~/

if [ -d "$workflows" ]; then
  echo "symlinking $(pwd) into $workflows"
  ln -sf "$(pwd)" "$workflows/systemaudio"
else
  echo "Could not find workflows folder: $workflows"
  exit 1
fi