//
//  AbstractCardView.h
//  Papr
//
//  Created by Demitri Muna on 6/22/16.
//  Copyright © 2016 Demitri Muna. All rights reserved.
//

#import "YSLCardView.h"
#import "AXEntry.h"

@interface AbstractCardView : YSLCardView

@property (nonatomic, weak) AXEntry *entry;

@property (nonatomic, weak) IBOutlet UILabel *abstractTitle;
@property (nonatomic, weak) IBOutlet UITextView *abstractSummary;
@property (nonatomic, weak) IBOutlet UILabel *authorLabel;

@end
