//
//  AXEntry.m
//  Papr
//
//  Created by Demitri Muna on 6/22/16.
//  Copyright © 2016 Demitri Muna. All rights reserved.
//

#import "AXEntry.h"
#import "AXAuthor.h"
#import "AXCategory.h"

@implementation AXEntry

// Insert code here to add functionality to your managed object subclass

- (NSArray*)sortedAuthors
{
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"index" ascending:YES];
	return [self.authors sortedArrayUsingDescriptors:@[sortDescriptor]];
}

- (NSString*)authorListString
{
	NSMutableArray *authorNames = [NSMutableArray array];
	for (AXAuthor *author in self.sortedAuthors) {
		[authorNames addObject:author.name];
	}
	
	return [authorNames componentsJoinedByString:@", "];
}

@end
