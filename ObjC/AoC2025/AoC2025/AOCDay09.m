//
//  AOCDay09.m
//  AoC2025
//

#import <Foundation/Foundation.h>
#import "AOCDay.h"
#import "AOCSpatial.h"
#import "AOCStrings.h"

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
	AOCCompressionMap *cMap = [[AOCCompressionMap alloc] init:coords];
	
//	AOCCoord *compressed = [cMap compress:coords.firstObject];
//	AOCCoord *expanded = [cMap expand:compressed];
//	assert([expanded isEqualToCoord:coords.firstObject]);
	
	result.part1 = [self solvePartOne: coords];
	result.part2 = [self solvePartTwo: input];
	
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

- (NSString *)solvePartTwo:(NSArray<NSString *> *)input {
	
	return [NSString stringWithFormat: @"World %ld", (long)42];
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
