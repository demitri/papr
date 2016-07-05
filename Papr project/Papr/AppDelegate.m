//
//  AppDelegate.m
//  Papr
//
//  Created by Demitri Muna on 6/22/16.
//  Copyright © 2016 Demitri Muna. All rights reserved.
//

#import "AppDelegate.h"
#import "CoreDataInterface.h"
#import <CoreData/CoreData.h>

@interface AppDelegate ()
- (void)_setUpCoreData;
- (void)_privateManagedObjectContextDidSave:(NSNotification *)notification;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Override point for customization after application launch.
	
	self.arXivManager = [[AXManager alloc] init];

	[self _setUpCoreData];
	
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 

- (NSDateFormatter*)iso8601DateFormatter
{
	if (_iso8601DateFormatter == nil) {
		_iso8601DateFormatter = [[NSDateFormatter alloc] init];
		[_iso8601DateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"]; // use ISO-8601 date format
		_iso8601DateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"EST"];
	}
	return _iso8601DateFormatter;
}

#pragma mark Core Data methods
#pragma mark -

- (void)_setUpCoreData
{
	CoreDataInterface *cdMain = [[CoreDataInterface alloc] initWithModelName:@"PaprModel"
														 andConcurrencyModel:NSMainQueueConcurrencyType];
	CoreDataInterface *cdPrivate = [[CoreDataInterface alloc] initWithModelName:@"PaprModel"
															andConcurrencyModel:NSPrivateQueueConcurrencyType];
	
	// use the same persisient store coordinator
	cdMain.persistentStoreFilename = @"Papr.storedata";
	//[cdMain deletePersistentStore];
	cdPrivate.persistentStoreCoordinator = cdMain.persistentStoreCoordinator;
	
	self.mainManagedObjectContext = cdMain.managedObjectContext;		// for calls on the main thread (UI)
	self.privateManagedObjectContext = cdPrivate.managedObjectContext;	// for calls from any other thread
	
	// register for notifications when private MOC has saved
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self selector:@selector(_privateManagedObjectContextDidSave:)
			   name:NSManagedObjectContextDidSaveNotification
			 object:self.privateManagedObjectContext];

}

- (void)_privateManagedObjectContextDidSave:(NSNotification *)notification
{
	// Remember that notifications are received on the same thread that sent them,
	// and this must be called on the main thread.
	dispatch_async(dispatch_get_main_queue(), ^{
		[self.mainManagedObjectContext mergeChangesFromContextDidSaveNotification:notification];
	});
}

@end
