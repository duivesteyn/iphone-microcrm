//
//  DetailViewController.h
//  SQL
//
//  Created by iPhone SDK Articles on 10/26/08.
//  Copyright 2008 www.iPhoneSDKArticles.com.
//

#import <UIKit/UIKit.h>
//#import "LeadsVariables.h"



@class Invoices, EditViewController3;

@interface DetailViewController3 : UITableViewController <UIActionSheetDelegate> {

	IBOutlet UITableView *tableView;
	Invoices *coffeeObj3;
	NSIndexPath *selectedIndexPath;
	EditViewController3 *evController;
	NSMutableArray *menuList;
	
	


}

@property (nonatomic, retain) Invoices *coffeeObj3;



@end
