//
//  Day11.swift
//  AoC2025
//

import Foundation

class Day11: AoCSolution {
	override init() {
		super.init()
		day = 11
		self.name = "Reactor"
		self.emptyLinesIndicateMultipleInputs = true
	}
	
	override func solve(_ input: AoCInput) -> AoCResult {
		super.solve(input)
		
		let devices1 = parseDevices(input: input.textLines)
		let p1 = solvePartOne(devices1)
		
//		let devices2 = parseDevices(input: input.allInputGroups[1])
		let devices2 = parseDevices(input: input.textLines)
		let p2 = solvePartTwo(devices2)
		
		return AoCResult(part1: "The number of paths is \(p1)", part2: "The number of paths is \(p2)")
	}
	
	func solvePartOne(_ devices: Dictionary<String, Device>) -> Int {
		var cache = Dictionary<String, Int>()
		return countRoutes(from: devices["you"]!, to: "out", in: devices, with: &cache)
	}
	
	func solvePartTwo(_ devices: Dictionary<String, Device>) -> Int {
		var cache = Dictionary<String, Int>()
		
		cache = Dictionary<String, Int>()
		let dacToFft = countRoutes(from: devices["dac"]!, to: "fft", in: devices, with: &cache)
		
		var count = 0
		if dacToFft > 0 {
			// svr --> dac --> fft --> out
			cache = Dictionary<String, Int>()
			let svrToDac = countRoutes(from: devices["svr"]!, to: "dac", in: devices, with: &cache)
			cache = Dictionary<String, Int>()
			let fftToOut = countRoutes(from: devices["fft"]!, to: "out", in: devices, with: &cache)
			count = svrToDac * dacToFft * fftToOut
		}
		else {
			// svr --> fft --> dac --> out
			cache = Dictionary<String, Int>()
			let svrToFft = countRoutes(from: devices["svr"]!, to: "fft", in: devices, with: &cache)
			cache = Dictionary<String, Int>()
			let fftToDac = countRoutes(from: devices["fft"]!, to: "dac", in: devices, with: &cache)
			cache = Dictionary<String, Int>()
			let dacToOut = countRoutes(from: devices["dac"]!, to: "out", in: devices, with: &cache)
			count = svrToFft * fftToDac * dacToOut
		}

		return count
	}
	
	func countRoutes(from device: Device,
					 to label:String,
					 in devices: Dictionary<String, Device>,
					 with cache: inout Dictionary<String, Int>) -> Int {
		if let cacheHit = cache[device.id] {
			return cacheHit
		}
		if device.id == label { return 1 }
		
		var count = 0
		for output in device.outputs {
			count += countRoutes(from: devices[output]!, to: label, in: devices, with: &cache)
		}
		
		cache[device.id] = count
		return count
	}
	
	func parseDevices(input: [String]) -> Dictionary<String, Device> {
		let devices = input.map { line in
			let parts = line.split(separator: ": ")
			let label = String(parts[0])
			let outputs = parts[1].split(separator: " ").map { String($0) }
			return Device(id: label, outputs: Set(outputs))
		}
		var result = Dictionary(uniqueKeysWithValues: devices.map { ($0.id, $0) })
		result["out"] = Device(id: "out", outputs: [])
		return result
	}
}

struct Device {
	let id: String
	let outputs: Set<String>
}
