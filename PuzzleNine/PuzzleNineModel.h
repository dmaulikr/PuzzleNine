//
//  PuzzleNineModel.h
//  PuzzleNine
//
//  Created by Jyothidhar Pulakunta on 4/22/14.
//  Copyright (c) 2014 Jyothidhar Pulakunta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PuzzleNineModel : NSObject

-(NSDictionary *) positionForTiles:(float) x y:(float)y side:(float)side spacing:(float)space;
-(BOOL) isValidMove:(NSNumber *) rectNum space:(float) space;
-(NSValue *) positionForTile:(NSNumber *)tileNumber;
-(void) setPositionForTile:(NSNumber *)tileNumber value:(NSValue *)value;

@end
