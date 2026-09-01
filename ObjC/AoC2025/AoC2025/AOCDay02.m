//
//  AOCDay02.h
//  AoC2025
//
//  Created by Simon Biickert on 2026-08-30.
//

#import <Foundation/Foundation.h>
#import "AOCStrings.h"
#import "AOCDay.h"

@interface AOCDay02 ()

@property NSRegularExpression *idRegex1;
@property NSRegularExpression *idRegex2;

@end

@implementation AOCDay02

- (AOCDay02 *)init {
	self = [super initWithDay:2 name:@"Gift Shop"];
	
	NSError *err;
	_idRegex1 = [NSRegularExpression regularExpressionWithPattern:@"^(\\d+)\\1$"
														  options:0
															error:&err];
	_idRegex2 = [NSRegularExpression regularExpressionWithPattern:@"^(\\d+)\\1{1,}$"
														  options:0
															error:&err];

	return self;
}

- (struct AOCResult)solveInputIndex:(int)index inFile:(NSString *)filename {
	struct AOCResult result = [super solveInputIndex:index inFile:filename];
	
	NSArray<NSString *> *input = [AOCInput readGroupedInputFile:filename atIndex:index];
	NSString *rangeString = input.firstObject;
	NSArray<NSValue *> *ranges = [self parseRanges: rangeString];
	
	NSArray<NSString *> *results = [self solveParts:ranges];
	result.part1 = results.firstObject;
	result.part2 = results.lastObject;
	
	return result;
}

- (NSArray<NSString *> *)solveParts:(NSArray<NSValue *> *)ranges {
	NSInteger sum1 = 0;
	NSInteger sum2 = 0;

	for (NSValue *v in ranges) {
		NSRange r = v.rangeValue;
		
		for (NSInteger i = r.location; i <= NSMaxRange(r); i++) {
			NSString *idStr = [NSString stringWithFormat:@"%ld", (long)i];
			BOOL v1 = [self isIdValid1:idStr];
			if (v1) {
				sum1 += i;
			}
			if (v1 || [self isIdValid2:idStr]) {
				sum2 += i;
			}
		}
	}
	
	return [NSArray arrayWithObjects:
			[NSString stringWithFormat:@"%ld", (long)sum1],
			[NSString stringWithFormat:@"%ld", (long)sum2],
			nil];
}

- (BOOL)isIdValid1:(NSString *)idStr {
	if (idStr.length % 2 == 1) {
		return NO; // Odd number of characters
	}
	if ([idStr match:self.idRegex1] == nil) {
		return NO;
	}
	
	return YES;
}

- (BOOL)isIdValid2:(NSString *)idStr {
	if ([idStr match:self.idRegex2] == nil) {
		return NO;
	}
	
	return YES;
}

- (NSArray<NSValue *> *)parseRanges:(NSString *)allRanges {
	NSArray<NSString *> *rangeStrings = [allRanges componentsSeparatedByString:@","];
	NSMutableArray<NSValue *> *result = [NSMutableArray array];
	
	for (NSString *rString in rangeStrings) {
		NSArray<NSString *> *components = [rString componentsSeparatedByString:@"-"];
		NSInteger start = components.firstObject.integerValue;
		NSInteger end = components.lastObject.integerValue;
		NSRange range = NSMakeRange(start, (end-start)); // 2nd arg is length of range
		NSValue *v = [NSValue valueWithRange:range];
		[result addObject:v];
	}
	
	return result;
}

@end
