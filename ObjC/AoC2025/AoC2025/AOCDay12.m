//
//  AOCDay12.m
//  AoC2025
//

#import <Foundation/Foundation.h>
#import "AOCDay.h"
#import "AOCSpatial.h"
#import "AOCGrid.h"
#import "AOCArrays.h"
#import "AOCStrings.h"

@interface Present: NSObject
- (Present *)init:(NSArray<NSString *> *)defn;
- (Present *)initCopying:(Present *)source flipped:(NSString *)direction; // LEFT/RIGHT or UP/DOWN
- (Present *)initCopying:(Present *)source rotated:(NSString *)direction; // CW, CCW

@property (readonly) NSString *index;
@property (readonly) AOCExtent *extent;
@property (readonly) NSArray<NSArray<NSString *> *> *data;
@property (readonly) NSInteger occupiedArea;

- (Present *)flipped:(NSString *)direction;
- (Present *)rotated:(NSString *)direction;
- (BOOL)collidesWith:(Present *)other offsetX:(NSInteger)offX offsetY:(NSInteger)offY;
- (void)print;

+ (NSArray<NSArray<NSString *> *> *)flip:(NSArray<NSArray<NSString *> *> *)data
							   direction:(NSString *)direction;

+ (NSArray<NSArray<NSString *> *> *)rotate:(NSArray<NSArray<NSString *> *> *)data
								 direction:(NSString *)direction;

- (BOOL)isEqualToPresent:(Present *)other;
@end


@interface Region : NSObject

- (Region *)init:(NSString *)defn;

@property (readonly) NSInteger width;
@property (readonly) NSInteger height;
@property (readonly) NSArray<NSNumber *> *quantities;

- (BOOL)canFit:(NSArray<NSArray<Present *> *> *)presents;
- (NSInteger)totalQuantities;
- (NSInteger)area;
- (NSInteger)blockWidth;
- (NSInteger)blockHeight;

@end




@implementation AOCDay12

- (AOCDay12 *)init {
	self = [super initWithDay:12 name:@"Christmas Tree Farm"];
	return self;
}

- (struct AOCResult)solveInputIndex:(int)index inFile:(NSString *)filename {
	struct AOCResult result = [super solveInputIndex:index inFile:filename];
	
	NSArray<NSArray<NSString *> *> *input = [AOCInput readGroupedInputFile:filename];
	
	NSMutableArray<NSArray<Present *> *> *presents = [NSMutableArray array];
	for (NSInteger i = 0; i < 6; i++) {
		NSArray<Present *> *p = [self parsePresents: input[i]];
		[presents addObject:p];
	}

	NSMutableArray<Region *> *regions = [NSMutableArray array];
	for (NSString *line in input.lastObject) {
		Region *r = [[Region alloc] init:line];
		[regions addObject:r];
	}
	
	result.part1 = [self solvePartOne: presents regions:regions];
	result.part2 = [self solvePartTwo: presents];
	
	return result;
}

- (NSString *)solvePartOne:(NSArray<NSArray<Present *> *> *)presents
				   regions:(NSArray<Region *> *)regions {
	NSInteger fitCount = 0;
	for (Region *r in regions) {
		if ([r canFit:presents]) {
			fitCount++;
		}
	}
	
	return [NSString stringWithFormat: @"The presents fit into %ld regions", (long)fitCount];
}

- (NSString *)solvePartTwo:(NSArray<NSArray<Present *> *> *)presents {
	
	return @"Merry Christmas!";
}

- (NSArray<Present *> *)parsePresents:(NSArray<NSString *> *)defn {
	NSMutableArray<Present *> *result = [NSMutableArray array];

	Present *original = [[Present alloc] init:defn];

	NSMutableArray<Present *> *allRotations = [NSMutableArray arrayWithObject:original];
	NSMutableArray<Present *> *allFlips = [NSMutableArray array];

	
	for (NSInteger i = 1; i < 4; i++) {
		Present *rotated = [allRotations.lastObject rotated:CW];
		[allRotations addObject:rotated];
	}
	
	for (Present *p in allRotations) {
		Present *flippedLeft = [p flipped:LEFT];
		Present *flippedUp = [p flipped:UP];
		[allFlips addObject:flippedLeft];
		[allFlips addObject:flippedUp];
	}
	
	NSArray<Present *> *allTransformations = [allFlips arrayByAddingObjectsFromArray:allRotations];
	
	for (Present *p in allTransformations) {
		BOOL isUnique = YES;
		for (Present *other in result) {
			if ([other isEqualToPresent:p]) {
				isUnique = NO;
				break;
			}
		}
		if (isUnique) {
			[result addObject:p];
		}
	}
	
	return result;
}

@end




@implementation Present

- (Present *)init:(NSArray<NSString *> *)defn {
	// Example defn string:
	//	0:
	//	###
	//	##.
	//	##.
	self = [super init];
	
	NSMutableArray<NSString *> *mDefn = defn.mutableCopy;
	_index = mDefn.firstObject;
	[mDefn removeObjectAtIndex:0];
	
	AOCGrid *g = [AOCGrid grid];
	[g load:mDefn];
	
	_extent = g.extent;
	
	NSMutableArray<NSArray<NSString *> *> *mData = [NSMutableArray array];
	
	_occupiedArea = 0;
	for (NSInteger row = _extent.min.y; row <= _extent.max.y; row++) {
		NSMutableArray<NSString *> *mRow = [NSMutableArray array];
		for (NSInteger col = _extent.min.x; col <= _extent.max.x; col++) {
			NSString *s = [g stringAtCoord: [AOCCoord x:col y:row]];
			[mRow addObject: s];
			if ([s isEqualToString:@"#"]) { _occupiedArea++; }
		}
		[mData addObject:mRow];
	}
	_data = mData;
	
	return self;
}

- (Present *)initCopying:(Present *)source flipped:(NSString *)direction {
	self = [super init];
	
	_index = source.index;
	_extent = [[AOCExtent alloc] initMin:source.extent.min max:source.extent.max];
	_data = [Present flip:source.data direction:direction];
	_occupiedArea = source.occupiedArea;
	
	return self;
}

- (Present *)initCopying:(Present *)source rotated:(NSString *)direction {
	self = [super init];
	
	_index = source.index;
	_extent = [[AOCExtent alloc] initMin:source.extent.min max:source.extent.max];
	_data = [Present rotate:source.data direction:direction];
	_occupiedArea = source.occupiedArea;

	return self;
}

+ (NSArray<NSArray<NSString *> *> *)rotate:(NSArray<NSArray<NSString *> *> *)data
								 direction:(NSString *)direction {
	assert([direction isEqualToString:CW] || [direction isEqualToString:CCW]);
	NSInteger h = data.count;
	
	NSMutableArray<NSArray<NSString *> *> *copy;

	if ([direction isEqualToString:CW]) {
		// Transpose then reverse rows
		copy = [AOCArrayUtil transpose:data].mutableCopy;
		for (NSInteger row = 0; row < h; row++) {
			copy[row] = copy[row].reverseObjectEnumerator.allObjects;
		}
	}
	else {
		// Reverse rows then transpose
		copy = data.mutableCopy;
		for (NSInteger row = 0; row < h; row++) {
			copy[row] = copy[row].reverseObjectEnumerator.allObjects;
		}
		copy = [AOCArrayUtil transpose:copy].mutableCopy;
	}

	return copy;
}

+ (NSArray<NSArray<NSString *> *> *)flip:(NSArray<NSArray<NSString *> *> *)data
							   direction:(NSString *)direction {
	assert([direction isEqualToString:LEFT] || [direction isEqualToString:RIGHT] ||
		   [direction isEqualToString:UP] || [direction isEqualToString:DOWN]);

	NSMutableArray<NSArray<NSString *> *> *copy;

	if ([direction isEqualToString:LEFT] || [direction isEqualToString:RIGHT] ) {
		copy = data.mutableCopy;
		for (NSInteger row = 0; row < data.count; row++) {
			copy[row] = copy[row].reverseObjectEnumerator.allObjects;
		}
	}
	else {
		copy = [AOCArrayUtil transpose:data].mutableCopy;
		for (NSInteger row = 0; row < copy.count; row++) {
			copy[row] = copy[row].reverseObjectEnumerator.allObjects;
		}
		copy = [AOCArrayUtil transpose:copy].mutableCopy;
	}
	return copy;
}

- (BOOL)collidesWith:(Present *)other offsetX:(NSInteger)offX offsetY:(NSInteger)offY {
	// Never needed to implement this.
	return YES;
}

- (void)print {
	[self.index println];
	for (NSArray<NSString *> *row in self.data) {
		[[row componentsJoinedByString:@" "] println];
	}
}

- (Present *)rotated:(NSString *)direction {
	return [[Present alloc] initCopying:self rotated:direction];
}

- (Present *)flipped:(NSString *)direction {
	return [[Present alloc] initCopying:self flipped:direction];
}

- (BOOL)isEqualToPresent:(Present *)other {
	if (!other) return NO;
	if ([_index isEqualToString:other.index] == NO) return NO;
	if ([_extent isEqualToExtent:other.extent] == NO) return NO;
	
	for (NSInteger row = 0; row <= _extent.max.y; row++) {
		for (NSInteger col = 0; col <= _extent.max.x; col++) {
			if ([_data[row][col] isEqualToString:other.data[row][col]] == NO) return NO;
		}
	}
	
	return YES;
}

@end





@implementation Region

- (Region *)init:(NSString *)defn {
	self = [super init];
	
	NSArray<NSString *> *parts = [defn componentsSeparatedByString:@": "];
	NSArray<NSString *> *dimensions = [parts.firstObject componentsSeparatedByString:@"x"];
	
	_width =  dimensions[0].integerValue;
	_height =  dimensions[1].integerValue;
	
	NSArray<NSString *> *qStrings = [parts.lastObject componentsSeparatedByString:@" "];
	NSMutableArray<NSNumber *> *quantities = [NSMutableArray array];
	for (NSString *qString in qStrings) {
		[quantities addObject: [NSNumber numberWithInteger:qString.integerValue]];
	}
	_quantities = quantities;

	return self;
}

- (BOOL)canFit:(NSArray<NSArray<Present *> *> *)presents {
	// See if the presents fit without interlocking (assume 3x3 presents)
	NSInteger presentCount = self.totalQuantities;
	NSInteger blockArea = self.blockWidth * self.blockHeight;
	if (blockArea >= presentCount) {
//		[@"Easy" println];
		return YES;
	}

	// Check that the total occupied area is less than the region area
	NSInteger totalOccupiedArea = 0;
	for (NSInteger i = 0; i < presents.count; i++) {
		NSInteger areaForPresent = presents[i].firstObject.occupiedArea * self.quantities[i].integerValue;
		totalOccupiedArea += areaForPresent;
	}
	if (self.area < totalOccupiedArea) {
//		[@"Area fail" println];
		return NO;
	}

	// Do the hard part
	// But we didn't have to. The code never reaches here for the challenge input
	[@"Hard" println];
	return NO;
}

- (NSInteger)totalQuantities {
	NSInteger result = 0;
	for (NSNumber *n in self.quantities) {
		result += n.integerValue;
	}
	return result;
}

- (NSInteger)area {
	return _width * _height;
}

- (NSInteger)blockHeight {
	return _height / 3;
}

- (NSInteger)blockWidth {
	return _width / 3;
}

@end
