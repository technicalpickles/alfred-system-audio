import ArgumentParser
import SimplyCoreAudio

let simplyCA = SimplyCoreAudio()

struct SystemAudio: ParsableCommand {
	@Flag(name: .shortAndLong, help: "Input devices")
	var input = false

	@Flag(name: .shortAndLong, help: "Output devices")
	var output = false

	@Argument(help: "the device to use for new input or output")
	var deviceName : String?


	mutating func run() throws {
		var devices: [AudioDevice]

		if input {
			devices = simplyCA.allInputDevices
		} else if output {
			devices = simplyCA.allOutputDevices
		} else {
			devices = []
		}

		if deviceName != nil {
			let device = devices.first(where: { $0.name == deviceName })
			if input {
				device?.isDefaultInputDevice = true
				print(deviceName!)
			} else if output {
				device?.isDefaultOutputDevice = true
				print(deviceName!)
			} else {
				print("confusion!")
			}
			return
		}

		print("<?xml version='1.0'?>")
		print("<items>")

		for device in devices {
			let isOutput = device.channels(scope: .output) > 0
			let isInput = device.channels(scope: .input) > 0

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
		print("<items>")
	}
}

SystemAudio.main()
