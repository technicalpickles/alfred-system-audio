import SimplyCoreAudio

print("initializing SimplyCoreAudio")
let simplyCA = SimplyCoreAudio()
print("getting default output device")

for device in simplyCA.allDevices {
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