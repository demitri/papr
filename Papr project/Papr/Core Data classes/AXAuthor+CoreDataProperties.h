//
//  AXAuthor+CoreDataProperties.h
//  Papr
//
//  Created by Demitri Muna on 6/22/16.
//  Copyright © 2016 Demitri Muna. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "AXAuthor.h"

NS_ASSUME_NONNULL_BEGIN

@interface AXAuthor (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *entries;

@end

@interface AXAuthor (CoreDataGeneratedAccessors)

- (void)addEntriesObject:(NSManagedObject *)value;
- (void)removeEntriesObject:(NSManagedObject *)value;
- (void)addEntries:(NSSet<NSManagedObject *> *)values;
- (void)removeEntries:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
