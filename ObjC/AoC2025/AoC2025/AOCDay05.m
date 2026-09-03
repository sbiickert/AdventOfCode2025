//
//  AOCDay05.m
//  AoC2025
//

#import <Foundation/Foundation.h>
#import "AOCDay.h"
#import "AOCStrings.h"

@implementation AOCDay05

- (AOCDay05 *)init {
	self = [super initWithDay:5 name:@"Cafeteria"];
	return self;
}

- (struct AOCResult)solveInputIndex:(int)index inFile:(NSString *)filename {
	struct AOCResult result = [super solveInputIndex:index inFile:filename];
	
	NSArray<NSString *> *rangeInput = [AOCInput readGroupedInputFile:filename atIndex:0];
	NSArray<NSValue *> *ranges = [self parseRanges:rangeInput];
	
	NSArray<NSString *> *idInput = [AOCInput readGroupedInputFile:filename atIndex:1];
	NSArray<NSNumber *> *ids = [self parseIDs:idInput];

	result.part1 = [self solvePartOne: ranges ids:ids];
	result.part2 = [self solvePartTwo: ranges];
	
	return result;
}

- (NSString *)solvePartOne:(NSArray<NSValue *> *)ranges ids:(NSArray<NSNumber *>*)ids {
	NSInteger freshCount = 0;
	
	for (NSNumber *num in ids) {
		NSInteger ingredientID = num.integerValue;
		for (NSValue *val in ranges){
			NSRange range = val.rangeValue;
			if (ingredientID >= range.location && ingredientID <= range.location + range.length) {
				freshCount++;
				break;
			}
		}
	}
	return [NSString stringWithFormat: @"Fresh ingredient count is %ld", (long)freshCount];
}

- (NSString *)solvePartTwo:(NSArray<NSValue *> *)ranges {
	NSArray<NSValue *> *newRanges = [self coalesceRanges:ranges];
	
	NSInteger freshCount = 0;
	
	for (NSValue *val in newRanges){
		NSRange range = val.rangeValue;
		freshCount += range.length + 1;
	}
	
	return [NSString stringWithFormat: @"Fresh ID count is %ld", (long)freshCount];
}

- (NSArray<NSValue *> *)coalesceRanges:(NSArray<NSValue *> *)ranges {
	NSMutableArray<NSValue *> *coalesced = ranges.mutableCopy; // ranges are sorted by location (i.e. start id)
	
	BOOL arrayIsChanged = YES;
	
	while (arrayIsChanged) {
		arrayIsChanged = NO;
		for (NSInteger i = 0; i < coalesced.count-1; i++) {
			NSRange r1 = [coalesced objectAtIndex:i].rangeValue;
			NSRange r2 = [coalesced objectAtIndex:i+1].rangeValue;
			
			if (NSMaxRange(r1) >= r2.location) {
				NSUInteger upper = MAX(NSMaxRange(r1), NSMaxRange(r2));
				NSRange unionRange = NSMakeRange(r1.location, upper - r1.location);
				coalesced[i] = [NSValue valueWithRange:unionRange];
				[coalesced removeObjectAtIndex:i+1];
				arrayIsChanged = YES;
				break;
			}
		}
	}
	
	return coalesced;
}

- (NSArray<NSValue *>*)parseRanges:(NSArray<NSString *> *)input {
	NSMutableArray<NSValue *> *result = [NSMutableArray array];
	
	for (NSString *line in input) {
		NSArray<NSString *> *components = [line componentsSeparatedByString:@"-"];
		NSInteger start = components.firstObject.integerValue;
		NSInteger end = components.lastObject.integerValue;
		NSRange range = NSMakeRange(start, end - start);
		[result addObject:[NSValue valueWithRange:range]];
	}
	
	[result sortUsingComparator:^NSComparisonResult(NSValue *v1, NSValue *v2) {
		NSNumber *n1 = [NSNumber numberWithInteger:v1.rangeValue.location];
		NSNumber *n2 = [NSNumber numberWithInteger:v2.rangeValue.location];
		return [n1 compare: n2];
	}];
	
	return result;
}

- (NSArray<NSNumber *> *)parseIDs:(NSArray<NSString *> *)input {
	NSMutableArray<NSNumber *> *ids = [NSMutableArray array];
	
	for (NSString *line in input) {
		[ids addObject:[NSNumber numberWithInteger: [line integerValue]]];
	}
	
	return ids;
}

@end
