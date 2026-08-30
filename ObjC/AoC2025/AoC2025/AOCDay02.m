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
	
	result.part1 = [self solvePartOne: ranges];
	result.part2 = [self solvePartTwo: ranges];
	
	return result;
}

- (NSString *)solvePartOne:(NSArray<NSValue *> *)ranges {
	NSInteger sum = 0;
	
	for (NSValue *v in ranges) {
		NSRange r = v.rangeValue;
		
		for (NSInteger i = r.location; i <= NSMaxRange(r); i++) {
			if ([self isIdValid1:i]) {
				sum += i;
			}
		}
	}
	
	return [NSString stringWithFormat:@"%ld", (long)sum];
}

- (NSString *)solvePartTwo:(NSArray<NSValue *> *)ranges {
	NSInteger sum = 0;
	
	for (NSValue *v in ranges) {
		NSRange r = v.rangeValue;
		
		for (NSInteger i = r.location; i <= NSMaxRange(r); i++) {
			if ([self isIdValid2:i]) {
				sum += i;
			}
		}
	}
	
	return [NSString stringWithFormat:@"%ld", (long)sum];
}

- (BOOL)isIdValid1:(NSInteger)id {
	NSString *idStr = [NSString stringWithFormat:@"%ld", (long)id];
	if (idStr.length % 2 == 1) {
		return NO; // Odd number of characters
	}
	if ([idStr match:self.idRegex1] == nil) {
		return NO;
	}
	
	return YES;
}

- (BOOL)isIdValid2:(NSInteger)id {
	NSString *idStr = [NSString stringWithFormat:@"%ld", (long)id];
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
