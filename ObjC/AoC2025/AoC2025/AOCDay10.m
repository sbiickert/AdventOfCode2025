//
//  AOCDay10.m
//  AoC2025
//

#import <Foundation/Foundation.h>
#import "AOCDay.h"
#import "AOCStrings.h"
#import "AOCMath.h"

@interface DXButton : NSObject

- (DXButton *)init:(NSArray<NSNumber *> *)indexes;
@property (readonly) NSArray<NSNumber *> *indexes;

@end


@interface DXIndicator : NSObject

- (DXIndicator *)initInState:(BOOL)isOn;
- (void)toggleState;
- (void)reset;

@property (readonly) BOOL state;

@end


@interface DXSolution : NSObject

+ (DXSolution *) solutionWithPressCount:(NSInteger)fewestPresses history:(NSArray<NSNumber *> *) presses;
- (DXSolution *) init:(NSInteger)fewestPresses presses:(NSArray<NSNumber *> *) presses;

@property (readonly) NSInteger fewestPresses;
@property (readonly) NSArray<NSNumber *> *presses;

@end


@interface DXMachine : NSObject

- (DXMachine *)init:(NSString *)defn;

@property (readonly) NSArray<DXButton *> *buttons;
@property (readonly) NSArray<DXIndicator *> *lights;
@property (readonly) NSMutableArray<NSNumber *> *joltages;
@property (readonly) NSArray<NSNumber *> *indicatorGoal; // Array of BOOL
@property (readonly) NSArray<NSNumber *> *joltageGoal;	 // Array of NSInteger

- (void)pressButton:(NSInteger)index;
- (NSInteger) indicatorParity;
- (NSInteger) joltageParity;
- (void) setButtonPresses:(NSArray<NSNumber *> *)presses;
- (void) reset;

+ (NSInteger) parity:(NSArray<NSNumber *> *)goal;
+ (DXSolution *) solveForParity:(NSInteger)goal buttons:(NSArray<DXButton *> *)buttons;

@end

@implementation AOCDay10

- (AOCDay10 *)init {
	self = [super initWithDay:10 name:@"Factory"];
	return self;
}

- (struct AOCResult)solveInputIndex:(int)index inFile:(NSString *)filename {
	struct AOCResult result = [super solveInputIndex:index inFile:filename];
	
	NSArray<NSString *> *input = [AOCInput readGroupedInputFile:filename atIndex:index];
	
	NSMutableArray<DXMachine *> *machines = [NSMutableArray array];
	for (NSString *line in input) {
		[machines addObject:[[DXMachine alloc] init:line]];
	}
	
	result.part1 = [self solvePartOne: machines];
	
	for (DXMachine *m in machines) { [m reset]; }
	
	result.part2 = [self solvePartTwo: machines];
	
	return result;
}

- (NSString *)solvePartOne:(NSArray<DXMachine *> *)machines {
	NSInteger totalPresses = 0;
	
	for (DXMachine *m in machines) {
		DXSolution *solution = [DXMachine solveForParity:[m indicatorParity]
												 buttons:m.buttons];
		totalPresses += solution.fewestPresses;
	}
	
	return [NSString stringWithFormat: @"The fewest presses was %ld", (long)totalPresses];
}

- (NSString *)solvePartTwo:(NSArray<DXMachine *> *)machines {
	
	return [NSString stringWithFormat: @"World %ld", (long)42];
}

@end

@implementation DXButton

- (DXButton *)init:(NSArray<NSNumber *> *)indexes {
	self = [super init];
	
	_indexes = indexes;
	
	return self;
}

@end
	

@implementation DXIndicator

- (DXIndicator *)initInState:(BOOL)isOn {
	self = [super init];
	
	_state = isOn;
	
	return self;
}

- (void)toggleState {
	_state = !_state;
}

- (void)reset {
	_state = NO;
}

@end


@implementation DXSolution

- (DXSolution *)init:(NSInteger)fewestPresses presses:(NSArray<NSNumber *> *)presses {
	self = [super init];
	
	_presses = presses;
	_fewestPresses = fewestPresses;
	
	return self;
}

+ (DXSolution *)solutionWithPressCount:(NSInteger)fewestPresses history:(NSArray<NSNumber *> *)presses {
	return [[DXSolution alloc] init:fewestPresses presses:presses];
}

@end
	

@implementation DXMachine
	
- (DXMachine *)init:(NSString *)defn {
	self = [super init];
	
	// example defn: [.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
	NSArray<NSString *> *matches = [defn matchPattern:@"\\[([#\\.]+)\\]\\s+([\\(\\)\\,\\d\\s]+)\\s+\\{([\\d\\,]+)\\}"
										caseSensitive:NO];
	// matches[0]: full string
	// matches[1]: indicators
	// matches[2]: buttons
	// matches[3]: joltages
	
	NSInteger numberOfIndicators = matches[1].length;
	
	// Indicators
	NSMutableArray<DXIndicator *> *lights = [NSMutableArray array];
	for (NSInteger i = 0; i < numberOfIndicators; i++) {
		[lights addObject:[[DXIndicator alloc] initInState: NO]];
	}
	_lights = lights;

	// Buttons
	NSArray<NSString *> *buttonMatches = [matches[2] matchPattern:@"\\(([\\d\\,]+)\\)"
													caseSensitive:NO];
	// Even indexes are full matches, odd are match groups
	NSMutableArray<DXButton *> *buttons = [NSMutableArray array];
	for (NSInteger i = 1; i < buttonMatches.count; i += 2) {
		NSArray<NSNumber *> *indexes = buttonMatches[i].integersFromCSV;
		[buttons addObject: [[DXButton alloc] init:indexes]];
	}
	_buttons = buttons;
	
	// Joltages
	_joltages = [NSMutableArray<NSNumber *> array];
	for (NSInteger i = 0; i < numberOfIndicators; i++) {
		[_joltages addObject:@0];
	}
	
	
	// ----- Goals -----
	// Indicators
	NSMutableArray<NSNumber *> *iGoal = [NSMutableArray array];
	for (NSString *s in matches[1].allCharacters) {
		NSNumber *b = [NSNumber numberWithBool: [s isEqualToString:@"#"]];
		[iGoal addObject:b];
	}
	_indicatorGoal = iGoal;
	
	// Joltages
	_joltageGoal = [matches[3] integersFromCSV];

	return self;
}

- (void)pressButton:(NSInteger)index {
	assert (index > 0 && index < _buttons.count);
	DXButton *b = _buttons[index];
	for (NSNumber *n in b.indexes) {
		NSInteger i = n.integerValue;
		[_lights[i] toggleState];
		NSNumber *jolt = _joltages[i];
		_joltages[i] = [NSNumber numberWithInteger: jolt.integerValue+1];
	}
}

- (NSInteger)indicatorParity {
	return [DXMachine parity:_indicatorGoal];
}

- (NSInteger)joltageParity {
	return [DXMachine parity:_joltageGoal];
}

+ (NSInteger)parity:(NSArray<NSNumber *> *)goal {
	NSInteger p = 0;
	for (NSInteger i = 0; i < goal.count; i++) {
		NSNumber *n = goal[i];
		if (n.integerValue % 2 == 1) {
			p += [AOCMath powerOfBase:2 exponent:i];
		}
	}
	return p;
}

- (void)setButtonPresses:(NSArray<NSNumber *> *)presses {
	for (NSInteger i = 0; i < presses.count; i++) {
		NSInteger pressCount = presses[i].integerValue;
		for (NSInteger c = 0; c < pressCount; c++) {
			[self pressButton:i];
		}
	}
}

+ (DXSolution *)solveForParity:(NSInteger)goal buttons:(NSArray<DXButton *> *)buttons {
	if (goal == 0) {
		return [DXSolution solutionWithPressCount:0 history:nil];
	}
	
	NSMutableArray<NSNumber *> *noHistory = [NSMutableArray array];
	for (NSInteger i = 0; i < buttons.count; i++) {[noHistory addObject:@0];}
	
	NSDictionary<NSNumber *, NSArray<NSNumber *> *> *data = [NSDictionary dictionaryWithObject:noHistory forKey:@0];
	NSMutableSet<NSNumber *> *evaluated = [NSMutableSet set];
	NSInteger fewestPresses = 1000000;
	NSInteger round = 1;
	
	while (data.count > 0) {
		NSMutableDictionary<NSNumber *, NSArray<NSNumber *> *> *nextData = [NSMutableDictionary dictionaryWithObject:noHistory forKey:@0];
		
		for (NSNumber *state in data) {
			NSArray<NSNumber *> *history = [data objectForKey:state];
			[evaluated addObject:state];
			
			for (NSInteger i = 0; i < buttons.count; i++) {
				DXButton *button = buttons[i];
				if (history[i].integerValue == 0) { // Can't push a button twice
					NSInteger iState = state.integerValue;
					NSMutableArray<NSNumber *> *newHistory = history.mutableCopy;
					
					for (NSNumber *n in button.indexes) {
						NSInteger lightIndex = n.integerValue;
						iState = iState ^ [AOCMath powerOfBase:2 exponent:lightIndex];
					}
					newHistory[i] = [NSNumber numberWithInteger: newHistory[i].integerValue + 1];

					NSNumber *newState = [NSNumber numberWithInteger:iState];
					if (newState.integerValue == goal) {
						fewestPresses = round;
						return [DXSolution solutionWithPressCount:fewestPresses history:newHistory];
					}
					else if ([evaluated containsObject:newState] == NO) {
						[nextData setObject:newHistory forKey:newState];
					}
				}
			}
		}
		
		data = nextData;
		round ++;
	}
	
	return [DXSolution solutionWithPressCount:fewestPresses history:nil];
}

- (void)reset {
	for (DXIndicator *light in _lights) {
		[light reset];
	}
	for (NSInteger i = 0; i < _joltages.count; i++) {
		[_joltages setObject:@0 atIndexedSubscript:i];
	}
}

@end
