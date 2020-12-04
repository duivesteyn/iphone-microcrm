////  Jobs.h
//
//  Created by Benjamin M. Duivesteyn on 5/01/10.
//  Copyright 2010 TBA. All rights reserved.
//

#import <UIKit/UIKit.h>
//AddressBook stuff
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <Foundation/Foundation.h>

@class Jobs, Invoices, AddViewController2, DetailViewController2;
 

@interface JobsViewController : UITableViewController {

	
	SQLAppDelegate *appDelegate;
	AddViewController2 *avController2;
	DetailViewController2 *dvController2;
	UINavigationController *addNavigationController;

	
	//de.009 firstRun Image
	UIImageView *firstRunImage;
	

	
}

-(void)removeItemfromJobs:(NSNotification*)notification;

@end
