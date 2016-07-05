//
//  AXManager.h
//  RESTiOS
//
//  Created by Demitri Muna on 6/22/16.
//  Copyright © 2016 Demitri Muna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AXEntry.h"

@interface AXManager : NSObject

@property (nonatomic, strong) NSDate *dateOfLastSuccessfulLoad;

- (void)fetchAbstracts;
- (NSArray*)todaysAbstracts;
- (AXEntry*)entryForID:(NSString*)archiveID;

@end
