//
//  AddViewController.m
//  SQL
//
//  Created by iPhone SDK Articles on 10/26/08.
//  Copyright 2008 www.iPhoneSDKArticles.com.
//


#import "AddViewController.h"
#import "Leads.h"	
#import "FlurryAPI.h"



@implementation AddViewController

/*
// Override initWithNibName:bundle: to load the view using a nib file then perform additional customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement loadView to create a view hierarchy programmatically.



// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
	
 self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
	
    [super viewDidLoad];
	
	self.title = @"Add Lead";
 
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] 
											  initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
											   target:self action:@selector(cancel_Clicked:)] autorelease];
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
											   initWithBarButtonSystemItem:UIBarButtonSystemItemSave 
											   target:self action:@selector(save_Clicked:)] autorelease];
	//TitleBar
	//self.navigationController.navigationBar.tintColor = [UIColor grayColor];

}


- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	

	//	UIAlertView *baseAlert = [[UIAlertView alloc]  initWithTitle:@"" message:firstRun delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
	//	[baseAlert show];



	[txtCoffeeName becomeFirstResponder];

	
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void) save_Clicked:(id)sender {
	
	SQLAppDelegate *appDelegate = (SQLAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	//Create a Leads Object.
	Leads *coffeeObj = [[Leads alloc] initWithPrimaryKey:0];
	coffeeObj.coffeeName = txtCoffeeName.text;
	

	//de.001 adding Value
	NSString *temp = [[NSString alloc] initWithString:txtPrice.text];
	coffeeObj.price = temp;
	[temp release];	
	
	//de.001 adding Company Name
	NSString *temp2 = [[NSString alloc] initWithString:txtCompanyName.text];
	coffeeObj.companyName = temp2;
	[temp2 release];	
	

	//Trying new solution
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat:@"MMMM d, yyyy"];
	NSString *today2Date = [formatter stringFromDate:[NSDate date]];
	NSLog(@"NSDateFormatter (Apple Says Good): %@",today2Date);

	coffeeObj.leadDate = today2Date;


	NSString *temp3 = [[NSString alloc] initWithString:txtPersonID.text];
	coffeeObj.personID = temp3; 
	
	if (txtCoffeeName.text.length != 0) {
		
		

	coffeeObj.isDirty = NO;
	coffeeObj.isDetailViewHydrated = YES;

	//Add the object
	[appDelegate addLeads:coffeeObj];
		
	//Flurry - Someone added a Lead
	[FlurryAPI logEvent:@"Added a Lead"];	
	
		
	//Clean up
	txtCoffeeName.text	= @"";
	txtCompanyName.text	= @"";
	txtPrice.text = @"";
	txtPersonID.text = @"";
		
	//Dismiss the controller.
	[self.navigationController dismissModalViewControllerAnimated:YES];

	} else {
		
	UIAlertView *baseAlert = [[UIAlertView alloc]  initWithTitle:self.title message:@"Sorry, Please Enter a Name" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
	[baseAlert show];
			
	}

	


}

- (void) cancel_Clicked:(id)sender {
	
	//Dismiss the controller.
	[self.navigationController dismissModalViewControllerAnimated:YES];
	
	txtCoffeeName.text = @"";
	txtCompanyName.text = @"";
	txtPrice.text = @"";
	txtPersonID.text = @"";
}

- (void)dealloc {
	[txtCoffeeName release];
	[txtCompanyName release];
	[txtLeadDate release];
	[txtPrice release];
    [super dealloc];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == txtCoffeeName) {
        [txtCompanyName becomeFirstResponder];

    } else if(textField == txtCompanyName) {
        [txtPrice becomeFirstResponder];
    }
    return NO;
}


#pragma mark -
#pragma mark Address Book Integration

-(IBAction)getContact {
	// creating the picker
	ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
	// place the delegate of the picker to the controll
	picker.peoplePickerDelegate = self;
	
	// showing the picker
	[self presentModalViewController:picker animated:YES];
	// releasing
	[picker release];
	
	//[txtCoffeeName resignFirstResponder];
	txtCoffeeName.text	= @"";
	txtCompanyName.text	= @"";

}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    // assigning control back to the main controller
	[self dismissModalViewControllerAnimated:YES];
}

- (BOOL)peoplePickerNavigationController: (ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {

	NSString *contactName;
	NSString *contactCompany;
	//NSString *contactFirst;	//1.0.0 variable
	//NSString *contactLast;	//1.0.0 variable
	
	//1.0.0 Code
	//contactFirst = [(NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty) stringByAppendingString:@" "];	
	//contactLast =  (NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
	//contactName = [contactFirst stringByAppendingString:contactLast]; //1.0.0 Code
	contactName = (NSString *)ABRecordCopyCompositeName(person);
	contactCompany = (NSString *)ABRecordCopyValue(person, kABPersonOrganizationProperty);
	
	NSNumber *recordId = [NSNumber numberWithInteger: ABRecordGetRecordID(person)];


	NSLog(@"record id is %@",recordId);
	NSLog(@"Person Reference: %d", person);
	NSLog(@"Name: %@", contactName);
	NSLog(@"Company: %@", contactCompany);
	
	
	txtCoffeeName.text = contactName;
	NSString *personStr = [NSString stringWithFormat:@"%@", recordId];
	txtPersonID.text = personStr;
	

	if (contactCompany != nil) txtCompanyName.text = contactCompany;
	
	// remove the controller
    [self dismissModalViewControllerAnimated:YES];
	
	if (![txtCompanyName.text isEqualToString:@""]){
		[txtPrice becomeFirstResponder];
	} else [txtCompanyName becomeFirstResponder];
	
    return NO;
	


}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    return NO;
}


@end
