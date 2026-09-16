//
//  AoCGrid2D.swift
//  AoC 2025
//
//  Created by Simon Biickert on 2023-11-27.
//

import Foundation

class AoCGrid2D {
	let defaultValue: String
	private var _data = Dictionary<AoCCoord2D, Any>()
	private var _adjacencyRule: AoCAdjacencyRule = .rook
	private var _extent: AoCExtent2D?
	var isTiledInfinitely: Bool = false

	init(defaultValue: String = ".", rule: AoCAdjacencyRule = .rook) {
		self.defaultValue = defaultValue
		_adjacencyRule = rule
		_extent = nil
	}
	
	func load(data: [String]) {
		for row in 0..<data.count {
			for col in 0..<data[row].count {
				let s = String(data[row][col])
				if s != defaultValue {
					self.setValue(s, at: AoCCoord2D(x: col, y: row))
				}
			}
		}
		// Default-valued cells are not stored, but the extent still has to
		// describe the whole input: otherwise a default-valued row or column at
		// the edge of the input would fall outside the grid.
		let width = data.map { $0.count }.max() ?? 0
		if width > 0 {
			expandExtent(toFit: AoCCoord2D(x: 0, y: 0))
			expandExtent(toFit: AoCCoord2D(x: width - 1, y: data.count - 1))
		}
	}

	var rule: AoCAdjacencyRule {
		return _adjacencyRule
	}
	
	var extent: AoCExtent2D? {
		return _extent
	}

	func stringValue(at coord: AoCCoord2D) -> String {
		let val = value(at: coord)
		return AoCGrid2D.transformToString(value: val)
	}
	
	private static func transformToString(value: Any) -> String {
		if let str = value as? String {
			return str
		}
		else if let renderable = value as? AoCGridRenderable {
			return renderable.glyph
		}
		return "\(value)"
		
	}
	
	func value(at coord: AoCCoord2D) -> Any {
		var c = coord
		if isTiledInfinitely, let ext = extent, ext.contains(coord) == false {
			// This coord is outside the bounds of the grid. What would a tiled copy of the grid return?
			// Wrapping is relative to the extent's own origin, so tiling also
			// works for grids that do not start at [0,0].
			c = AoCCoord2D(x: ext.min.x + AoCUtil.trueMod(num: coord.x - ext.min.x, mod: ext.width),
						   y: ext.min.y + AoCUtil.trueMod(num: coord.y - ext.min.y, mod: ext.height))
		}
		if let v = _data[c] {
			return v
		}
		return defaultValue
	}

	func setValue(_ v: Any, at coord: AoCCoord2D) {
		_data[coord] = v
		expandExtent(toFit: coord)
	}

	private func expandExtent(toFit coord: AoCCoord2D) {
		if let ext = _extent {
			_extent = ext.expanded(toFit: coord)
		}
		else {
			_extent = AoCExtent2D(min: coord, max: coord)
		}
	}

	/// Flood-fills the region containing `point`, returning true if the region
	/// leaks outside the extent (in which case every painted cell is rolled back).
	func fill(with value:String, at point:AoCCoord2D, filled: inout [AoCCoord2D]) -> Bool {
		guard let ext = extent, ext.contains(point) else {
			return true
		}
		// Neighbour lists are captured before recursing, so the same cell can be
		// reached twice; bail out if this branch already painted it.
		if stringValue(at: point) == value {
			return false
		}
		var touchedInfinity = false
		setValue(value, at: point)
		filled.append(point)
		let neighbours = neighbourCoords(at: point, withValue: defaultValue)
		for neighbour in neighbours {
			touchedInfinity = touchedInfinity || fill(with: value, at: neighbour, filled: &filled)
		}
		if touchedInfinity {
			for filledPoint in filled {
				clear(at: filledPoint)
			}
		}
		return touchedInfinity
	}

	func clear(at coord: AoCCoord2D, resetExtent: Bool = false) {
		_data.removeValue(forKey: coord)
		if (resetExtent) {
			_extent = AoCExtent2D.build(from: coords)
		}
	}
	
	var coords: [AoCCoord2D] {
		return Array(_data.keys)
	}
	
	var values: [Any] {
		return Array(_data.values)
	}
	
	func getCoords(withValue v: String) -> [AoCCoord2D] {
		let result = _data.filter {
			let str = AoCGrid2D.transformToString(value: $0.value)
			return str == v
		}
		return Array(result.keys)
	}
	
	var histogram: Dictionary<String, Int> {
		var result = Dictionary<String, Int>()
		if let ext = extent {
			for row in ext.min.y...ext.max.y {
				for col in ext.min.x...ext.max.x {
					let v = stringValue(at: AoCCoord2D(x: col, y: row))
					if result.keys.contains(v) == false { result[v] = 0 }
					result[v]! += 1
				}
			}
		}
		return result
	}
	
	var neighbourOffsets: [AoCCoord2D] {
		return AoCCoord2D.getAdjacentOffsets(rule: self.rule)
	}
	
	func neighbourCoords(at coord: AoCCoord2D) -> [AoCCoord2D] {
		return coord.getAdjacentCoords(rule: self.rule)
	}
	
	func neighbourCoords(at coord: AoCCoord2D, withValue s: String) -> [AoCCoord2D] {
		var result = neighbourCoords(at: coord)
		result = result.filter { self.stringValue(at: $0) == s }
		return result
	}
	
	func toString(markers: Dictionary<AoCCoord2D, String>? = nil, drawExtent: AoCExtent2D? = nil) -> String {
		var str = ""
		if var ext = extent {
			
			if isTiledInfinitely && drawExtent != nil { ext = drawExtent! }
			
			for row in ext.min.y...ext.max.y {
				var values = [String]()
				for col in ext.min.x...ext.max.x {
					let coord = AoCCoord2D(x: col, y: row)
					if let markers = markers,
					   markers.keys.contains(coord) {
						values.append(markers[coord]!)
					}
					else {
						values.append(stringValue(at: coord))
					}
				}
				str.append(values.joined(separator: " "))
				str.append("\n")
			}
		}
		return str
	}
	
	func draw(markers: Dictionary<AoCCoord2D, String>? = nil, drawExtent: AoCExtent2D? = nil) {
		print(self.toString(markers: markers, drawExtent: drawExtent))
	}
}

protocol AoCGridRenderable {
	var glyph: String {get}
}
	
