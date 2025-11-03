//
//  AOCSolution.h
//  AoC2017
//
//  Created by Simon Biickert on 2023-01-27.
//

struct AOCResult {
	NSString *part1;
	NSString *part2;
};

@interface AOCSolution : NSObject

+ (NSArray<AOCSolution *> *)allSolutions;

@property (readonly) int day;
@property (readonly) NSString *name;
@property BOOL emptyLinesIndicateMultipleInputs;

- (AOCSolution *)initWithDay:(int)day name:(NSString *)name;

- (struct AOCResult)solveInputIndex:(int)index inFile:(NSString *)filename;

@end
