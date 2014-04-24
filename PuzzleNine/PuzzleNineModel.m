//
//  PuzzleNineModel.m
//  PuzzleNine
//
//  Created by Jyothidhar Pulakunta on 4/22/14.
//  Copyright (c) 2014 Jyothidhar Pulakunta. All rights reserved.
//

#import "PuzzleNineModel.h"

const int NumTiles = 9;

@interface PuzzleNineModel()
@property (nonatomic, strong) NSMutableDictionary *tilePositions;
@end

@implementation PuzzleNineModel

-(id) init
{
    self = [super init];
    if(self) {
		_tilePositions = [NSMutableDictionary dictionaryWithCapacity:NumTiles];
    }
    return self;
}

-(NSDictionary *) positionForTiles:(float) x y:(float)y side:(float)side spacing:(float)space {
	NSMutableArray *positions = [self generatePositions:x y:y side:side spacing:space];
	for (int i=0; i<NumTiles; i++) {
		int selIndex = arc4random() % [positions count];
		NSValue *selPos = [positions objectAtIndex:selIndex];
		[_tilePositions setObject:selPos forKey:[NSNumber numberWithInt:i]];
		
		[positions removeObjectAtIndex:selIndex];
	}
	return _tilePositions;
}

-(NSMutableArray *) generatePositions:(float) x y:(float)y side:(float)side spacing:(float)space {
	NSMutableArray *generatedPos = [[NSMutableArray alloc] initWithCapacity:NumTiles];
	float X = x;
	float Y = y;
	
	for (int i=0; i<NumTiles; i++) {
		CGRect rect = CGRectMake(X, Y, side, side);
		[generatedPos addObject:[NSValue valueWithCGRect:rect]];
		if ((i+1) % 3 == 0) {
			Y += side + space;
			X = x;
		} else {
			X += side + space;
		}
	}
	return generatedPos;
}

-(BOOL) isValidMove:(NSNumber *) rectNum space:(float) space{
	CGRect rect = [[_tilePositions objectForKey:rectNum] CGRectValue];
	NSValue *ninePosition = [_tilePositions objectForKey:[NSNumber numberWithInt:8]];
	CGRect nine = [ninePosition CGRectValue];
	
	CGRect paddedRectLeft = CGRectMake(nine.origin.x, nine.origin.y, nine.size.width + space + 1, nine.size.height);
	CGRect paddedRectTop = CGRectMake(nine.origin.x, nine.origin.y, nine.size.width, nine.size.height + space + 1);
	CGRect paddedRectRight = CGRectMake(nine.origin.x - space-1, nine.origin.y, nine.size.width + space + 1, nine.size.height);
	CGRect paddedRectBottom = CGRectMake(nine.origin.x, nine.origin.y-space -1 , nine.size.width, nine.size.height + space + 1);
	
	if (CGRectIntersectsRect(rect, paddedRectLeft) ||
		CGRectIntersectsRect(rect, paddedRectRight) ||
		CGRectIntersectsRect(rect, paddedRectBottom) ||
		CGRectIntersectsRect(rect, paddedRectTop)) {
		return YES;
	}
	
	return NO;
}

-(NSValue *) positionForTile:(NSNumber *)tileNumber {
	return [_tilePositions objectForKey:tileNumber];
}

-(void) setPositionForTile:(NSNumber *)tileNumber value:(NSValue *)value {
	[_tilePositions setObject:value forKey:tileNumber];
}

@end
