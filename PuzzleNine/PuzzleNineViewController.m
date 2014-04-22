//
//  PuzzleNineViewController.m
//  PuzzleNine
//
//  Created by Jyothidhar Pulakunta on 4/21/14.
//  Copyright (c) 2014 Jyothidhar Pulakunta. All rights reserved.
//

#import "PuzzleNineViewController.h"
#import "PuzzleNineModel.h"


const int PuzzleSize = 60;
const int StartX = 75;
const int StartY = 100;
const int Space = 10;

@interface PuzzleNineViewController ()
@property (nonatomic, strong) NSMutableDictionary *positions;
@end

@implementation PuzzleNineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	_positions = [NSMutableDictionary dictionaryWithCapacity:10];
	[self placeViews];
}

-(void) placeViews {
	NSDictionary *positions =[[PuzzleNineModel sharedInstance] positionForTiles:StartX
																			  y:StartY
																		   side:PuzzleSize
																		spacing:Space];
	for (int i=[positions count]-2; i>=0; i--) {
		NSValue *rect = [positions objectForKey:[NSNumber numberWithInt:i]];
		UIView *view = [[UIView alloc] initWithFrame:[rect CGRectValue]];
		if (i == 8) {
			view.backgroundColor = [UIColor yellowColor];
		} else {
			view.backgroundColor = [UIColor greenColor];
			
			UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 30, 30)];
			label.text = [NSString stringWithFormat:@"%d", i+1];
			[view addSubview:label];
			
			UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
																				  action:@selector(handleGesture:)];
			tap.enabled = YES;
			tap.numberOfTapsRequired = 1;
			view.tag = i + 1;
			[view addGestureRecognizer:tap];
			[view setUserInteractionEnabled:YES];
		}
		
		[self.view addSubview:view];
	}
}

- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer; {
	if (gestureRecognizer.view.tag >= 1 && gestureRecognizer.view.tag <= 8) {
		//Check if the view can animate
		BOOL canAnimate = [[PuzzleNineModel sharedInstance] isValidMove:[NSNumber numberWithInt:gestureRecognizer.view.tag - 1]
																  space:Space];
		//Animate the view to the new position
		if (canAnimate) {
			[UIView animateWithDuration:2 animations:^{
				NSValue *temp = [[PuzzleNineModel sharedInstance] positionForTile:[NSNumber numberWithInt:8]];
				NSValue *oldValue = [[PuzzleNineModel sharedInstance] positionForTile:[NSNumber numberWithInt:gestureRecognizer.view.tag - 1]];
				
				[[PuzzleNineModel sharedInstance] setPositionForTile:[NSNumber numberWithInt:gestureRecognizer.view.tag - 1] value:temp];
				[[PuzzleNineModel sharedInstance] setPositionForTile:[NSNumber numberWithInt:8] value:oldValue];
				
				gestureRecognizer.view.frame = [temp CGRectValue];
			}];
		}
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
