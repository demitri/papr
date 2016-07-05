//
//  AXManager.m
//  RESTiOS
//
//  Created by Demitri Muna on 6/22/16.
//  Copyright © 2016 Demitri Muna. All rights reserved.
//

#import "AXManager.h"
#import "AppDelegate.h"
#import "AXEntry.h"
#import "AXAuthor.h"
#import "AXCategory.h"
#import "XMLReader.h"

@interface AXManager()
@property (nonatomic, weak) AppDelegate *appDelegate;
@end

#pragma mark -

@implementation AXManager

- (AppDelegate*)appDelegate
{
	if (_appDelegate == nil) {
		_appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	}
	return _appDelegate;
}

- (NSDate*)dateOfLastSuccessfulLoad
{
	if (_dateOfLastSuccessfulLoad == nil) {
		
		AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
		[appDelegate.mainManagedObjectContext performBlockAndWait:^{
			
			// define arXiv "day"
			// ------------------
			// today:
			NSDateFormatter *isoDateFormatter = appDelegate.iso8601DateFormatter;
			NSDate *today = [NSDate date];
			NSCalendar *gregorian = [[NSCalendar alloc]
									 initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
			NSDateComponents *components = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond )
														fromDate:today];
			NSInteger day = [components day];
			
			/*
			NSDateComponents *dateComps = [[NSDateComponents alloc] init];
			comps.day = ;
			comps.month = ;
			comps.year = ;
			NSDate *todayStart = [NSDate date]
			 */
			
			NSDate *day0 = [isoDateFormatter dateFromString:@"2016-06-19T16:00:00"];
			NSDate *day1 = [isoDateFormatter dateFromString:@"2016-06-21T16:00:00"];
			
			NSError *error;
			NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass(AXEntry.class)];
			fetchRequest.predicate = [NSPredicate predicateWithFormat:@"datePublished > %@ AND datePublished < %@", day0, day1];
			fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"datePublished" ascending:NO]];
			NSArray<AXEntry*> *foundFiles = [appDelegate.mainManagedObjectContext executeFetchRequest:fetchRequest error:&error];
			
			if (foundFiles.count > 0) {
				_dateOfLastSuccessfulLoad = foundFiles.firstObject.datePublished;
			}
			
			DLog(@"%@", foundFiles);
		}];
		
	}
	return _dateOfLastSuccessfulLoad;
}

- (void)fetchAbstracts
{
	AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	
	
	NSStringEncoding stringEncoding;
	NSError *error = nil;
	NSString *urlString = @"https://export.arxiv.org/api/query?search_query=submittedDate:[20160620200000+TO+20160621200000]+AND+cat:astro-ph*&start=0&max_results=500";
	//	NSString *urlString = @"https://export.arxiv.org/rss/astro-ph";
	NSURL *url = [NSURL URLWithString:urlString];
	
	NSString *test = [NSString stringWithContentsOfURL:url
										  usedEncoding:&stringEncoding
												 error:&error];
	/*
	 NSURLRequest *request = [NSURLRequest requestWithURL:url];
	 NSURLConnection *connection = [NSURLConnection connectionWithRequest:request
	 delegate:self];
	 */
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"]; // use ISO-8601 date format - single quotes indicate a literal character
	
	NSError *xmlError = nil;
	NSDictionary *abstracts = [XMLReader dictionaryForXMLString:test error:&xmlError];
	
	NSDictionary *feed = [abstracts objectForKey:@"feed"];
	
	NSArray *feedEntries = [feed objectForKey:@"entry"];
	
	NSManagedObjectContext *mom = appDelegate.mainManagedObjectContext;
	
	for (NSDictionary *entry in feedEntries) {
		
		// get id
		//
		NSString *archiveID = [[entry objectForKey:@"id"] objectForKey:@"text"];

		if ([self entryForID:archiveID] != nil) // already in database
			continue;
		
		AXEntry *newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"AXEntry"
														  inManagedObjectContext:mom];
		
		newEntry.archiveID = archiveID;
		
		// process authors
		//
		
		// If there is more than one author a dictonary is returned;
		// otherwise it's a dictionary.
		
		NSArray *authors;
		if ([[entry objectForKey:@"author"] isKindOfClass:NSArray.class])
			authors = [entry objectForKey:@"author"];
		else if ([[entry objectForKey:@"author"] isKindOfClass:NSDictionary.class])
			authors = @[[entry objectForKey:@"author"]];

//		NSLog(@"AUTHORS: %@", authors);

		int authorIndex = 1;
		for (NSDictionary *a in authors) {
			
			if ([a objectForKey:@"name"] && [[a objectForKey:@"name"] objectForKey:@"text"]) {
				
				AXAuthor *newAuthor = [NSEntityDescription insertNewObjectForEntityForName:@"AXAuthor"
																	inManagedObjectContext:mom];
				newAuthor.name = [[a objectForKey:@"name"] objectForKey:@"text"];
				newAuthor.index = @(authorIndex++);
				[newEntry addAuthorsObject:newAuthor];
			}
		}

		// process category
		//
		// The API returns category as a dictionary if there is one record
		// or an array if there are more than one.
		//
		if ([[entry objectForKey:@"category"] isKindOfClass:NSArray.class]) {
			for (NSDictionary *catDict in [entry objectForKey:@"category"]) {
				AXCategory *category = [NSEntityDescription insertNewObjectForEntityForName:@"AXCategory"
																	 inManagedObjectContext:mom];
				category.label = [catDict objectForKey:@"term"];
				[newEntry addCategoriesObject:category];
			}
		} else {
			// dictionary - one category.
			AXCategory *category = [NSEntityDescription insertNewObjectForEntityForName:@"AXCategory"
																 inManagedObjectContext:mom];
			category.label = [[entry objectForKey:@"category"] objectForKey:@"term"];
			[newEntry addCategoriesObject:category];
		}
		
		// process links
		//
		// could three (html, pdf, doi), always two (html, pdf)
		for (NSDictionary *linkDictionary in [entry objectForKey:@"link"]) {
			if ([[linkDictionary objectForKey:@"type"] isEqualToString:@"application/pdf"]) {
				newEntry.pdfLink = [NSURL URLWithString:[linkDictionary objectForKey:@"href"]];
			}
			else if ([[linkDictionary objectForKey:@"rel"] isEqualToString:@"alternate"])
				newEntry.abstractLink = [NSURL URLWithString:[linkDictionary objectForKey:@"href"]];
			else
				newEntry.doiLink = [NSURL URLWithString:[linkDictionary objectForKey:@"href"]];
		}
		
		// process date published
		//
		newEntry.datePublished = [dateFormatter dateFromString:[[entry objectForKey:@"published"] objectForKey:@"text"]];
		
		// process summary
		//
		NSString *summary = [[entry objectForKey:@"summary"] objectForKey:@"text"];
		summary = [summary stringByReplacingOccurrencesOfString:@"\\Delta" withString:@"Δ"];
		summary = [summary stringByReplacingOccurrencesOfString:@"\\alpha" withString:@"α"];
		summary = [summary stringByReplacingOccurrencesOfString:@"\\pm" withString:@"±"];
		summary = [summary stringByReplacingOccurrencesOfString:@"\\nu" withString:@"ν"];
		summary = [summary stringByReplacingOccurrencesOfString:@"\\tau" withString:@"𝛕"];
		summary = [summary stringByReplacingOccurrencesOfString:@"\\sigma" withString:@"σ"];
		summary = [summary stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
		newEntry.summary = summary;
		
		// process title
		//
		NSString *title = [[entry objectForKey:@"title"] objectForKey:@"text"];
		title = [title stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
		title = [title stringByReplacingOccurrencesOfString:@"  " withString:@""];
		newEntry.title = title;
		
		// process date updated
		//
		newEntry.dateUpdated = [dateFormatter dateFromString:[[entry objectForKey:@"updated"] objectForKey:@"text"]];
		
	}
	
	if (![appDelegate.mainManagedObjectContext save:&error]) {
		NSString *s = [NSString stringWithFormat:@"%@", error];
		NSAssert(error == nil, s);
		// handle error
	}

}

- (AXEntry*)entryForID:(NSString*)archiveID
{
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass(AXEntry.class)];
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"archiveID = %@", archiveID];
	// Specify how the fetched objects should be sorted
	//NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"<#key#>"
	//															   ascending:YES];
	//[fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
		
	NSError *error = nil;
	NSArray *fetchedObjects = [self.appDelegate.mainManagedObjectContext executeFetchRequest:fetchRequest error:&error];
	if (fetchedObjects == nil || fetchedObjects.count == 0) {
		return nil;
	}
	else
		return [fetchedObjects objectAtIndex:0];
}

- (NSArray*)todaysAbstracts
{
	NSError *error = nil;
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass(AXEntry.class)];
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"datePublished < %@", [NSDate date]];
	NSArray *entries = [self.appDelegate.mainManagedObjectContext executeFetchRequest:fetchRequest
																				error:&error];
	
	if (error != nil) {
		DLog(@"ERROR: %@", error);
	}
	
	return entries;
}

@end
