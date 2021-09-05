import ArgumentParser
import Foundation
import Rainbow
import SimplyCoreAudio
import TextTable

struct SystemAudioCommand: ParsableCommand {
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

	mutating func run() throws {
		let devices = devices(isInput: input, isOutput: output)
		var targetDevice: AudioDevice?

		if uid != nil {
			targetDevice = devices.first(where: { $0.uid == uid })!
		}

		if name != nil {
			targetDevice = devices.first(where: { $0.name == name })!
		}

		if targetDevice != nil {
			setDefaultDevice(device: targetDevice!, isInput: input, isOutput: output)
			return
		}

		if alfred {
			try AlfredFormatter(devices: devices).output()
		} else {
			ConsoleFormatter(devices: devices).output()
		}
	}

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
		let simplyCA = SimplyCoreAudio()

		if input {
			return simplyCA.allInputDevices
		} else if output {
			return simplyCA.allOutputDevices
		} else {
			return []
		}
	}
}

class AlfredFormatter {
	var devices = [AudioDevice]()

	init(devices: [AudioDevice]) {
		self.devices = devices
	}

	func output() throws {
		try print(toString())
	}

	func toString() throws -> String {
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
		return jsonString
	}
}

class ConsoleFormatter {
	var devices = [AudioDevice]()

	init(devices: [AudioDevice]) {
		self.devices = devices
	}

	func output() {
		let table = TextTable<AudioDevice> {
			let isOutput = $0.channels(scope: .output) > 0
			let isInput = $0.channels(scope: .input) > 0
			let isDefaultDevice = (isOutput && $0.isDefaultOutputDevice) || (isInput && $0.isDefaultInputDevice)
			return [
				Column("NAME" <- $0.name),
				Column("UID" <- $0.uid!),
				Column("DEFAULT" <- isDefaultDevice ? "Current" : ""),
			]
		}
		table.print(devices, style: Style.org)
	}
}



SystemAudioCommand.main()
