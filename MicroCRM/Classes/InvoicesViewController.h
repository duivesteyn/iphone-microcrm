//
//  InvoicesViewController.h
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

@class Invoices, AddViewController3, DetailViewController3;


@interface InvoicesViewController : UITableViewController {
	IBOutlet UITableView *tblSimpleTable;
	NSArray *arryData;
	
	SQLAppDelegate *appDelegate;
	AddViewController3 *avController3;
	DetailViewController3 *dvController3;
	UINavigationController *addNavigationController;
	
	
	//de.009 firstRun Image
	UIImageView *firstRunImage;
	

	
}



@end
