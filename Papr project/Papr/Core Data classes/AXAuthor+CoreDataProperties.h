//
//  AXAuthor+CoreDataProperties.h
//  Papr
//
//  Created by Demitri Muna on 7/4/16.
//  Copyright © 2016 Demitri Muna. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "AXAuthor.h"

NS_ASSUME_NONNULL_BEGIN

@interface AXAuthor (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *index;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSSet<AXEntry *> *entries;

@end

@interface AXAuthor (CoreDataGeneratedAccessors)

- (void)addEntriesObject:(AXEntry *)value;
- (void)removeEntriesObject:(AXEntry *)value;
- (void)addEntries:(NSSet<AXEntry *> *)values;
- (void)removeEntries:(NSSet<AXEntry *> *)values;

@end

NS_ASSUME_NONNULL_END
