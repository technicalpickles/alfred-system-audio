import ArgumentParser
import SimplyCoreAudio

let simplyCA = SimplyCoreAudio()

struct SystemAudio: ParsableCommand {
	@Flag(name: .shortAndLong, help: "Input devices")
	var input = false

	@Flag(name: .shortAndLong, help: "Output devices")
	var output = false

	mutating func run() throws {
		print("<?xml version='1.0'?>")
		print("<items>")
		var devices: [AudioDevice]

		if input {
			devices = simplyCA.allInputDevices
		} else if output {
			devices = simplyCA.allOutputDevices
		} else {
			devices = []
		}

		for device in devices {
			let name = device.name
			let isOutput = device.channels(scope: .output) > 0
			let isInput = device.channels(scope: .input) > 0

			// 			set deviceselected to the value of text field 1 of row i of table 1 of scroll area 1 of tab group 1 of window 1
 			///			set deviceselectedXML to deviceselectedXML & "<item uid='" & deviceselected & "' arg='" & deviceselected & "' valid='YES' autocomplete='" & deviceselected & "'><title>" & deviceselected & "</title>"

			if name != nil {
				let display = device.name
				print("  <item uid='\(display)' arg='\(display)' valid='YES' autocomplete='\(display)'>")
				print("    <title>\(display)</title>")

				// add output/input to display
				if isOutput {
					print("  <icon>output.png</icon>")
					if device.isDefaultOutputDevice {
						print("  <subtitle> Currently selected </subtitle>")
					}
				}

				if isInput {
					print("  <icon>input.png</icon>")
					if device.isDefaultInputDevice {
						print("  <subtitle> Currently selected </subtitle>")
					}
				}

				print("  </item>")
			}
		}
		print("<items>")
	}
}

SystemAudio.main()
