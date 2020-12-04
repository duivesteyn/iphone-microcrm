//
//  SQLAppDelegate.m
//  SQL
//
//  Created by iPhone SDK Articles on 10/26/08.
//  Copyright 2008 www.iPhoneSDKArticles.com.
//

#import "SQLAppDelegate.h"
#import "RootViewController.h"
#import "Leads.h"
#import "Jobs.h"
#import "Invoices.h"
//APIs
#import "FlurryAPI.h"
#import "InAppSettings.h"
#import "Appirater.h"


@implementation SQLAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize navigationController;
@synthesize coffeeArray,coffeeArray2,coffeeArray3;

@synthesize rootController;
@synthesize arryImages;

+ (void)initialize{
    if([self class] == [SQLAppDelegate class]){
		[InAppSettings registerDefaults];
    }
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	
	//Flurry Analytics
	[FlurryAPI startSession:@"LCE784CR5M34MH1S6Z21"];


	//Copy database to the user's phone if needed.
	[self copyDatabaseIfNeeded];
	
	//Initialize the leads array
	NSMutableArray *tempArray = [[NSMutableArray alloc] init];
	self.coffeeArray = tempArray;
	[tempArray release];
	[Leads getInitialDataToDisplay:[self getDBPath]];
	
	//Initialize the jobs array.
	NSMutableArray *tempArray2 = [[NSMutableArray alloc] init];
	self.coffeeArray2 = tempArray2;
	[tempArray2 release];
	[Jobs getInitialDataToDisplay:[self getDBPath]];
	
	//Initialize the invoices array.
	NSMutableArray *tempArray3 = [[NSMutableArray alloc] init];
	self.coffeeArray3 = tempArray3;
	[tempArray3 release];
	[Invoices getInitialDataToDisplay:[self getDBPath]];
	
	[window addSubview:tabBarController.view];
	[window makeKeyAndVisible];
	

	UIImageView *splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 320, 480)];
	splashView.image = [UIImage imageNamed:@"Default.png"];
	[window addSubview:splashView];
	[window bringSubviewToFront:splashView];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.1];
	[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:window cache:YES];
	[UIView setAnimationDelegate:self]; 
	[UIView setAnimationDidStopSelector:@selector(startupAnimationDone:finished:context:)];
	splashView.alpha = 0.0;
	splashView.frame = CGRectMake(-60, -60, 440, 600);
	[UIView commitAnimations];
	

	self.arryImages = [NSArray arrayWithObjects:
				  [UIImage imageNamed: @"ico-company.png"],
				  [UIImage imageNamed: @"ico-value.png"],
				  [UIImage imageNamed: @"ico-date.png"],
				  [UIImage imageNamed: @"ico-notes.png"], nil];
	
	// call the Appirater class
    [Appirater appLaunched];
}




//de.001 splash screen
- (void)startupAnimationDone:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	[splashView removeFromSuperview];
	[splashView release];
}




- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
	NSLog(@"In applicationWillTerminate");
	

	
	
	
	//Save all the dirty coffee objects and free memory.
	[self.coffeeArray makeObjectsPerformSelector:@selector(saveAllDataLeads)];
	[self.coffeeArray2 makeObjectsPerformSelector:@selector(saveAllDataJobs)];
	[self.coffeeArray3 makeObjectsPerformSelector:@selector(saveAllDataInvoices)];


	[Leads finalizeStatements];
	[Jobs finalizeStatements];
	[Invoices finalizeStatements];
	
	//Get Settings
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	//Get Setting for Badge Value
	badgesetting = [userDefaults integerForKey:@"badge_invoice"]; 
	badgearraynum = [userDefaults integerForKey:@"outstanding_key"]; 
	
	if (badgesetting == 1)
	{
		NSLog(@"Setting Badge Number");
		NSInteger badge = 0;
		if (badgearraynum == 1) badge = [coffeeArray count];
		if (badgearraynum == 2) badge = [coffeeArray2 count];
		if (badgearraynum == 3) badge = [coffeeArray3 count];
		[[UIApplication sharedApplication] setApplicationIconBadgeNumber:badge];

		
	} else {
		[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
	};
	
	

}


- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    
    //Save all the dirty coffee objects and free memory.
	[self.coffeeArray makeObjectsPerformSelector:@selector(saveAllDataLeads)];
	[self.coffeeArray2 makeObjectsPerformSelector:@selector(saveAllDataJobs)];
	[self.coffeeArray3 makeObjectsPerformSelector:@selector(saveAllDataInvoices)];
}

- (void)dealloc {
	[coffeeArray release];
	[coffeeArray2 release];
	[coffeeArray3 release];
	[navigationController release];
	[window release];
	[super dealloc];
}

- (void) copyDatabaseIfNeeded {
	
	//Using NSFileManager we can perform many file system operations.
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSString *dbPath = [self getDBPath];
	BOOL success = [fileManager fileExistsAtPath:dbPath]; 
	
	if(!success) {
		
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"SQL.sqlite"];
		success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
		
		if (!success) 
			NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
	}	
}

- (NSString *) getDBPath {
	
	//Search for standard documents using NSSearchPathForDirectoriesInDomains
	//First Param = Searching the documents directory
	//Second Param = Searching the Users directory and not the System
	//Expand any tildes and identify home directories.
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:@"SQL.sqlite"];
}

- (void) removeLeads:(Leads *)coffeeObj {
	
	//Delete it from the database.
	[coffeeObj deleteLeads];
	
	//Remove it from the array.
	[coffeeArray removeObject:coffeeObj];
}

- (void) addLeads:(Leads *)coffeeObj {
	
	//Add it to the database.
	[coffeeObj addLeads];
	
	//Add it to the coffee array.
	[coffeeArray addObject:coffeeObj];
}
- (void) removeJobs:(Jobs *)coffeeObj2 {
	
	//Delete it from the database.
	[coffeeObj2 deleteJobs];
	
	//Remove it from the array.
	[coffeeArray2 removeObject:coffeeObj2];
}

- (void) addJobs:(Jobs *)coffeeObj2 {
	
	//Add it to the database.
	[coffeeObj2 addJobs];
	
	//Add it to the coffee array.
	[coffeeArray2 addObject:coffeeObj2];
}

- (void) removeInvoices:(Invoices *)coffeeObj3 {
	
	//Delete it from the database.
	[coffeeObj3 deleteInvoices];
	
	//Remove it from the array.
	[coffeeArray3 removeObject:coffeeObj3];
}

- (void) addInvoices:(Invoices *)coffeeObj3 {
	
	//Add it to the database.
	[coffeeObj3 addInvoices];
	
	//Add it to the coffee array.
	[coffeeArray3 addObject:coffeeObj3];
}

void uncaughtExceptionHandler(NSException *exception) {
    [FlurryAPI logError:@"Uncaught" message:@"Crash!" exception:exception];
}

@end
