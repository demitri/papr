//
//  AXEntry+CoreDataProperties.h
//  Papr
//
//  Created by Demitri Muna on 7/4/16.
//  Copyright © 2016 Demitri Muna. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "AXEntry.h"

NS_ASSUME_NONNULL_BEGIN

@interface AXEntry (CoreDataProperties)

@property (nullable, nonatomic, retain) id abstractLink;
@property (nullable, nonatomic, retain) NSString *archiveID;
@property (nullable, nonatomic, retain) NSDate *datePublished;
@property (nullable, nonatomic, retain) NSDate *dateUpdated;
@property (nullable, nonatomic, retain) id doiLink;
@property (nullable, nonatomic, retain) id pdfLink;
@property (nullable, nonatomic, retain) NSNumber *selected;
@property (nullable, nonatomic, retain) NSString *summary;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSSet<AXAuthor *> *authors;
@property (nullable, nonatomic, retain) NSSet<AXCategory *> *categories;

@end

@interface AXEntry (CoreDataGeneratedAccessors)

- (void)addAuthorsObject:(AXAuthor *)value;
- (void)removeAuthorsObject:(AXAuthor *)value;
- (void)addAuthors:(NSSet<AXAuthor *> *)values;
- (void)removeAuthors:(NSSet<AXAuthor *> *)values;

- (void)addCategoriesObject:(AXCategory *)value;
- (void)removeCategoriesObject:(AXCategory *)value;
- (void)addCategories:(NSSet<AXCategory *> *)values;
- (void)removeCategories:(NSSet<AXCategory *> *)values;

@end

NS_ASSUME_NONNULL_END
