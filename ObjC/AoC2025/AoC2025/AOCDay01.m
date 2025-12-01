//
//  AOCDay01.m
//  AoC2025
//
//  Created by Simon Biickert on 2025-11-03.
//

#import <Foundation/Foundation.h>
#import "AOCDay.h"
#import "AOCStrings.h"

@implementation AOCDay01

- (AOCDay01 *)init {
	self = [super initWithDay:1 name:@"Secret Entrance"];
	return self;
}

- (struct AOCResult)solveInputIndex:(int)index inFile:(NSString *)filename {
	struct AOCResult result = [super solveInputIndex:index inFile:filename];
	
	NSArray<NSString *> *input = [AOCInput readGroupedInputFile:filename atIndex:index];
	
	NSMutableArray<NSNumber *> *numbers = [NSMutableArray array];
	[input enumerateObjectsUsingBlock:^(NSString *line, NSUInteger idx, BOOL *stop) {
		line = [line stringByReplacingOccurrencesOfString:@"L" withString:@"-"];
		line = [line stringByReplacingOccurrencesOfString:@"R" withString:@""];
		[numbers addObject:[NSNumber numberWithInteger:[line integerValue]]];
	}];
	
	result.part1 = [self solvePartOne: numbers];
	result.part2 = [self solvePartTwo: numbers];
	
	return result;
}

- (NSString *)solvePartOne:(NSArray<NSNumber *> *)input {
	NSInteger value = 50;
	NSInteger zeroCount = 0;
	
	for (NSNumber *number in input) {
		value += number.integerValue;
		value %= 100;
		if (value == 0) { zeroCount++; }
	}
	
	return [NSString stringWithFormat:@"The number of times ending on zero is %ld", zeroCount];
}

- (NSString *)solvePartTwo:(NSArray<NSNumber *> *)input {
	NSInteger value = 50;
	NSInteger zeroCount = 0;
	
	for (NSNumber *number in input) {
		NSInteger i = number.integerValue;
		NSInteger step = i / labs(i);
		
		for (NSInteger j = 0; j < labs(i); j++) {
			value += step;
			value %= 100;
			if (value == 0) { zeroCount++; }
		}
	}
	
	return [NSString stringWithFormat:@"The number of times pointing at zero is %ld", zeroCount];
}

@end
