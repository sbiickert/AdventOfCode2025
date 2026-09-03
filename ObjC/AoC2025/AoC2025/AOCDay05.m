//
//  AOCDay05.m
//  AoC2025
//

#import <Foundation/Foundation.h>
#import "AOCDay.h"

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
	result.part2 = [self solvePartTwo: idInput];
	
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

- (NSString *)solvePartTwo:(NSArray<NSString *> *)input {
	
	return [NSString stringWithFormat: @"World %ld", (long)42];
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
