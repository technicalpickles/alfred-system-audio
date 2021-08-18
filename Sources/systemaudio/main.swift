import ArgumentParser
import SimplyCoreAudio

let simplyCA = SimplyCoreAudio()

struct SystemAudio: ParsableCommand {
		@Flag(name: .shortAndLong, help: "Input devices")
		var input = false

		@Flag(name: .shortAndLong, help: "Output devices")
		var output = false

    mutating func run() throws {
			var devices : [AudioDevice]

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


				if name != nil {
					var display = "device: \(name)"

					// add output/input to display
					if isOutput {
						display += " (output)"
						if device.isDefaultOutputDevice {
							display += " (default)"
						}
					}

					if isInput {
						display += " (input)"
						if device.isDefaultInputDevice {
							display += " (default)"
						}
					}

					print(display)
				}
			}
    }
}

SystemAudio.main()