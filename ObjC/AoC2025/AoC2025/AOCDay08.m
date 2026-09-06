//
//  AOCDay08.m
//  AoC2025
//

#import <Foundation/Foundation.h>
#import "AOCDay.h"
#import "AOCSpatial3D.h"
#import "AOCStrings.h"

@interface JBGap : NSObject

- (JBGap *)initFrom:(AOCCoord3D *)c1 to:(AOCCoord3D *)c2;
@property (readonly) AOCCoord3D *from;
@property (readonly) AOCCoord3D *to;
@property (readonly) double distance;

@end

@implementation AOCDay08

- (AOCDay08 *)init {
	self = [super initWithDay:8 name:@"Playground"];
	return self;
}

- (struct AOCResult)solveInputIndex:(int)index inFile:(NSString *)filename {
	struct AOCResult result = [super solveInputIndex:index inFile:filename];
	
	NSArray<NSString *> *input = [AOCInput readGroupedInputFile:filename atIndex:index];
	
	NSArray<AOCCoord3D *> *boxes = [self parseJunctionBoxes:input];
	NSArray<JBGap *> *gaps = [self calculateGaps:boxes];
	
	NSInteger limit = 10;
	if (boxes.count > 20) { limit = 1000; }
	
	result.part1 = [self solvePartOne: boxes gaps:gaps limit: limit];
	result.part2 = [self solvePartTwo: input];
	
	return result;
}

- (NSString *)solvePartOne:(NSArray<AOCCoord3D *> *)boxes
					  gaps:(NSArray<JBGap *> *)gaps
					 limit:(NSInteger)limit {
	NSMutableArray<NSSet<AOCCoord3D *> *> *circuits = [self buildCircuits:boxes];
	
	NSInteger i = 0;
	for (JBGap *gap in gaps) {
		NSSet *circuit1 = [self findJunctionBox:gap.from in:circuits];
		NSSet *circuit2 = [self findJunctionBox:gap.to in:circuits];
		
		if (circuit1 != circuit2) {
			NSSet *merged = [circuit1 setByAddingObjectsFromSet:circuit2];
			[circuits removeObject:circuit1];
			[circuits removeObject:circuit2];
			[circuits addObject:merged];
		}
		
		i++;
		if (i == limit) { break; }
	}
	
	[circuits sortUsingComparator:^NSComparisonResult(NSSet *s1, NSSet *s2) {
		NSNumber *n1 = [NSNumber numberWithInteger: s1.count];
		NSNumber *n2 = [NSNumber numberWithInteger: s2.count];
		return [n2 compare:n1]; // Descending
	}];
	
	NSInteger product = circuits[0].count * circuits[1].count * circuits[2].count;
	
	return [NSString stringWithFormat: @"The product of sizes of three biggest circuits is %ld", (long)product];
}

- (NSString *)solvePartTwo:(NSArray<NSString *> *)input {
	
	return [NSString stringWithFormat: @"World %ld", (long)42];
}

- (NSArray<AOCCoord3D *> *)parseJunctionBoxes:(NSArray<NSString *> *)input {
	NSMutableArray<AOCCoord3D *> *result = [NSMutableArray array];
	
	for (NSString *line in input) {
		NSArray<NSNumber *> *numbers = line.integersFromCSV;
		AOCCoord3D *c = [[AOCCoord3D alloc] initX:numbers[0].integerValue
												y:numbers[1].integerValue
												z:numbers[2].integerValue];
		[result addObject:c];
	}
	
	return result;
}

- (NSArray<JBGap *> *)calculateGaps:(NSArray<AOCCoord3D *> *)boxes {
	NSMutableArray<JBGap *> *result = [NSMutableArray array];
	
	// Comparator is faster than descriptor
//	NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES];
	
	NSComparator comparator = ^NSComparisonResult(JBGap *jb1, JBGap *jb2) {
		NSComparisonResult r = NSOrderedSame;
		if (jb1.distance < jb2.distance) { r = NSOrderedAscending; }
		else if (jb1.distance > jb2.distance) { r = NSOrderedDescending; }
		return r;
	};


	for (NSInteger i = 0; i < boxes.count-1; i++) {
		for (NSInteger j = i + 1; j < boxes.count; j++) {
			JBGap *gap = [[JBGap alloc] initFrom:boxes[i] to:boxes[j]];
			[result addObject:gap];
		}
	}
	
	[result sortUsingComparator:comparator];
//	[result sortUsingDescriptors:@[descriptor]];

	return result;
}

- (NSMutableArray<NSSet<AOCCoord3D *> *> *)buildCircuits:(NSArray<AOCCoord3D *> *)boxes {
	// Just build single-box circuits to start
	NSMutableArray<NSSet<AOCCoord3D *> *> *result = [NSMutableArray array];
	
	for (AOCCoord3D *jb in boxes) {
		[result addObject:[NSSet setWithObject:jb]];
	}
	
	return result;
}

- (NSSet<AOCCoord3D *> *)findJunctionBox:(AOCCoord3D *)jb in:(NSArray<NSSet<AOCCoord3D *> *> *)circuits {
	for (NSSet<AOCCoord3D *> *circuit in circuits) {
		if ([circuit containsObject:jb]) { return circuit; }
	}
	return nil;
}

@end

@implementation JBGap



- (JBGap *)initFrom:(AOCCoord3D *)c1 to:(AOCCoord3D *)c2 {
	self = [super init];
	
	_from = c1;
	_to = c2;
	_distance = [c1 distanceTo:c2];
	
	return self;
}

@end
