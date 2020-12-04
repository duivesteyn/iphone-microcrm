//
//  AddViewController.h
//  SQL
//
//  Created by iPhone SDK Articles on 10/26/08.
//  Copyright 2008 www.iPhoneSDKArticles.com.
//

#import <UIKit/UIKit.h>
//AddressBook stuff
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>



@class Invoices;

@interface AddViewController3 : UIViewController <ABPeoplePickerNavigationControllerDelegate> {

	IBOutlet UITextField *txtCoffeeName;
	IBOutlet UITextField *txtPrice;
	IBOutlet UITextField *txtCompanyName;
	IBOutlet UITextField *txtLeadDate;
	IBOutlet UITextField *txtPersonID;

	
}

	//Contact Button
-(IBAction)getContact;

@end

