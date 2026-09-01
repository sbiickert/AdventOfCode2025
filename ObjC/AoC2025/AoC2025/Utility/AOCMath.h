//
//  AOCMath.h
//  AoC2018
//
//  Created by Simon Biickert on 2024-02-05.
//

@interface AOCMath : NSObject

+ (NSInteger)gcdOfX:(NSInteger)x andY:(NSInteger)y;
+ (NSInteger)lcmOfX:(NSInteger)x andY:(NSInteger)y;
+ (NSInteger)lcmIn:(NSArray<NSNumber *>*)values;
+ (NSInteger)powerOfBase:(NSInteger)base exponent:(NSInteger)exponent;

@end
