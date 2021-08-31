import ArgumentParser
import Foundation
import Rainbow
import SimplyCoreAudio

let simplyCA = SimplyCoreAudio()

struct SystemAudio: ParsableCommand {
	@Flag(name: .shortAndLong, help: "Input devices")
	var input = false

	@Flag(name: .shortAndLong, help: "Output devices")
	var output = false

	@Option(name: .shortAndLong, help: "the UID of device to use for new input or output")
	var uid: String?

	@Option(name: .shortAndLong, help: "the name of device to use for new input or output")
	var name: String?

	@Flag(name: .shortAndLong, help: "Generate output to be parsed by Alfred Script Filter")
	var alfred: Bool = false

	func setDefaultDevice(device: AudioDevice, isInput: Bool, isOutput: Bool) {
		if isInput {
			device.isDefaultInputDevice = true
			print(device.name)
		} else if isOutput {
			device.isDefaultOutputDevice = true
			print(device.name)
		} else {
			print("confusion!")
		}
	}

	func devices(isInput _: Bool, isOutput _: Bool) -> [AudioDevice] {
		if input {
			return simplyCA.allInputDevices
		} else if output {
			return simplyCA.allOutputDevices
		} else {
			return []
		}
	}

	mutating func run() throws {
		let devices = devices(isInput: input, isOutput: output)
		var device: AudioDevice?

		if uid != nil {
			device = devices.first(where: { $0.uid == uid })!
		}

		if name != nil {
			device = devices.first(where: { $0.name == name })!
		}

		if device != nil {
			setDefaultDevice(device: device!, isInput: input, isOutput: output)
			return
		}

		if alfred {
			// see https://www.alfredapp.com/help/workflows/inputs/script-filter/json/ for spec of alfred output
			var response: [String: [Any]] = [:]

			response["items"] = devices.map { device -> Any in
				let isOutput = device.channels(scope: .output) > 0
				let isInput = device.channels(scope: .input) > 0

				var item: [String: Any] = [
					"title": device.name,
					"uid": device.uid!,
					"arg": device.uid!,
					"autocomplete": device.name,
				]

				if isOutput {
					item["icon"] = ["path": "output.png"]
					if device.isDefaultOutputDevice {
						item["subtitle"] = "Currently selected"
					}
				}

				if isInput {
					item["icon"] = ["path": "input.png"]
					if device.isDefaultInputDevice {
						item["subtitle"] = "Currently selected"
					}
				}

				return item
			}

			let jsonData = try JSONSerialization.data(withJSONObject: response, options: [])
			let jsonString = String(data: jsonData, encoding: String.Encoding.ascii)!
			print(jsonString)
		} else {
			for device in devices {
				var outputString = "\(device.name)"

				let isOutput = device.channels(scope: .output) > 0
				let isInput = device.channels(scope: .input) > 0

				if (isOutput && device.isDefaultOutputDevice) || (isInput && device.isDefaultInputDevice) {
					outputString.append(" (current)".bold)
				}

				print(outputString)
			}
		}
	}
}

SystemAudio.main()
