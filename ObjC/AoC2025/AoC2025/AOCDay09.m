//
//  AOCDay09.m
//  AoC2025
//

#import <Foundation/Foundation.h>
#import "AOCDay.h"
#import "AOCSpatial.h"
#import "AOCStrings.h"
#import "AOCGrid.h"

@interface AOCCompressionMap : NSObject

- (AOCCompressionMap *)init:(NSArray<AOCCoord *> *)coords;
- (AOCCoord *)expand:(AOCCoord *)coord;
- (AOCCoord *)compress:(AOCCoord *)coord;

@property (readonly) NSDictionary<NSNumber *, NSNumber *> *compressionMapX;
@property (readonly) NSDictionary<NSNumber *, NSNumber *> *expansionMapX;
@property (readonly) NSDictionary<NSNumber *, NSNumber *> *compressionMapY;
@property (readonly) NSDictionary<NSNumber *, NSNumber *> *expansionMapY;

@end

@implementation AOCDay09

- (AOCDay09 *)init {
	self = [super initWithDay:9 name:@"Movie Theater"];
	return self;
}

- (struct AOCResult)solveInputIndex:(int)index inFile:(NSString *)filename {
	struct AOCResult result = [super solveInputIndex:index inFile:filename];
	
	NSArray<NSString *> *input = [AOCInput readGroupedInputFile:filename atIndex:index];
	
	NSArray<AOCCoord *> *coords = [self parseCoords:input];
	
	result.part1 = [self solvePartOne: coords];
	result.part2 = [self solvePartTwo: coords];
	
	return result;
}

- (NSString *)solvePartOne:(NSArray<AOCCoord *> *)coords {
	NSInteger maxArea = 0;
	
	for (NSInteger i = 0; i < coords.count-1; i++) {
		for (NSInteger j = i + 1; j < coords.count; j++) {
			NSInteger area = (labs(coords[i].x - coords[j].x) + 1) *
							 (labs(coords[i].y - coords[j].y) + 1);
			
			if (area > maxArea) { maxArea = area; }
		}
	}
	
	return [NSString stringWithFormat: @"The largest area is %ld", (long)maxArea];
}

- (NSString *)solvePartTwo:(NSArray<AOCCoord *> *)coords {
	AOCCompressionMap *cMap = [[AOCCompressionMap alloc] init:coords];
	NSMutableArray<AOCCoord *> *compCoords = [NSMutableArray array];
	
	for (AOCCoord *c in coords) {
		[compCoords addObject:[cMap compress:c]];
	}
	
	AOCGrid *grid = [self paintGrid:compCoords];

	NSInteger maxArea = 0;

	for (NSInteger i = 0; i < compCoords.count-1; i++) {
		for (NSInteger j = i + 1; j < compCoords.count; j++) {
			// Is the expanded area bigger than maxArea?
			NSInteger area = (labs(coords[i].x - coords[j].x) + 1) *
							 (labs(coords[i].y - coords[j].y) + 1);

			// If not, move on
			if (area <= maxArea) { continue; }
			
			// Is every coord along the edge of the box the same color?
			AOCExtent *ext = [[AOCExtent alloc] initFrom:@[compCoords[i], compCoords[j]]];
			
			BOOL ok = YES;
//			for (AOCCoord *edgeCoord in ext.edgeCoords) { // Slow
			for (NSInteger x = ext.min.x; x <= ext.max.x; x++) {
				for (NSInteger y = ext.min.y; y <= ext.max.y; y++) {
					if (x == ext.min.x || x == ext.max.x || y == ext.min.y || y == ext.max.y) {
						if ([[grid stringAtCoord:[AOCCoord x:x y:y]] isEqualToString:@"#"] == NO) {
							ok = NO;
							break;
						}
					}
				}
				if (ok == NO) {break;}
			}
			
			if (ok) {
				maxArea = area;
//				NSLog(@"%ld", maxArea);
			}
		}
	}


	return [NSString stringWithFormat: @"The largest solid area is %ld", (long)maxArea];
}

- (AOCGrid *)paintGrid:(NSArray<AOCCoord *> *)coords {
	AOCGrid *grid = [AOCGrid grid];
	
	// Paint edges
	for (NSInteger i = 0; i < coords.count; i++) {
		AOCCoord *c1 = coords[i];
		AOCCoord *c2;
		if (i < coords.count-1) {
			c2 = coords[i+1];
		}
		else {
			c2 = coords.firstObject;
		}
		
		AOCSegment *seg = [AOCSegment segmentFrom:c1 to:c2];
		AOCCoord *ptr = c1;
		while ([ptr isEqualToCoord:c2] == NO) {
			[grid setObject:@"#" atCoord:ptr];
			ptr = [ptr offset:seg.direction];
		}
	}
	
	// Fill
	for (NSInteger x = grid.extent.min.x; x <= grid.extent.max.x; x++) {
		AOCCoord *c = [AOCCoord x:x y:grid.extent.min.y];
		AOCCoord *south = [AOCCoord x:x y:c.y+1];
		if ([[grid stringAtCoord:c] isEqualToString:@"#"] &&
			[[grid stringAtCoord:south] isEqualToString:@"."]) {
			[grid floodFillAt:south with:@"#"];
			break;
		}
	}
//	[grid print];
	
	return grid;
}

- (NSArray<AOCCoord *> *)parseCoords:(NSArray<NSString *> *)input {
	NSMutableArray<AOCCoord *> *result = [NSMutableArray array];
	
	for (NSString *line in input) {
		NSArray<NSNumber *> *ints = line.integersFromCSV;
		[result addObject: [AOCCoord x:ints[0].integerValue y:ints[1].integerValue]];
	}
	
	return result;
}

@end

@implementation AOCCompressionMap

- (AOCCompressionMap *)init:(NSArray<AOCCoord *> *)coords {
	self = [super init];
	
	NSMutableDictionary<NSNumber *, NSNumber *> *eMapX = [NSMutableDictionary dictionary];
	NSMutableDictionary<NSNumber *, NSNumber *> *cMapX = [NSMutableDictionary dictionary];
	NSMutableDictionary<NSNumber *, NSNumber *> *eMapY = [NSMutableDictionary dictionary];
	NSMutableDictionary<NSNumber *, NSNumber *> *cMapY = [NSMutableDictionary dictionary];

	NSMutableSet<NSNumber *> *xValueSet = [NSMutableSet set];
	NSMutableSet<NSNumber *> *yValueSet = [NSMutableSet set];
	
	for (AOCCoord *c in coords) {
		[xValueSet addObject: [NSNumber numberWithInteger: c.x]];
		[yValueSet addObject: [NSNumber numberWithInteger: c.y]];
	}
	
	NSMutableArray<NSNumber *> *xValues = xValueSet.allObjects.mutableCopy;
	NSMutableArray<NSNumber *> *yValues = yValueSet.allObjects.mutableCopy;
	[xValues  sortUsingSelector:@selector(compare:)];
	[yValues sortUsingSelector:@selector(compare:)];
	
	for (NSInteger i = 0; i < xValues.count; i++) {
		[eMapX setObject:xValues[i] forKey:[NSNumber numberWithInteger:i]];
		[cMapX setObject:[NSNumber numberWithInteger:i] forKey:xValues[i]];
	}
	for (NSInteger i = 0; i < yValues.count; i++) {
		[eMapY setObject:yValues[i] forKey:[NSNumber numberWithInteger:i]];
		[cMapY setObject:[NSNumber numberWithInteger:i] forKey:yValues[i]];
	}
	
	_expansionMapX = eMapX;
	_expansionMapY = eMapY;
	_compressionMapX = cMapX;
	_compressionMapY = cMapY;

	return self;
}


- (AOCCoord *)expand:(AOCCoord *)coord {
	NSInteger eX = self.expansionMapX[ [NSNumber numberWithInteger:coord.x] ].integerValue;
	NSInteger eY = self.expansionMapY[ [NSNumber numberWithInteger:coord.y] ].integerValue;
	return [AOCCoord x:eX y:eY];
}

- (AOCCoord *)compress:(AOCCoord *)coord {
	NSInteger cX = self.compressionMapX[ [NSNumber numberWithInteger:coord.x] ].integerValue;
	NSInteger cY = self.compressionMapY[ [NSNumber numberWithInteger:coord.y] ].integerValue;
	return [AOCCoord x:cX y:cY];
}

@end
