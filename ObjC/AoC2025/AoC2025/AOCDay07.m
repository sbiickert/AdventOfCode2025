//
//  AOCDay07.m
//  AoC2025
//

#import <Foundation/Foundation.h>
#import "AOCDay.h"
#import "AOCSpatial.h"
#import "AOCGrid.h"

@implementation AOCDay07

- (AOCDay07 *)init {
	self = [super initWithDay:7 name:@"Laboratories"];
	return self;
}

- (struct AOCResult)solveInputIndex:(int)index inFile:(NSString *)filename {
	struct AOCResult result = [super solveInputIndex:index inFile:filename];
	
	NSArray<NSString *> *input = [AOCInput readGroupedInputFile:filename atIndex:index];
	
	// Remove alternating rows b/c not useful
	NSMutableArray<NSString *> *mInput = input.mutableCopy;
	for (NSInteger i = input.count-1; i > 0; i--) {
		if (i % 2 == 1) { [mInput removeObjectAtIndex:i]; }
	}
	
	AOCGrid *grid = [[AOCGrid alloc] initWithDefault:@" " adjacency:QUEEN];
	[grid load:mInput];

	AOCCoord *start = [grid coordsWithValue:@"S"].firstObject;
	
	result.part1 = [self solvePartOne: grid startPosition:start];
	result.part2 = [self solvePartTwo: grid startPosition:start];
	
	return result;
}

- (NSString *)solvePartOne:(AOCGrid *)grid startPosition:(AOCCoord *)start {
	[grid setObject:@"|" atCoord:start];
	NSInteger splitCount = 0;
	AOCExtent *ext = [grid extent];
	
	for (NSInteger row = start.y; row <= ext.max.y; row++) {
		for (NSInteger col = ext.min.x; col <= ext.max.x; col++) {
			AOCCoord *c = [AOCCoord x:col y:row];
			BOOL isBeam = [[grid stringAtCoord: c] isEqualToString:@"|"];
			if (isBeam) {
				AOCCoord *down = [c offset:DOWN];
				BOOL isSplitter = [[grid stringAtCoord: down] isEqualToString:@"^"];
				if (isSplitter) {
					splitCount++;
					AOCCoord *downLeft = [c offset:SW];
					AOCCoord *downRight = [c offset:SE];
					[grid setObject:@"|" atCoord:downLeft];
					[grid setObject:@"|" atCoord:downRight];
				}
				else {
					[grid setObject:@"|" atCoord:down];
				}
			}
		}
	}
		
	return [NSString stringWithFormat: @"Number of splits %ld", (long)splitCount];
}

- (NSString *)solvePartTwo:(AOCGrid *)grid startPosition:(AOCCoord *)start {
	NSDictionary<AOCCoord *, NSNumber *> *beams = [NSDictionary dictionaryWithObject:@"1" forKey:start];
	
//	while (beams.count > 0) {
//		
//	}

	return [NSString stringWithFormat: @"World %ld", (long)42];
}

@end
