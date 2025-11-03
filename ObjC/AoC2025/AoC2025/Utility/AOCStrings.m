//
//  AOCStrings.m
//  AoC2017
//
//  Created by Simon Biickert .
//

#import <Foundation/Foundation.h>
#import "AOCStrings.h"

@implementation NSString (AOCString)

+ (NSString *)binaryStringFromInteger:(int)number width:(int)width
{
	NSMutableString * string = [[NSMutableString alloc] init];

	int binaryDigit = 0;
	int integer = number;
	
	while( binaryDigit < width )
	{
		binaryDigit++;
		[string insertString:( (integer & 1) ? @"1" : @"0" )atIndex:0];
		integer = integer >> 1;
	}
	
	return string;
}


-(NSArray<NSString *> *)getAllCharacters {
	NSMutableArray *characters = [[NSMutableArray alloc] initWithCapacity:[self length]];
	for (int i=0; i < [self length]; i++) {
		NSString *ichar  = [NSString stringWithFormat:@"%c", [self characterAtIndex:i]];
		[characters addObject:ichar];
	}
	return characters;
}

- (void)print
{
	printf("%s", [self cStringUsingEncoding:NSUTF8StringEncoding]);
}

- (void)println
{
	printf("%s\n", [self cStringUsingEncoding:NSUTF8StringEncoding]);
}

- (NSString *)stringByReplacingWithPattern:(NSString *)pattern withTemplate:(NSString *)withTemplate error:(NSError **)error {
	NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
																		   options:NSRegularExpressionCaseInsensitive
																			 error:error];
	return [regex stringByReplacingMatchesInString:self
										   options:0
											 range:NSMakeRange(0, self.length)
									  withTemplate:withTemplate];
}

- (BOOL)isAllDigits
{
	NSMutableCharacterSet* nonNumbers = [[[NSCharacterSet decimalDigitCharacterSet] invertedSet] mutableCopy];
	[nonNumbers removeCharactersInString:@"-"];
	NSRange r = [self rangeOfCharacterFromSet: nonNumbers];
	return r.location == NSNotFound && self.length > 0;
}


@end
