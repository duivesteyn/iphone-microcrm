//
//  DetailViewController.h
//  SQL
//
//  Created by iPhone SDK Articles on 10/26/08.
//  Copyright 2008 www.iPhoneSDKArticles.com.
//

#import <UIKit/UIKit.h>
//#import "LeadsVariables.h"



@class Jobs, Invoices, EditViewController2;

@interface DetailViewController2 : UITableViewController <UIActionSheetDelegate> {

	IBOutlet UITableView *tableView;
	SQLAppDelegate *appDelegate;
	Jobs *coffeeObj2;	
	Invoices *coffeeObj3;
	NSIndexPath *selectedIndexPath;
	EditViewController2 *evController;
	NSMutableArray *menuList;
	
	


}

@property (nonatomic, retain) Jobs *coffeeObj2;

@end
