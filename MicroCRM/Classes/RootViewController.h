//
//  RootViewController.h
//  SQL
//

//  Created by Benjamin M. Duivesteyn on 5/01/10.
//  Copyright 2010 TBA. All rights reserved.
//

#import <UIKit/UIKit.h>
//AddressBook stuff
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <Foundation/Foundation.h>

@class Leads, Jobs, AddViewController, DetailViewController;

@interface RootViewController : UITableViewController {
	
	SQLAppDelegate *appDelegate;
	AddViewController *avController;
	DetailViewController *dvController;
	
	UINavigationController *addNavigationController;

	
	//de.009 firstRun Image
	UIImageView *firstRunImage;
	


}

-(void)removeItemfromLeads:(NSNotification*)notification;

@end
