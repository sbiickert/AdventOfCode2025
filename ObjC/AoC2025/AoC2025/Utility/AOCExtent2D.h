//
//  AOCExtent2D.h
//  AoC2017
//
//  Created by Simon Biickert .
//
#import "AOCCoord.h"

@interface AOCExtent2D : NSObject

+ (AOCExtent2D *)xMin:(int)xmin yMin:(int)ymin xMax:(int)xmax yMax:(int)ymax;
+ (AOCExtent2D *)copyOf:(AOCExtent2D *)other;

- (AOCExtent2D *)initXMin:(int)xmin yMin:(int)ymin xMax:(int)xmax yMax:(int)ymax;
- (AOCExtent2D *)initMin:(AOCCoord2D *)min max:(AOCCoord2D *)max;
- (AOCExtent2D *)initFrom:(NSArray<AOCCoord2D *> *)array;

@property (readonly) AOCCoord2D *min;
@property (readonly) AOCCoord2D *max;

- (int)width;
- (int)height;
- (int)area;
- (AOCCoord2D *)center;

- (void)expandToFit:(AOCCoord2D *)coord;
- (NSArray<AOCCoord2D *> *)allCoords;
- (BOOL)contains:(AOCCoord2D *)coord;
- (AOCExtent2D *)inset:(int)amount;


@end
