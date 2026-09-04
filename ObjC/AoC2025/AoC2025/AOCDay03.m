//
//  AOCDay03.m
//  AoC2025
//
//  Created by Simon Biickert on 2026-09-01.
//

#import <Foundation/Foundation.h>
#import "AOCDay.h"
#import "AOCStrings.h"
#import "AOCMath.h"

@implementation AOCDay03

- (AOCDay03 *)init {
	self = [super initWithDay:3 name:@"Lobby"];
	return self;
}

- (struct AOCResult)solveInputIndex:(int)index inFile:(NSString *)filename {
	struct AOCResult result = [super solveInputIndex:index inFile:filename];
	
	NSArray<NSString *> *input = [AOCInput readGroupedInputFile:filename atIndex:index];
	
	NSArray<NSArray <NSNumber *> *> *joltages = [self parseJoltages:input];
	
	result.part1 = [self solvePartOne: joltages];
	result.part2 = [self solvePartTwo: joltages];
	
	return result;
}

- (NSString *)solvePartOne:(NSArray<NSArray <NSNumber *> *> *)joltages {
	NSInteger sum = 0;
	
	for (NSArray <NSNumber *> *jolts in joltages) {
		NSArray <NSNumber *> *best = [self selectBest:2 in:jolts];
		NSInteger value = [AOCMath joinDigits:best];
		sum += value;
	}
	
	return [NSString stringWithFormat: @"%ld", (long)sum];
}

- (NSString *)solvePartTwo:(NSArray<NSArray <NSNumber *> *> *)joltages {
	NSInteger sum = 0;
	
	for (NSArray <NSNumber *> *jolts in joltages) {
		NSArray <NSNumber *> *best = [self selectBest:12 in:jolts];
		NSInteger value = [AOCMath joinDigits:best];
		sum += value;
	}
	
	return [NSString stringWithFormat: @"%ld", (long)sum];
}

- (NSArray<NSNumber *> *)selectBest:(NSInteger)count in:(NSArray <NSNumber *> *)joltages {
	NSMutableArray< NSNumber *> *work = joltages.mutableCopy;
	
	while (work.count > count) {
		// Iteratively remove numbers that are smaller than the ones after them.
		NSInteger removeIndex = -1;
		for (NSInteger i = 0; i < work.count; i++) {
			NSInteger diff = 0;
			if (i < work.count-1) { diff = work[i].integerValue - work[i+1].integerValue; }
			if (diff < 0) {
				removeIndex = i;
				break;
			}
		}
		if (removeIndex < 0) { removeIndex = work.count-1; }
		[work removeObjectAtIndex:removeIndex];
	}
	
	return work;
}

- (NSArray<NSArray <NSNumber *> *> *)parseJoltages:(NSArray<NSString *> *)input {
	NSMutableArray<NSArray <NSNumber *> *> *results = [NSMutableArray array];
	
	for (NSString *line in input) {
		NSArray<NSString *> *chars = line.allCharacters;
		NSMutableArray<NSNumber *> *jolts = [NSMutableArray array];
		
		for (NSString *c in chars) {
			[jolts addObject: [NSNumber numberWithInteger: [c integerValue]]];
		}
		[results addObject:jolts];
	}
	
	return results;
}

@end
