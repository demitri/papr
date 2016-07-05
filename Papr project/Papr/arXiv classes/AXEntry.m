//
//  AXEntry.m
//  RESTiOS
//
//  Created by Demitri Muna on 6/22/16.
//  Copyright © 2016 Demitri Muna. All rights reserved.
//

#import "AXEntry.h"

@implementation AXEntry

- (instancetype)init
{
	self = [super init];
	if (self != nil) {
		self.authors = [NSMutableArray array];
		self.categories = [NSMutableArray array];
	}
	return self;
}

@end
