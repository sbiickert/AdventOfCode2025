//
//  AOCCoord2D.m
//  AoC2017
//
//  Created by Simon Biickert .
//

#import <Foundation/Foundation.h>
#import "AOCCoord.h"
#include "math.h"

NSString * const NORTH = @"north";
NSString * const SOUTH = @"south";
NSString * const WEST = @"west";
NSString * const EAST = @"east";
NSString * const NW = @"nw";
NSString * const NE = @"ne";
NSString * const SW = @"sw";
NSString * const SE = @"se";
NSString * const HN = @"north";
NSString * const HS = @"south";
NSString * const HNW = @"hex_nw";
NSString * const HNE = @"hex_ne";
NSString * const HSW = @"hex_sw";
NSString * const HSE = @"hex_se";
NSString * const UP = @"up";
NSString * const DOWN = @"down";
NSString * const LEFT = @"left";
NSString * const RIGHT = @"right";

static NSDictionary<NSString *, AOCCoord2D *> *_offsets = nil;

@implementation AOCCoord2D

+ (void)initialize
{
	if (!_offsets) {
		NSMutableDictionary<NSString *, AOCCoord2D *> *dict = [NSMutableDictionary dictionary];
		[dict setObject:[AOCCoord2D x: 0 y:-1] forKey:NORTH];
		[dict setObject:[AOCCoord2D x: 0 y: 1] forKey:SOUTH];
		[dict setObject:[AOCCoord2D x:-1 y: 0] forKey:WEST];
		[dict setObject:[AOCCoord2D x: 1 y: 0] forKey:EAST];
		
		[dict setObject:[AOCCoord2D x:-1 y:-1] forKey:NW];
		[dict setObject:[AOCCoord2D x: 1 y:-1] forKey:NE];
		[dict setObject:[AOCCoord2D x:-1 y: 1] forKey:SW];
		[dict setObject:[AOCCoord2D x: 1 y: 1] forKey:SE];
		
		// See https://math.stackexchange.com/questions/2254655/hexagon-grid-coordinate-system
		// Axial coords
		// North and South are the same for square or hex coords
		[dict setObject:[AOCCoord2D x:-1 y: 0] forKey:HNW];
		[dict setObject:[AOCCoord2D x: 1 y:-1] forKey:HNE];
		[dict setObject:[AOCCoord2D x:-1 y: 1] forKey:HSW];
		[dict setObject:[AOCCoord2D x: 1 y: 0] forKey:HSE];

		[dict setObject:[AOCCoord2D x: 0 y:-1] forKey:UP];
		[dict setObject:[AOCCoord2D x: 0 y: 1] forKey:DOWN];
		[dict setObject:[AOCCoord2D x:-1 y: 0] forKey:LEFT];
		[dict setObject:[AOCCoord2D x: 1 y: 0] forKey:RIGHT];
		
		_offsets = dict;
	}
}

+ (AOCCoord2D *)origin {
	return [[AOCCoord2D alloc] initX:0 y:0];
}

+ (AOCCoord2D *)x:(int)x y:(int)y {
	return [[AOCCoord2D alloc] initX:x y:y];
}

+ (AOCCoord2D *)copyOf:(AOCCoord2D *)other {
	return [[AOCCoord2D alloc] initX:other.x y:other.y];
}

+ (AOCCoord2D *)offset:(NSString *)direction {
	if (direction == nil) {
		return nil;
	}
	return [_offsets objectForKey:direction];
}


- (AOCCoord2D *)initX:(int)x y:(int)y {
	self = [super init];
	_x = x;
	_y = y;
	return self;
}

- (int)row {
	return self.y;
}

- (int)col {
	return self.x;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"[%d,%d]", self.x, self.y];
}

- (AOCCoord2D *)add:(AOCCoord2D *)other {
	if (other == nil) {
		return [AOCCoord2D copyOf:self];
	}
	return [AOCCoord2D x:self.x + other.x y:self.y + other.y];
}

- (AOCCoord2D *)delta:(AOCCoord2D *)other {
	if (other == nil) {
		return [AOCCoord2D copyOf:self];
	}
	return [AOCCoord2D x:other.x - self.x
					   y:other.y - self.y];
}

- (AOCCoord2D *)offset:(NSString *)direction
{
	return [self add: [AOCCoord2D offset:direction]];
}


- (double)distanceTo:(AOCCoord2D *)other {
	AOCCoord2D *delta = [self delta:other];
	return sqrt(pow(delta.x, 2) + pow(delta.y, 2));
}

- (int)manhattanDistanceTo:(AOCCoord2D *)other {
	AOCCoord2D *delta = [self delta:other];
	return abs(delta.x) + abs(delta.y);
}

- (BOOL)isEqualToCoord2D:(AOCCoord2D *)other {
	if (other == nil) {
		return NO;
	}
	return self.x == other.x && self.y == other.y;
}

- (BOOL)isEqual:(nullable id)object {
	if (object == nil) {
		return NO;
	}

	if (self == object) {
		return YES;
	}

	if (![object isKindOfClass:[AOCCoord2D class]]) {
		return NO;
	}

	return [self isEqualToCoord2D:(AOCCoord2D *)object];
}

- (NSUInteger)hash {
	return [@(self.x) hash] ^ [@(self.y) hash];
}

// NSCopying (to let this be a key in NSDictionary)
- (id)copyWithZone:(NSZone *)zone
{
	AOCCoord2D *copy = [[AOCCoord2D allocWithZone:zone] initX:_x y:_y];
	return copy;
}

@end

@implementation AOCCoord3D

+ (AOCCoord3D *)origin
{
	return [[AOCCoord3D alloc] initX:0 y:0 z:0];
}

+ (AOCCoord3D *)x:(int)x y:(int)y z:(int)z
{
	return [[AOCCoord3D alloc] initX:x y:y z:z];
}

+ (AOCCoord3D *)copyOf:(AOCCoord3D *)other
{
	return [[AOCCoord3D alloc] initX:other.x y:other.y z:other.z];
}

//+ (AOCCoord2D *)offset:(NSString *)direction;

- (AOCCoord3D *)initX:(int)x y:(int)y z:(int)z
{
	self = [super init];
	_x = x;
	_y = y;
	_z = z;
	return self;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"[%d,%d,%d]", self.x, self.y, self.z];
}

- (AOCCoord3D *)add:(AOCCoord3D *)other
{
	if (other == nil) {
		return [AOCCoord3D copyOf:self];
	}
	return [AOCCoord3D x:self.x + other.x y:self.y + other.y z:self.z + other.z];
}

- (AOCCoord3D *)delta:(AOCCoord3D *)other
{
	if (other == nil) {
		return [AOCCoord3D copyOf:self];
	}
	return [AOCCoord3D x:other.x - self.x
					   y:other.y - self.y
					   z:other.z - self.z];
}
//- (AOCCoord3D *)offset:(NSString *)direction;

- (double)distanceTo:(AOCCoord3D *)other
{
	NSLog(@"AOCCoord3D::distance is not implemented yet.");
	return 0.0;
}

- (int)manhattanDistanceTo:(AOCCoord3D *)other
{
	AOCCoord3D *delta = [self delta:other];
	return abs(delta.x) + abs(delta.y) + abs(delta.z);
}

- (BOOL)isEqualToCoord3D:(AOCCoord3D *)other
{
	if (other == nil) {
		return NO;
	}
	return self.x == other.x && self.y == other.y && self.z == other.z;
}

- (BOOL)isEqual:(nullable id)object {
	if (object == nil) {
		return NO;
	}

	if (self == object) {
		return YES;
	}

	if (![object isKindOfClass:[AOCCoord3D class]]) {
		return NO;
	}

	return [self isEqualToCoord3D:(AOCCoord3D *)object];
}

- (NSUInteger)hash {
	return [@(self.x) hash] ^ [@(self.y) hash] ^ [@(self.z) hash];
}

// NSCopying (to let this be a key in NSDictionary)
- (id)copyWithZone:(NSZone *)zone
{
	AOCCoord3D *copy = [[AOCCoord3D allocWithZone:zone] initX:_x y:_y z:_z];
	return copy;
}

@end
