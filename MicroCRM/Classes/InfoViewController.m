//
//  FourthViewController.m
//  ORBooks
//
//  Created by Benjamin M. Duivesteyn on 3/01/10.
//  Copyright 2010 TBA. All rights reserved.
//

#import "InfoViewController.h"
#import "InAppSettings.h"
#import "FlurryAPI.h"


@implementation InfoViewController

@synthesize scrollView2;


/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

- (void)viewDidLoad
{
	// 2. setup the scrollview for one image and add it to the view controller
	//
	[scrollView2 setBackgroundColor:[UIColor blackColor]];
	[scrollView2 setCanCancelContentTouches:NO];
	scrollView2.clipsToBounds = YES;	// default is NO, we want to restrict drawing within our scrollview
	scrollView2.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg-help.png"]];
	[scrollView2 addSubview:imageView];
	[scrollView2 setContentSize:CGSizeMake(imageView.frame.size.width, imageView.frame.size.height)];
	[scrollView2 setScrollEnabled:YES];
	[imageView release];
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
}








- (void)dealloc {
	[scrollView2 release];
    [super dealloc];
}


//Press of ?
- (IBAction)toggleView:(id)sender {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp
						   forView:[self view]
							 cache:YES];
	[[self view] addSubview:secondaryView];
	[UIView commitAnimations];
	
}

//Flips to front when "Done" is pressed
- (IBAction)returnView:(id)sender {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown
						   forView:[self view]
							 cache:YES];
	[secondaryView removeFromSuperview];
	[UIView commitAnimations];

	
}

//Flips to back when toggle button is pressed
- (IBAction)toggleViewhelp:(id)sender {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp
						   forView:[self view]
							 cache:YES];
	[[self view] addSubview:helpView];
	[UIView commitAnimations];
}

//Flips to front when "Done" is pressed
- (IBAction)returnViewhelp:(id)sender {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown
						   forView:[self view]
							 cache:YES];
	[helpView removeFromSuperview];
	[UIView commitAnimations];
}


- (IBAction)presentSettings {
    InAppSettingsModalViewController *settings = [[InAppSettingsModalViewController alloc] init];
    [self presentModalViewController:settings animated:YES];
    [settings release];
}


#pragma mark -
#pragma mark Emails

- (IBAction)presentEmailFeedback{
	// This sample can run on devices running iPhone OS 2.0 or later  
	// The MFMailComposeViewController class is only available in iPhone OS 3.0 or later. 
	// So, we must verify the existence of the above class and provide a workaround for devices running 
	// earlier versions of the iPhone OS. 
	// We display an email composition interface if MFMailComposeViewController exists and the device can send emails.
	// We launch the Mail application on the device, otherwise.
	
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil)
	{
		// We must always check whether the current device is configured for sending emails
		if ([mailClass canSendMail])
		{
			[self displayComposerSheetFeedback];
		}
		else
		{
			[self launchMailAppOnDevice];
		}
	}
	else
	{
		[self launchMailAppOnDevice];
	}

}

- (IBAction)presentEmailExport {
	// This sample can run on devices running iPhone OS 2.0 or later  
	// The MFMailComposeViewController class is only available in iPhone OS 3.0 or later. 
	// So, we must verify the existence of the above class and provide a workaround for devices running 
	// earlier versions of the iPhone OS. 
	// We display an email composition interface if MFMailComposeViewController exists and the device can send emails.
	// We launch the Mail application on the device, otherwise.
	
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil)
	{
		// We must always check whether the current device is configured for sending emails
		if ([mailClass canSendMail])
		{
			[self displayComposerSheetExport];
		}
		else
		{
			[self launchMailAppOnDevice];
		}
	}
	else
	{
		[self launchMailAppOnDevice];
	}
}

- (IBAction)presentTwitter {
	NSURL *url = [NSURL URLWithString:@"http://mobile.twitter.com/microcrmapp"];
	
	if (![[UIApplication sharedApplication] openURL:url])
		
		NSLog(@"%@%@",@"Failed to open url:",[url description]);
}

#pragma mark -
#pragma mark Compose Export Mail

// Displays an email composition interface inside the application. Populates all the Mail fields. 
-(void)displayComposerSheetExport
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	NSString *Date = (@"%@", [NSDate date]);
	[picker setSubject:[NSString stringWithFormat:@"%@ %@", @"MicroCRM Export", Date]];
	
	// Set up recipients
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *toEmail = [defaults objectForKey:@"textEntry_EmailAddress"];
	
	NSArray *toRecipients = [NSArray arrayWithObject:toEmail]; 
	[picker setToRecipients:toRecipients];

	// Export Data from DB
	//Exporting 
	
	NSString *ExportLeads;
	NSString *ExportJobs;	
	NSString *ExportInvoices;
	NSString *ExportEmail;
	int NumLeads;
	int NumJobs;
	int NumInvoices;
	
	//Export Leads
	//get number
	appDelegate = (SQLAppDelegate *)[[UIApplication sharedApplication] delegate];
	NumLeads = [appDelegate.coffeeArray count];
	NumJobs = [appDelegate.coffeeArray2 count];
	NumInvoices = [appDelegate.coffeeArray3 count];
	
	//Print Leads
	ExportLeads = @"Leads\n";
	for (int i = 0; i < NumLeads; i++) {
		Leads *coffeeObj = [appDelegate.coffeeArray objectAtIndex:i];
		NSString *tmpstr = [NSString stringWithFormat:@"%@,,%@,%@,%@,%@\n", coffeeObj.coffeeName, coffeeObj.companyName, coffeeObj.price, coffeeObj.leadDate, coffeeObj.notes];
		ExportLeads = [ExportLeads stringByAppendingString:tmpstr];
	}
	
	//Print Jobs
	ExportJobs = @"\nJobs\n";
	for (int i = 0; i < NumJobs; i++) {
		Jobs *coffeeObj2 = [appDelegate.coffeeArray2 objectAtIndex:i];
		NSString *tmpstr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@\n",coffeeObj2.coffeeName,coffeeObj2.clientID,coffeeObj2.companyName,coffeeObj2.price,coffeeObj2.LeadDate,coffeeObj2.notes];
		ExportJobs = [ExportJobs stringByAppendingString:tmpstr];
	}
	
	//Print Invoices
	ExportInvoices = @"\nInvoices\n";
	for (int i = 0; i < NumInvoices; i++) {
		Jobs *coffeeObj3 = [appDelegate.coffeeArray3 objectAtIndex:i];
		NSString *tmpstr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@\n",coffeeObj3.coffeeName,coffeeObj3.clientID,coffeeObj3.companyName,coffeeObj3.price,coffeeObj3.LeadDate,coffeeObj3.notes];
		ExportInvoices = [ExportInvoices stringByAppendingString:tmpstr];
	}
	
	
	NSString *ExportHeaders = @"Name,ID,Company,Value,Date,DateYear,Notes\n\n";
	//Final DataString
	ExportEmail = [NSString stringWithFormat:@"%@\n%@\n%@\n%@",ExportHeaders,ExportLeads,ExportJobs,ExportInvoices];

	
	//Flurry - Someone Emailed an Export
	[FlurryAPI logEvent:@"Emailed an Export"];
	
	//Setup Data File export.csv
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	// the path to write file
	NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"microCRM-export.csv"];
	[ExportEmail writeToFile:appFile atomically:YES encoding:NSUnicodeStringEncoding error:NULL];
	
	// Fill out the email body text
	NSString *emailBody = @"MicroCRM export is attached in csv format.";
	[picker setMessageBody:emailBody isHTML:NO];
	
	NSData *myData = [NSData dataWithContentsOfFile:appFile];
	
	[picker addAttachmentData:myData mimeType:@"text/plain" fileName:@"microcrm-export.csv"];
	
	[self presentModalViewController:picker animated:YES];
    [picker release];
}

#pragma mark Feedback Email

-(void)displayComposerSheetFeedback 
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	[picker setSubject:@"MicroCRM Feedback"];
	
	
	// Set up recipients
	NSArray *toRecipients = [NSArray arrayWithObject:@"microcrmapp@gmail.com"]; 

	[picker setToRecipients:toRecipients];
	
	
	//Flurry - Someone Emailed Feedback
	[FlurryAPI logEvent:@"Emailed Feedback"];
	

	// Fill out the email body text
	NSString *emailBody = @"Your Feedback Here";
	[picker setMessageBody:emailBody isHTML:NO];
	
	[self presentModalViewController:picker animated:YES];
    [picker release];
}


// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
	//message.hidden = NO;
	
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			NSLog(@"Result: canceled");
			break;
		case MFMailComposeResultSaved:
			NSLog(@"Result: saved");
			break;
		case MFMailComposeResultSent:
			NSLog(@"Result: sent");
			break;
		case MFMailComposeResultFailed:
			NSLog(@"Result: failed");
			break;
		default:
			NSLog(@"Result: not sent");
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Workaround

// Launches the Mail application on the device.
-(void)launchMailAppOnDevice
{
	NSString *recipients = @"mailto:microcrmapp@gmail.com&subject=Feedback";
	NSString *body = @"&body=Insert Feedback Here";
	
	NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}


@end

