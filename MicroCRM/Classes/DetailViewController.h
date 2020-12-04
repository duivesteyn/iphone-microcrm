//
//  DetailViewController.h
//  SQL
//
//  Created by iPhone SDK Articles on 10/26/08.
//  Copyright 2008 www.iPhoneSDKArticles.com.
//

#import <UIKit/UIKit.h>

//AddressBook stuff
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@class Leads, Jobs, EditViewController;

@interface DetailViewController : UITableViewController <UIActionSheetDelegate> {

	IBOutlet UITableView *tableView;
	SQLAppDelegate *appDelegate;
	Leads *coffeeObj;
	Jobs *coffeeObj2;
	NSIndexPath *selectedIndexPath;
	EditViewController *evController;
	NSMutableArray *menuList;
	
	


}

@property (nonatomic, retain) Leads *coffeeObj;

@end
