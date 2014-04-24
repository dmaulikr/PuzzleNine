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
const int StartX = 60;
const int StartY = 100;
const int Space = 10;

@interface PuzzleNineViewController ()
@property (nonatomic, strong) NSMutableDictionary *positions;
@property (nonatomic, strong) PuzzleNineModel *puzzleModel;
@end

@implementation PuzzleNineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	_positions = [NSMutableDictionary dictionaryWithCapacity:10];
	_puzzleModel = [PuzzleNineModel new];

	[self placeViews];
}

-(void) placeViews {
	NSDictionary *positions =[_puzzleModel positionForTiles:StartX
														  y:StartY
													   side:PuzzleSize
													spacing:Space];
	for (int i=[positions count]-2; i>=0; i--) {
		NSValue *rect = [positions objectForKey:[NSNumber numberWithInt:i]];
		UIView *view = [[UIView alloc] initWithFrame:[rect CGRectValue]];
		if (i != 8) {
			view.backgroundColor = [UIColor colorWithRed:52.0/255.0 green:170.0/255.0 blue:220.0/255.0 alpha:1];
			
			UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(25, 20, 30, 30)];
			label.text = [NSString stringWithFormat:@"%d", i+1];
			label.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
			label.font = [UIFont fontWithName:@"DamascusBold" size:17.0];
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
		BOOL canAnimate = [_puzzleModel isValidMove:[NSNumber numberWithInt:gestureRecognizer.view.tag - 1]
											  space:Space];
		//Animate the view to the new position
		if (canAnimate) {
			[UIView animateWithDuration:1 animations:^{
				NSValue *temp = [_puzzleModel positionForTile:[NSNumber numberWithInt:8]];
				NSValue *oldValue = [_puzzleModel positionForTile:[NSNumber numberWithInt:gestureRecognizer.view.tag - 1]];
				
				[_puzzleModel setPositionForTile:[NSNumber numberWithInt:gestureRecognizer.view.tag - 1] value:temp];
				[_puzzleModel setPositionForTile:[NSNumber numberWithInt:8] value:oldValue];
				
				gestureRecognizer.view.frame = [temp CGRectValue];
			}];
		}
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
