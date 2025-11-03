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
	self = [super initWithDay:1 name:@"abc"];
	return self;
}

- (struct AOCResult)solveInputIndex:(int)index inFile:(NSString *)filename {
	struct AOCResult result = [super solveInputIndex:index inFile:filename];
	
	NSArray<NSString *> *input = [AOCInput readGroupedInputFile:filename atIndex:index];
	
	result.part1 = [self solvePartOne: [input objectAtIndex:0]];
	result.part2 = [self solvePartTwo: [input objectAtIndex:0]];
	
	return result;
}

- (NSString *)solvePartOne:(NSString *)input {

	return @"abc";
}

- (NSString *)solvePartTwo:(NSString *)input {

	return @"123";
}

@end
