//
//  AOCGrid2D.h
//  AoC2017
//
//  Created by Simon Biickert on 2023-01-29.
//
#import "AOCCoord.h"
#import "AOCExtent2D.h"

extern NSString * const ROOK;
extern NSString * const BISHOP;
extern NSString * const QUEEN;
extern NSString * const HEX;

@interface AOCGrid2D : NSObject

+ (AOCGrid2D *)grid;

- (AOCGrid2D *)init;
- (AOCGrid2D *)initWithDefault:(NSObject *)value adjacency:(NSString *)rule;

@property (readonly) NSString *rule;
@property (readonly) NSObject *defaultValue;

- (NSObject *)objectAtCoord:(AOCCoord2D *)coord;
- (int)intAtCoord:(AOCCoord2D *)coord;
- (NSString *)stringAtCoord:(AOCCoord2D *)coord;
- (void)setObject:(NSObject *)value atCoord:(AOCCoord2D *)coord;

- (void)clearAtCoord:(AOCCoord2D *)coord;
- (void)clearAll;

- (AOCExtent2D *)extent;

- (NSArray<AOCCoord2D *> *)coords;
- (NSArray<AOCCoord2D *> *)coordsWithValue:(NSObject *)value;

- (NSArray<AOCCoord2D *> *)offsets;
- (NSArray<AOCCoord2D *> *)adjacentTo:(AOCCoord2D *)coord;
- (NSArray<AOCCoord2D *> *)adjacentTo:(AOCCoord2D *)coord withValue:(NSObject *)value;

- (void)print;
- (void)printInvertedY:(BOOL)invert;
- (void)printInvertedY:(BOOL)invert withOverlay:(NSDictionary<AOCCoord2D *, NSString *> *)overlay;

- (NSDictionary<AOCCoord2D *, NSObject *> *)data;
- (BOOL)isEqualToGrid:(AOCGrid2D *)other;

@end
