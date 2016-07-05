//
//  AXEntry.h
//  RESTiOS
//
//  Created by Demitri Muna on 6/22/16.
//  Copyright © 2016 Demitri Muna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AXAuthor.h"

@interface AXEntry : NSObject

@property (nonnull, nonatomic, strong) NSMutableArray<AXAuthor*> *authors;
@property (nullable, nonatomic, strong) NSDate *datePublished;
@property (nullable, nonatomic, copy) NSString *summary;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, strong) NSDate *dateUpdated;
@property (nullable, nonatomic, strong) NSMutableArray *categories;
@property (nullable, nonatomic, copy) NSString *archiveID;

// links
@property (nullable, strong) NSURL *abstractLink; // "alternate" link : rel = alternate
@property (nullable, strong) NSURL *pdfLink;		 // rel = related, title = pdf, type = "application/pdf, type = "text/html"
@property (nullable, strong) NSURL *doiLink;		 // title = doi

// Papr properties
// ---------------
@property (nonatomic, assign) BOOL selected;


@end
