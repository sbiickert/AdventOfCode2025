//
//  AOCExtent2D.m
//  AoC2017
//
//  Created by Simon Biickert .
//

#import <Foundation/Foundation.h>
#import "AOCExtent2D.h"

@implementation AOCExtent2D

+ (AOCExtent2D *)xMin:(int)xmin yMin:(int)ymin xMax:(int)xmax yMax:(int)ymax {
	return [[AOCExtent2D alloc] initXMin:xmin yMin:ymin xMax:xmax yMax:ymax];
}

+ (AOCExtent2D *)copyOf:(AOCExtent2D *)other
{
	return [[AOCExtent2D alloc] initXMin:other.min.x yMin:other.min.y xMax:other.max.x yMax:other.max.y];
}


- (AOCExtent2D *)initXMin:(int)xmin yMin:(int)ymin xMax:(int)xmax yMax:(int)ymax
{
	AOCCoord2D *c1 = [AOCCoord2D x:xmin y:ymin];
	AOCCoord2D *c2 = [AOCCoord2D x:xmax y:ymax];
	NSArray<AOCCoord2D *> *coords = @[c1, c2];
	return [self initFrom:coords];
}

- (AOCExtent2D *)initMin:(AOCCoord2D *)min max:(AOCCoord2D *)max
{
	NSMutableArray<AOCCoord2D *> *coords = [NSMutableArray array];
	if (min != nil) {
		[coords addObject:min];
	}
	if (max != nil) {
		[coords addObject:max];
	}
	return [self initFrom:coords];
}

- (AOCExtent2D *)initFrom:(NSArray<AOCCoord2D *> *)array
{
	self = [super init];
	if (array == nil || array.count == 0) {
		_min = [AOCCoord2D origin];
		_max = [AOCCoord2D origin];
		return self;
	}
	int xmin = [array firstObject].x;
	int xmax = [array firstObject].x;
	int ymin = [array firstObject].y;
	int ymax = [array firstObject].y;
	for (int i = 1; i < array.count; i++) {
		xmin = MIN(xmin, [array objectAtIndex:i].x);
		xmax = MAX(xmax, [array objectAtIndex:i].x);
		ymin = MIN(ymin, [array objectAtIndex:i].y);
		ymax = MAX(ymax, [array objectAtIndex:i].y);
	}
	_min = [AOCCoord2D x:xmin y:ymin];
	_max = [AOCCoord2D x:xmax y:ymax];
	return self;
}

- (int)width
{
	return self.max.x - self.min.x + 1;
}

- (int)height
{
	return self.max.y - self.min.y + 1;
}

- (int)area
{
	return self.width * self.height;
}

- (AOCCoord2D *)center
{
	int x = self.width / 2;
	int y = self.height / 2;
	return [AOCCoord2D x:x y:y];
}

- (void)expandToFit:(AOCCoord2D *)coord
{
	if (coord.x < self.min.x) {
		_min = [AOCCoord2D x:coord.x y:self.min.y];
	}
	else if (coord.x > self.max.x) {
		_max = [AOCCoord2D x:coord.x y:self.max.y];
	}
	if (coord.y < self.min.y) {
		_min = [AOCCoord2D x:self.min.x y:coord.y];
	}
	else if (coord.y > self.max.y) {
		_max = [AOCCoord2D x:self.max.x y:coord.y];
	}
}

- (NSArray<AOCCoord2D *> *)allCoords
{
	NSMutableArray<AOCCoord2D *> *coords = [NSMutableArray array];
	for (int x = self.min.x; x <= self.max.x; x++) {
		for (int y = self.min.y; y <= self.max.y; y++) {
			[coords addObject:[AOCCoord2D x:x y:y]];
		}
	}
	return coords;
}

- (BOOL)contains:(AOCCoord2D *)coord
{
	return 	coord.x >= self.min.x &&
			coord.x <= self.max.x &&
			coord.y >= self.min.y &&
			coord.y <= self.max.y;
}

- (AOCExtent2D *)inset:(int)amount
{
	int xmin = self.min.x + amount;
	int xmax = self.max.x - amount;
	int ymin = self.min.y + amount;
	int ymax = self.max.y - amount;
	
	return [AOCExtent2D xMin:xmin yMin:ymin xMax:xmax yMax:ymax];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"{min: %@ max: %@}", self.min.description, self.max.description];
}

- (BOOL)isEqualToExtent2D:(AOCExtent2D *)other {
	if (other == nil) {
		return NO;
	}
	return [self.min isEqualToCoord2D:other.min] && [self.max isEqualToCoord2D:other.max];
}

- (BOOL)isEqual:(nullable id)object {
	if (object == nil) {
		return NO;
	}

	if (self == object) {
		return YES;
	}

	if (![object isKindOfClass:[AOCExtent2D class]]) {
		return NO;
	}

	return [self isEqualToExtent2D:(AOCExtent2D *)object];
}

- (NSUInteger)hash {
	return [self.min hash] ^ [self.max hash];
}

@end
