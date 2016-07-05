//
//  FirstViewController.h
//  Papr
//
//  Created by Demitri Muna on 6/22/16.
//  Copyright © 2016 Demitri Muna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSLDraggableCardContainer.h"

@interface FirstViewController : UIViewController

@property (nonatomic, weak) IBOutlet YSLDraggableCardContainer *cardContainer;
@property (nonatomic, strong) NSMutableArray *abstractStack;
@end

