//
//  FirstViewController.m
//  Papr
//
//  Created by Demitri Muna on 6/22/16.
//  Copyright © 2016 Demitri Muna. All rights reserved.
//

#import "FirstViewController.h"
#import "AppDelegate.h"
#import "AXEntry.h"
#import "AbstractCardViewController.h"
#import "AbstractCardView.h"

@interface FirstViewController ()
@property (nonatomic, weak) AXManager *axManager;
@end

@implementation FirstViewController

- (void)viewDidLoad {

	// only called once (similar to awakeFromNib:).
	
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	self.cardContainer.canDraggableDirection = YSLDraggableDirectionLeft | YSLDraggableDirectionRight;

	NSDate *date = self.axManager.dateOfLastSuccessfulLoad;
	
	NSDate *lastSuccessfulReload = self.axManager.dateOfLastSuccessfulLoad;
	if (lastSuccessfulReload == nil || lastSuccessfulReload == NSOrderedDescending) {
		
		[self.axManager fetchAbstracts];
		
	}
	
	for (AXEntry *entry in self.axManager.todaysAbstracts) {
		//NSLog(@"%@", entry.title);
	}

	[self.view.layer setNeedsLayout];
	
	// The initial view size seems to be what is in the nib. We want the layout to be applied
	// before loading the cards, but want the cards to loaded "immediately".
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self.cardContainer reloadCardContainer];
	});
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark -

- (AXManager*)axManager
{
	if (_axManager == nil) {
		_axManager = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).arXivManager;
	}
	return _axManager;
}

- (NSMutableArray*)abstractStack
{
	if (_abstractStack == nil) {
		_abstractStack = [NSMutableArray arrayWithArray:self.axManager.todaysAbstracts];
		/*
		for (AXEntry *entry in self.axManager.todaysAbstracts) {
			_abstractStack = [[NSMutableArray alloc] init];
			//if (entry.selected == nil)
				[_abstractStack addObject:entry];
		}
		*/
	}
	return _abstractStack;
}

#pragma mark -
#pragma mark YSLDraggableCardContainer data source

- (UIView *)cardContainerViewNextViewWithIndex:(NSInteger)index // view at index
{
	//DLog(@"request view index: %ld", (long)index);

	//NSLog(@"%@", NSStringFromCGRect(self.cardContainer.frame));
	
	AbstractCardViewController *cardController = [[AbstractCardViewController alloc] init];
	//cardController.cardFrame = CGRectMake(0, 0, self.cardContainer.frame.size.width, self.cardContainer.frame.size.height);
	[cardController view]; // explicitly load view
	
	cardController.cardView.frame = CGRectMake(0, 0, self.cardContainer.frame.size.width, self.cardContainer.frame.size.height);
	cardController.cardView.entry = self.abstractStack[index];
	
	return cardController.cardView;
}

- (NSInteger)cardContainerViewNumberOfViewInIndex:(NSInteger)index // count
{
	DLog(@"count request: %ld", index);

	return (NSInteger)self.abstractStack.count;
}

#pragma mark -
#pragma mark YSLDraggableCardContainer delegate

- (void)cardContainerView:(YSLDraggableCardContainer *)cardContainerView didEndDraggingAtIndex:(NSInteger)index draggableView:(UIView *)draggableView draggableDirection:(YSLDraggableDirection)draggableDirection
{
	DLog(@"");

	AbstractCardView *cardView = (AbstractCardView*)draggableView;
	
	// These are called when the view is completely swiped in the direction selected below.
	
	if (draggableDirection == YSLDraggableDirectionLeft) {
		cardView.entry.selected = [NSNumber numberWithBool:YES];
		[cardContainerView movePositionWithDirection:draggableDirection
										 isAutomatic:NO];
	}
	
	if (draggableDirection == YSLDraggableDirectionRight) {
		cardView.entry.selected = [NSNumber numberWithBool:NO];
		[cardContainerView movePositionWithDirection:draggableDirection
										 isAutomatic:NO];
	}
	
	if (draggableDirection == YSLDraggableDirectionUp) {
		[cardContainerView movePositionWithDirection:draggableDirection
										 isAutomatic:NO];
	}
}

- (void)cardContainderView:(YSLDraggableCardContainer *)cardContainderView updatePositionWithDraggableView:(UIView *)draggableView draggableDirection:(YSLDraggableDirection)draggableDirection widthRatio:(CGFloat)widthRatio heightRatio:(CGFloat)heightRatio
{
//	DLog(@"dragging");

	AbstractCardView *view = (AbstractCardView *)draggableView;
	/*
	if (draggableDirection == YSLDraggableDirectionDefault) {
		view.selectedView.alpha = 0;
	}
	
	if (draggableDirection == YSLDraggableDirectionLeft) {
		view.selectedView.backgroundColor = RGB(215, 104, 91);
		view.selectedView.alpha = widthRatio > 0.8 ? 0.8 : widthRatio;
	}
	
	if (draggableDirection == YSLDraggableDirectionRight) {
		view.selectedView.backgroundColor = RGB(114, 209, 142);
		view.selectedView.alpha = widthRatio > 0.8 ? 0.8 : widthRatio;
	}
	
	if (draggableDirection == YSLDraggableDirectionUp) {
		view.selectedView.backgroundColor = RGB(66, 172, 225);
		view.selectedView.alpha = heightRatio > 0.8 ? 0.8 : heightRatio;
	}
	 */
}

- (void)cardContainerViewDidCompleteAll:(YSLDraggableCardContainer *)container;
{
	DLog(@"last card viewed viewed");
	
	self.abstractStack = nil;
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
		[container reloadCardContainer];
	});
}

- (void)cardContainerView:(YSLDraggableCardContainer *)cardContainerView didSelectAtIndex:(NSInteger)index draggableView:(UIView *)draggableView
{
	DLog(@"index: %ld", index);
	NSLog(@"++ index : %ld",(long)index);
}


@end
