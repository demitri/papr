//
//  AXEntry.h
//  Papr
//
//  Created by Demitri Muna on 6/22/16.
//  Copyright © 2016 Demitri Muna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AXAuthor, AXCategory;

NS_ASSUME_NONNULL_BEGIN

@interface AXEntry : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@property (nonatomic, readonly) NSArray* sortedAuthors;
@property (nonatomic, readonly) NSString* authorListString;

@end

NS_ASSUME_NONNULL_END

#import "AXEntry+CoreDataProperties.h"
