# Alfred System Audio Workflow

Quickly change between different audio inputs and outputs using [Alfred](http://www.alfredapp.com).

## Installation

Go to [Releases](https://github.com/technicalpickles/alfred-system-audio/releases), and download `systemaudio.alfredworkflow` from the latest release. Open it from Finder to install.

## Development

This is macOS only. You will need Xcode and the command line tools installed.

Run `./dev.sh` to create a flattened, uncompressed workflow, and install it. You can then make changes to the info.plist to see the changes live.

Run `./build.sh` to create the compressed `systemaudio.alfredworkflow` for testing it installs cleanly.
## Inspiration

[Audio Switch](https://github.com/sampayo/Alfred-WorkFlows/tree/master/Audio%20Switch) workflow by [@sampayo](https://github.com/sampayo) was what I was using before I wrote this. I've re-used the icons from it until I can find better ones.