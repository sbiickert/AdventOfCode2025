//
//  AOCMathTests.m
//  AoC2018Tests
//
//  Created by Simon Biickert on 2024-02-07.
//

#import <XCTest/XCTest.h>
#import "AOCMath.h"

@interface AOCMathTests : XCTestCase

@end

@implementation AOCMathTests

- (void)testGCD {
// LCM uses GCD, so GCD is being tested already
}

- (void)testLCM {
	NSInteger lcm2 = [AOCMath lcmOfX:3761 andY:4091];
	XCTAssertEqual(lcm2, 15386251);
	
	NSArray<NSNumber *> *numbers = @[@3761, @3767, @4001, @4091];
	NSInteger lcmAll = [AOCMath lcmIn:numbers];
	XCTAssertEqual(lcmAll, 231897990075517);
}

@end
