//
//  SQLAppDelegate.h
//  SQL
//
//  Created by iPhone SDK Articles on 10/26/08.
//  Copyright 2008 www.iPhoneSDKArticles.com.
//

#import <UIKit/UIKit.h>

@class Leads, Jobs, Invoices;
@class RootViewController;



@interface SQLAppDelegate : NSObject <UIApplicationDelegate> {
	
    
    UIWindow *window;
    UINavigationController *navigationController;
	
	//To hold a list of Leads objects
	NSMutableArray *coffeeArray;
	
	//To hold a list of Jobs objects
	NSMutableArray *coffeeArray2;
	
	//To hold a list of Invoices objects
	NSMutableArray *coffeeArray3;
	
	//de.001 splash screen
	UIImageView *splashView;

	//de.002 TabBar
	UITabBarController *tabBarController;
	RootViewController *rootController;

	//Images Array for Icons
	NSArray *arryImages;
	
	//Settings
	NSInteger badgesetting;
	NSInteger badgearraynum;
	
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;



	//de.002 TabBar
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet RootViewController *rootController;

@property (nonatomic, retain) NSMutableArray *coffeeArray;
@property (nonatomic, retain) NSMutableArray *coffeeArray2;
@property (nonatomic, retain) NSMutableArray *coffeeArray3;
@property (nonatomic, retain) NSArray *arryImages;



- (void) copyDatabaseIfNeeded;
- (NSString *) getDBPath;

- (void) removeLeads:(Leads *)coffeeObj;
- (void) addLeads:(Leads *)coffeeObj;
- (void) removeJobs:(Jobs *)coffeeObj2;
- (void) addJobs:(Jobs *)coffeeObj2;
- (void) removeInvoices:(Invoices *)coffeeObj3;
- (void) addInvoices:(Invoices *)coffeeObj3;


@end

