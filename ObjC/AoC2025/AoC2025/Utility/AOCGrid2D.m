//
//  AOCGrid2D.m
//  AoC2017
//
//  Created by Simon Biickert on 2023-01-29.
//

#import <Foundation/Foundation.h>
#import "AOCGrid2D.h"
#import "AOCStrings.h"

NSString * const ROOK = @"rook";
NSString * const BISHOP = @"bishop";
NSString * const QUEEN = @"queen";
NSString * const HEX = @"hex";

@implementation AOCGrid2D {
	NSMutableDictionary<AOCCoord2D *, NSObject *> *_data;
	AOCExtent2D *_extent;
}

+ (AOCGrid2D *)grid
{
	return [[AOCGrid2D alloc] init];
}

- (AOCGrid2D *)init
{
	self = [self initWithDefault:@"." adjacency:ROOK];
	return self;
}
- (AOCGrid2D *)initWithDefault:(NSObject *)value adjacency:(NSString *)rule
{
	self = [super init];
	
	_data = [NSMutableDictionary dictionary];
	_extent = nil;
	_defaultValue = value;
	_rule = rule;
	
	return self;
}

- (NSObject *)objectAtCoord:(AOCCoord2D *)coord
{
	if (coord == nil || [_data objectForKey:coord] == nil) {
		return self.defaultValue;
	}
	return [_data objectForKey:coord];
}

- (int)intAtCoord:(AOCCoord2D *)coord
{
	NSNumber *num = (NSNumber *)[self objectAtCoord:coord];
	return [num intValue];
}

- (NSString *)stringAtCoord:(AOCCoord2D *)coord
{
	NSString *str = (NSString *)[self objectAtCoord:coord];
	return str;
}


- (void)setObject:(NSObject *)value atCoord:(AOCCoord2D *)coord
{
	[_data setObject:value forKey:coord];
	if (_extent == nil) {
		_extent = [[AOCExtent2D alloc] initFrom:@[coord]];
	}
	else {
		[_extent expandToFit:coord];
	}
}

- (void)clearAtCoord:(AOCCoord2D *)coord {
	[_data removeObjectForKey:coord];
}

- (void)clearAll
{
	[_data removeAllObjects];
	_extent = nil;
}

- (AOCExtent2D *)extent
{
	return [AOCExtent2D copyOf:_extent];
}

- (NSArray<AOCCoord2D *> *)coords
{
	return [_data allKeys];
}

- (NSArray<AOCCoord2D *> *)coordsWithValue:(NSObject *)value
{
	NSMutableArray<AOCCoord2D *> *coords = [NSMutableArray array];
	for (AOCCoord2D *key in [_data allKeys]) {
		if ([[_data objectForKey:key] isEqualTo:value]) {
			[coords addObject:key];
		}
	}
	return coords;
}

- (NSArray<AOCCoord2D *> *)offsets
{
	NSMutableArray<AOCCoord2D *> *o = [NSMutableArray array];
	
	if ([self.rule isEqualToString:ROOK] || [self.rule isEqualToString:QUEEN]) {
		[o addObject:[AOCCoord2D offset:NORTH]];
		[o addObject:[AOCCoord2D offset:EAST]];
		[o addObject:[AOCCoord2D offset:SOUTH]];
		[o addObject:[AOCCoord2D offset:WEST]];
	}
	if ([self.rule isEqualToString:BISHOP] || [self.rule isEqualToString:QUEEN]) {
		[o addObject:[AOCCoord2D offset:NW]];
		[o addObject:[AOCCoord2D offset:NE]];
		[o addObject:[AOCCoord2D offset:SE]];
		[o addObject:[AOCCoord2D offset:SW]];
	}
	if ([self.rule isEqualToString:HEX]) {
		[o addObject:[AOCCoord2D offset:HN]];
		[o addObject:[AOCCoord2D offset:HNE]];
		[o addObject:[AOCCoord2D offset:HSE]];
		[o addObject:[AOCCoord2D offset:HS]];
		[o addObject:[AOCCoord2D offset:HSW]];
		[o addObject:[AOCCoord2D offset:HNW]];
	}
	
	return o;
}

- (NSArray<AOCCoord2D *> *)adjacentTo:(AOCCoord2D *)coord;
{
	NSMutableArray<AOCCoord2D *> *a = [NSMutableArray array];
	
	NSArray<AOCCoord2D *> *o = [self offsets];
	for (AOCCoord2D *offset in o) {
		[a addObject:[coord add:offset]];
	}
	
	return a;
}

- (NSArray<AOCCoord2D *> *)adjacentTo:(AOCCoord2D *)coord withValue:(NSObject *)value
{
	NSArray<AOCCoord2D *> *allAdjacent = [self adjacentTo:coord];
	NSMutableArray<AOCCoord2D *> *result = [NSMutableArray array];
	
	for (AOCCoord2D *coord in allAdjacent) {
		if ([[_data objectForKey:coord] isEqualTo:value]) {
			[result addObject:coord];
		}
	}
	
	return result;
}

- (void)print
{
	[self printInvertedY:NO withOverlay:nil];
}

- (void)printInvertedY:(BOOL)invert
{
	[self printInvertedY:invert withOverlay:nil];
}

- (void)printInvertedY:(BOOL)invert withOverlay:(NSDictionary<AOCCoord2D *, NSString *> *)overlay
{
	int startRow = _extent.min.y;
	int endRow = _extent.max.y;
	int step = 1;

	if (invert) {
		step = -1;
		int temp = startRow;
		startRow = endRow;
		endRow = temp;
	}
	
	int row = startRow;
	while (true) {
		NSString *line = @"";
		for (int col = _extent.min.x; col <= _extent.max.x; col++) {
			AOCCoord2D *c = [AOCCoord2D x:col y:row];
			NSObject *value = [self objectAtCoord:c];
			if (overlay != nil && [overlay objectForKey:c] != nil) {
				value = [overlay objectForKey:c];
			}
			value = (value == nil) ? self.defaultValue : value;
			line = [line stringByAppendingString: [NSString stringWithFormat:@"%@", value]];
		}
		[line println];
		if (row == endRow) {
			break;
		}
		row += step;
	}
}

- (NSDictionary<AOCCoord2D *, NSObject *> *)data
{
	return [_data copy];
}

- (BOOL)isEqualToGrid:(AOCGrid2D *)other
{
	return (self.defaultValue == other.defaultValue &&
			[self.rule isEqualToString:other.rule] &&
			[_data isEqualTo:other.data]);
}


@end
