//
//  AbstractCardViewController.m
//  Papr
//
//  Created by Demitri Muna on 6/23/16.
//  Copyright © 2016 Demitri Muna. All rights reserved.
//

#import "AbstractCardViewController.h"

@interface AbstractCardViewController ()

@end

@implementation AbstractCardViewController

/*
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self != nil) {

	}
	return self;
}
*/

- (instancetype)init
{
	return [self initWithNibName:self.nibName bundle:nil];
}

- (NSString*)nibName { return @"AbstractCardView"; }

- (void)viewDidLoad {
    [super viewDidLoad];
	
	//self.cardView.frame = self.cardFrame;

/*	UIBezierPath *maskPath;
	maskPath = [UIBezierPath bezierPathWithRoundedRect:_imageView.bounds
									 byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
										   cornerRadii:CGSizeMake(7.0, 7.0)];
*/
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
