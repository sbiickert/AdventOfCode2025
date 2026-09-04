//
//  AOCDay06.m
//  AoC2025
//

#import <Foundation/Foundation.h>
#import "AOCDay.h"
#import "AOCMath.h"

@interface CephalopodEquation: NSObject

- (CephalopodEquation *)init:(NSArray<NSString *> *)input start:(NSInteger)start width:(NSInteger)width;
- (NSArray<NSNumber *> *) numbersForPart:(NSInteger)part;
- (NSInteger) solveForPart:(NSInteger)part;
@property (readonly) NSArray<NSArray<NSNumber *> *> *digits;
@property (readonly) NSString *operator;

@end;

@implementation AOCDay06

- (AOCDay06 *)init {
	self = [super initWithDay:6 name:@"Trash Compactor"];
	return self;
}

- (struct AOCResult)solveInputIndex:(int)index inFile:(NSString *)filename {
	struct AOCResult result = [super solveInputIndex:index inFile:filename];
	
	NSArray<NSString *> *input = [AOCInput readGroupedInputFile:filename atIndex:index];
	
	NSArray<CephalopodEquation *> *equations = [self parseEquations:input];
	
	result.part1 = [self solvePartOne: equations];
	result.part2 = [self solvePartTwo: equations];
	
	return result;
}

- (NSString *)solvePartOne:(NSArray<CephalopodEquation *> *)equations {
	NSInteger total = 0;
	
	for (CephalopodEquation *eq in equations) {
		total += [eq solveForPart:1];
	}
	
	return [NSString stringWithFormat: @"The total (H) %ld", (long)total];
}

- (NSString *)solvePartTwo:(NSArray<CephalopodEquation *> *)equations {
	NSInteger total = 0;
	
	for (CephalopodEquation *eq in equations) {
		total += [eq solveForPart:2];
	}
	
	return [NSString stringWithFormat: @"The total (V) %ld", (long)total];
}

- (NSArray<CephalopodEquation *> *)parseEquations:(NSArray<NSString *> *)input {
	NSMutableArray<NSNumber *> *indexes = [NSMutableArray array];
	
	for (NSInteger i = 0; i < input.lastObject.length; i++) {
		if ([[input.lastObject substringWithRange:NSMakeRange(i, 1)] isEqualToString:@" "] == NO) {
			[indexes addObject:[NSNumber numberWithInteger:i]];
		}
	}
	
	NSMutableArray<CephalopodEquation *> *result = [NSMutableArray array];
	for (NSInteger j = 0; j < indexes.count-1; j++) {
		NSInteger width = indexes[j+1].integerValue - indexes[j].integerValue - 1;
		[result addObject:[[CephalopodEquation alloc] init:input start:indexes[j].integerValue width:width]];
	}
	NSInteger width = input.firstObject.length - indexes.lastObject.integerValue;
	[result addObject:[[CephalopodEquation alloc] init:input start:indexes.lastObject.integerValue width:width]];
	
	return result;
}

@end


@implementation CephalopodEquation

- (CephalopodEquation *)init:(NSArray<NSString *> *)input start:(NSInteger)start width:(NSInteger)width {
	self = [super init];
	
	// Operator is in the last input line
	_operator = [input.lastObject substringWithRange: NSMakeRange(start, 1)];
	
	// _numbers is a 2-D array of integers, rows by cols
	NSMutableArray<NSMutableArray<NSNumber *> *> *work = [NSMutableArray array];
	
	for (NSInteger row = 0; row < input.count-1; row++) {
		NSMutableArray<NSNumber *> *rowArray = [NSMutableArray array];
		for (NSInteger col = start; col < start + width; col++) {
			NSString *s = [input[row] substringWithRange: NSMakeRange(col, 1)];
			if ([s isEqualToString:@" "]) {
				[rowArray addObject:@-1];
			}
			else {
				[rowArray addObject:[NSNumber numberWithInteger:s.integerValue]];
			}
		}
		[work addObject:rowArray];
	}
	
	_digits = work;
	
	return self;
}

- (NSArray<NSNumber *> *) numbersForPart:(NSInteger)part {
	NSMutableArray<NSNumber *> *result = [NSMutableArray array];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"integerValue >= 0"];
	
	// Read digits along rows (part 1)
	if (part == 1) {
		for (NSArray<NSNumber *> *row in self.digits) {
			NSArray<NSNumber *> *filtered = [row filteredArrayUsingPredicate:predicate];
			NSInteger num = [AOCMath joinDigits:filtered];
			[result addObject:[NSNumber numberWithInteger:num]];
		}
	}
	// Read digits along columns (part 2)
	else {
		for (NSInteger col = 0; col < self.digits.firstObject.count; col++) {
			NSMutableArray<NSNumber *> *colDigits = [NSMutableArray array];
			for (NSInteger row = 0; row < self.digits.count; row++) {
				[colDigits addObject:self.digits[row][col]];
			}
			NSArray<NSNumber *> *filtered = [colDigits filteredArrayUsingPredicate:predicate];
			NSInteger num = [AOCMath joinDigits:filtered];
			[result addObject:[NSNumber numberWithInteger:num]];
		}
	}
	
	return result;
}

- (NSInteger) solveForPart:(NSInteger)part {
	NSArray<NSNumber *> *numbers = [self numbersForPart:part];
	NSInteger total = 0;
	
	if ([self.operator isEqualToString:@"+"]) {
		for (NSNumber *num in numbers) {
			total += num.integerValue;
		}
	}
	else {
		total = 1;
		for (NSNumber *num in numbers) {
			total *= num.integerValue;
		}
	}
	return total;
}

@end
