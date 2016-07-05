//
//  AbstractCardViewController.h
//  Papr
//
//  Created by Demitri Muna on 6/23/16.
//  Copyright © 2016 Demitri Muna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractCardView.h"

@interface AbstractCardViewController : UIViewController

@property (nonatomic, strong) IBOutlet AbstractCardView *cardView;

//- (instancetype)initWithEntry:(AXEntry*)entry;
@property (nonatomic, assign) CGRect cardFrame; // card's frame is set to this value.

@end
