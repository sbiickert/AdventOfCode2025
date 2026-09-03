//
//  AOCDay04.m
//  AoC2025
//

#import <Foundation/Foundation.h>
#import "AOCDay.h"
#import "AOCSpatial.h"
#import "AOCGrid.h"

@implementation AOCDay04

- (AOCDay04 *)init {
	self = [super initWithDay:4 name:@"Printing Department"];
	return self;
}

- (struct AOCResult)solveInputIndex:(int)index inFile:(NSString *)filename {
	struct AOCResult result = [super solveInputIndex:index inFile:filename];
	
	NSArray<NSString *> *input = [AOCInput readGroupedInputFile:filename atIndex:index];
	
	AOCGrid *grid = [[AOCGrid alloc] initWithDefault:@"." adjacency: QUEEN];
	[grid load:input];
		
	result.part1 = [self solvePartOne: grid];
	result.part2 = [self solvePartTwo: grid];
	
	return result;
}

- (NSString *)solvePartOne:(AOCGrid *)grid {
	NSMutableArray<AOCCoord *> *remove = [NSMutableArray array];
	
	for (AOCCoord *c in grid.coords) {
		NSArray <AOCCoord *> *neighbors = [grid adjacentTo:c withValue:@"@"];
		if (neighbors.count < 4) {
			[remove addObject:c];
		}
	}
	
//	NSMutableDictionary<AOCCoord *, NSString *> *markers = [NSMutableDictionary dictionary];
//	for (AOCCoord *c in remove) {
//		[markers setObject:@"x" forKey:c];
//	}
//	
//	[grid print];
//	[grid printWithOverlay:markers];
	
	return [NSString stringWithFormat:@"%ld", (long)remove.count];
}

- (NSString *)solvePartTwo:(AOCGrid *)grid {
	
	return @"World";
}

@end
