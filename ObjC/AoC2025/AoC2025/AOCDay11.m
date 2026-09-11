//
//  AOCDay11.m
//  AoC2025
//

#import <Foundation/Foundation.h>
#import "AOCDay.h"

@interface DXIDevice : NSObject

- (DXIDevice *)init:(NSString *)defn;

@property (readonly) NSString *name;
@property (readonly) NSSet<NSString *> *outputs;
@property (readonly) NSMutableSet<NSString *> *inputs;

@end

@interface AOCDay11 ()

@property (nonatomic, strong) NSDictionary<NSString *, DXIDevice *> *devices;

@end

@implementation AOCDay11

- (AOCDay11 *)init {
	self = [super initWithDay:11 name:@"Reactor"];
	return self;
}

- (struct AOCResult)solveInputIndex:(int)index inFile:(NSString *)filename {
	struct AOCResult result = [super solveInputIndex:index inFile:filename];
	
	NSArray<NSString *> *input = [AOCInput readGroupedInputFile:filename atIndex:index];
	
	_devices = [self parseDevices:input];
	
	result.part1 = [self solvePartOne];
	result.part2 = [self solvePartTwo: input];
	
	return result;
}

- (NSString *)solvePartOne {
	DXIDevice *you = self.devices[@"you"];
	NSMutableDictionary<NSString *, NSNumber *> *cache = [NSMutableDictionary dictionaryWithObject:@1 forKey:@"out"];
	
	NSInteger pathCount = [self countPathsTo:@"out" from:you cache:cache];
	
	return [NSString stringWithFormat: @"There are %ld paths from you to out", (long)pathCount];
}

- (NSString *)solvePartTwo:(NSArray<NSString *> *)input {
	
	return [NSString stringWithFormat: @"World %ld", (long)42];
}

- (NSInteger) countPathsTo:(NSString *)goal
					  from:(DXIDevice *)device
					 cache:(NSMutableDictionary<NSString *, NSNumber *> *)cache {
	if (cache[device.name]) {
		return cache[device.name].integerValue;
	}
	
	NSInteger pathCount = 0;
	for (NSString *outputName in device.outputs) {
		DXIDevice *output = self.devices[outputName];
		pathCount += [self countPathsTo:goal from:output cache:cache];
	}
	
	[cache setObject:[NSNumber numberWithInteger:pathCount] forKey:device.name];
	return pathCount;
}

- (NSDictionary<NSString *, DXIDevice *> *)parseDevices:(NSArray<NSString *> *)input {
	NSMutableDictionary<NSString *, DXIDevice *> *result = [NSMutableDictionary dictionary];
	
	for (NSString *line in input) {
		DXIDevice *d = [[DXIDevice alloc] init:line];
		[result setObject:d forKey:d.name];
	}
	DXIDevice *out = [[DXIDevice alloc] init:@"out: "];
	[result setObject:out forKey:out.name];
	
	for (NSString *key in result) {
		DXIDevice *d = result[key];
		for (NSString *output in d.outputs) {
			DXIDevice *outputDevice = [result objectForKey:output];
			[outputDevice.inputs addObject:d.name];
		}
	}
	
	return result;
}

@end



@implementation DXIDevice

- (DXIDevice *)init:(NSString *)defn {
	self = [super init];
	
	NSArray<NSString *> *parts = [defn componentsSeparatedByString:@": "];
	_name = parts.firstObject;
	if ([parts.lastObject isEqualToString:@""]) {
		_outputs = nil;
	}
	else {
		_outputs = [NSSet setWithArray: [parts.lastObject componentsSeparatedByString:@" "]];
	}
	_inputs = [NSMutableSet set];
	
	return self;
}

@end
