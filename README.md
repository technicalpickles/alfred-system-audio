# Alfred System Audio Workflow

Quickly change between different audio inputs and outputs using [Alfred](http://www.alfredapp.com).

https://user-images.githubusercontent.com/159/130151282-d1d4d219-bd45-46ba-abf8-dc6f9fd16492.mp4

https://user-images.githubusercontent.com/159/130151292-b7f65776-7989-43f9-a6d8-6b82a5726a51.mp4

## Installation

Go to [Releases](https://github.com/technicalpickles/alfred-system-audio/releases), and download `systemaudio.alfredworkflow` from the latest release. Open it from Finder to install.

## Development

This is macOS only. You will need Xcode and the command line tools installed.

Run `./dev.sh` to create a flattened, uncompressed workflow, and install it. You can then make changes to the workflow in Alfred, and have it update the info.plist to see your changes.

Run `./build.sh` to create the compressed `systemaudio.alfredworkflow` for testing it installs cleanly.

## Credits and Inpsiration

[Audio Switch](https://github.com/sampayo/Alfred-WorkFlows/tree/master/Audio%20Switch) workflow by [@sampayo](https://github.com/sampayo) was what I was using before I wrote this. I've re-used some of the icons from it until I can find better ones.

[Soundwave icon](https://thenounproject.com/term/waveform/1786357/) by Maxim Kulikov from the Noun Project.
