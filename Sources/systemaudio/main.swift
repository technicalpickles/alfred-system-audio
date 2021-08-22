import ArgumentParser
import SimplyCoreAudio
import Foundation

let simplyCA = SimplyCoreAudio()

struct SystemAudio: ParsableCommand {
	@Flag(name: .shortAndLong, help: "Input devices")
	var input = false

	@Flag(name: .shortAndLong, help: "Output devices")
	var output = false

	@Argument(help: "the device to use for new input or output")
	var deviceUid : String?


	mutating func run() throws {
		var devices: [AudioDevice]

		if input {
			devices = simplyCA.allInputDevices
		} else if output {
			devices = simplyCA.allOutputDevices
		} else {
			devices = []
		}

		if deviceUid != nil {
			let device = devices.first(where: { $0.uid == deviceUid })
			if input {
				device?.isDefaultInputDevice = true
				print(device!.name)
			} else if output {
				device?.isDefaultOutputDevice = true
				print(device!.name)
			} else {
				print("confusion!")
			}
			return
		}

		var response: [String : [Any]] = [:]
		var items = [Any]()

		for device in devices {
			let isOutput = device.channels(scope: .output) > 0
			let isInput = device.channels(scope: .input) > 0

			var item: [String: Any] = [:]
			item["title"] = device.name
			item["uid"] = device.uid
			item["arg"] = device.uid
			item["autocomplete"] = device.name

			// add output/input to display
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

			items.append(item)
		}
		response["items"] = items

		let jsonData = try JSONSerialization.data(withJSONObject: response, options: [])
		let jsonString = String(data: jsonData, encoding: String.Encoding.ascii)!
		print(jsonString)
	}
}

SystemAudio.main()
