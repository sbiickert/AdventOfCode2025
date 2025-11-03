//
//  AOCSolution.m
//  AoC2017
//
//  Created by Simon Biickert on 2023-01-27.
//

#import <Foundation/Foundation.h>
#import "AOCSolution.h"

@implementation AOCSolution

+ (NSArray<AOCSolution *> *)allSolutions {
	return @[];
}

- (AOCSolution *)initWithDay:(int)day name:(NSString *)name {
	self = [super init];
	_day = day;
	_name = name;
	self.emptyLinesIndicateMultipleInputs = YES;
	return self;
}

- (struct AOCResult)solveInputIndex:(int)index inFile:(NSString *)filename {
	NSLog(@"Day %02d: \"%@\" with input %@ [%d]", self.day, self.name, filename, index);
	struct AOCResult result;
	result.part1 = @"";
	result.part2 = @"";
	return result;
}

@end
