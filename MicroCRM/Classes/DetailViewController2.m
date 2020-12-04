//
//  DetailViewController.m
//  SQL
//
//  Created by iPhone SDK Articles on 10/26/08.
//  Copyright 2008 www.iPhoneSDKArticles.com.
//

#import "DetailViewController2.h"
#import "Jobs.h"

#import "JobsViewController.h"
#import "EditViewController2.h"

#import "Leads.h"
#import "Invoices.h"

@implementation DetailViewController2

@synthesize coffeeObj2;

static NSArray *pageNames = nil;
static NSArray *pageNames2 = nil;

//Section Names
static NSString	*sectiontitle1 = @"Job Name";
static NSString	*sectiontitle2 = @"Parameters";

static NSString *parameter1 = @"Company";
static NSString *parameter2 = @"Job Value";
static NSString *parameter3 = @"Job Start Date";
//static NSString *parameter4 = @"Notes";



/*
// Implement loadView to create a view hierarchy programmatically.
- (void)loadView {
}
*/

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
	
	//hide
	self.navigationItem.leftBarButtonItem = nil;
	
    [self.navigationItem setHidesBackButton:editing animated:animated];
	
	self.navigationItem.hidesBackButton = NO;
	
	//de 006 - Load in Move section button here.
	UIBarButtonItem *saveButton = [[[UIBarButtonItem alloc] 
									initWithBarButtonSystemItem:UIBarButtonSystemItemAction
									target:self action:@selector(altersection:)] autorelease];

	if (self.editing) {
		self.navigationItem.leftBarButtonItem = saveButton;
				[self.tableView setUserInteractionEnabled:YES];
	} else {
		self.navigationItem.leftBarButtonItem = nil;
		[self.navigationItem setHidesBackButton:editing animated:animated];
		self.navigationItem.hidesBackButton = NO;	
		[self.tableView setUserInteractionEnabled:NO];
	}
	

	
    [tableView reloadData];
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return UITableViewCellEditingStyleNone;
}
	
#pragma mark -
#pragma mark Section Management

- (void) altersection:(id)sender {
	NSLog(@"Clicked Alter Section");
	//Moves from Section 2 to Section 3
	NSString *message = @"Do you want to move ";
	NSString *messageB = @" from Jobs to Invoices?";
	
	message = [message stringByAppendingString:coffeeObj2.coffeeName];	
	message = [message stringByAppendingString:messageB];
	


	//ActionSheet, opens in the same window
	//------------
		// open a dialog with an OK and cancel button
	//NSString *message = @"What extra information would you like?";
		UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:message delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"OK",nil];
		actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
		[actionSheet showInView:[UIApplication sharedApplication].keyWindow];
		[actionSheet release];



}

- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSLog(@"Clicked Button in actionSheet");
    if (buttonIndex == 0) {
		NSLog(@"In actionSheet Action = YES");

		//NSString *message = (@"Moved %@ to Due Invoices", coffeeObj2.coffeeName); 
	
		//move section payload
		if (1==1)
		{
		coffeeObj2.isDirty = YES;
		coffeeObj2.isDetailViewHydrated = YES;
		coffeeObj2.section = @"3";
		}
		
		NSString *arraycount = [NSString stringWithFormat:@"%d", coffeeObj2.coffeeID];
		NSLog(@"coffeeObj2.coffeeID: %@",arraycount);	
		NSLog(@"coffeeObj2.clientID: %@",coffeeObj2.clientID);
		NSLog(@"coffeeObj2.coffeename:%@",coffeeObj2.coffeeName);
		NSLog(@"coffeeObj2.price:%@",coffeeObj2.price);
		NSLog(@"coffeeObj2.company:%@",coffeeObj2.companyName);	
		NSLog(@"coffeeObj2.section:%@",coffeeObj2.section);
		NSLog(@"coffeeObj2.isDirty: %@",[NSString stringWithFormat:@"%d", coffeeObj2.isDirty]);

		//Forcing out of Editing
		[super setEditing:NO animated:YES];
		[tableView setEditing:NO animated:YES];
		self.navigationItem.leftBarButtonItem = nil;
		
		//Popping out of view
		[self.navigationController  popViewControllerAnimated:YES];
		//calling save of stuff now and reload
		

		//remove coffeeObj2 from appDelegate.coffeeArray2 with the above info
		[[NSNotificationCenter defaultCenter] postNotificationName: @"keyboardDoneJobs" object: nil];

		
    } else if (buttonIndex == 1) {
    }
}


#pragma mark -
#pragma mark Standard Methods

// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.tableView.allowsSelectionDuringEditing = YES; //de-added
	self.tableView.backgroundColor = [UIColor clearColor];
	

}




- (void) viewWillAppear:(BOOL)animated {

	
	[super viewWillAppear:animated];
	
	self.title = coffeeObj2.coffeeName;
		[self.tableView reloadData];
	
	

}

- (void)viewWillDisappear:(BOOL)animated {

	[tableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[evController release];
	[selectedIndexPath release];
	[tableView release];
	[coffeeObj2 release];
    [super dealloc];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tblView {
    return 2;
}




- (NSInteger)tableView:(UITableView *)tblView numberOfRowsInSection:(NSInteger)section {

	
	switch(section) {
		case 0:
			return 2;
			break;
		case 1:
			return 4;
			break;	
		default:
			return 0;
			break;

	}
	
}


- (UITableViewCell *)tableView:(UITableView *)tblView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	
	//de.002
	static NSString *kCellIdentifier = @"cellID2";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
	cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCellIdentifier] autorelease];

	cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.accessoryType = UITableViewCellAccessoryNone;	
	
	//de.005.1 Cell Setup with Image
	CGRect frame; frame.origin.x = 5; frame.origin.y = 10; frame.size.height = 20; frame.size.width = 20;
	
	UIImageView *imgLabel = [[UIImageView alloc] initWithFrame:frame];
	imgLabel.tag = 1;
	[cell.contentView addSubview:imgLabel];
	[imgLabel release];
	
	frame.origin.x = 30; 
	frame.size.width = 200;	
	UILabel *nameLabel = [[UILabel alloc] initWithFrame:frame];
	nameLabel.tag = 2;
	[cell.contentView addSubview:nameLabel];
	[nameLabel release];
	//End de.005.1
	
	//Notes Cell	/New in 1.0.1
	UILabel *notesLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,32,280,55)];
	notesLabel.tag = 3;
	notesLabel.backgroundColor = [UIColor clearColor];
	[cell.contentView addSubview:notesLabel];
	[notesLabel release];
	
	
	//Convert Price to NSNumber
	NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
	[f setNumberStyle:NSNumberFormatterDecimalStyle];
	NSNumber * somePrice2 = [f numberFromString:coffeeObj2.price];
	[f release];
	
	//Convert Stored Price to Currency String in Price
	NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
	[currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
	NSString *priceFormatted = [currencyFormatter stringFromNumber:somePrice2];
	
	//variables
	pageNames = [[NSArray alloc] initWithObjects:coffeeObj2.companyName, priceFormatted,coffeeObj2.LeadDate,@"Notes", nil]; //@test can goto 
	//descriptions
	pageNames2 = [[NSArray alloc] initWithObjects:parameter1, parameter2, parameter3, @"", nil];
	
	//icons
	NSArray *arryImages = [(SQLAppDelegate *)[[UIApplication sharedApplication] delegate] arryImages];
	


	switch(indexPath.section) {
		case 0:
			
				switch (indexPath.row) {
				case 0:
					
				//Setup Name to Cell
					cell.textLabel.text = @"";
				UILabel * nameLabel = (UILabel *) [cell.contentView viewWithTag:2];
				[nameLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
				nameLabel.text = coffeeObj2.coffeeName;
			
				//Setup Pic in Cell
				UIImageView *imageView = (UIImageView *) [cell.contentView viewWithTag:1];
				imageView.image = [UIImage imageNamed:@"ico-job.png"]; // set the image for the imageview
						
				break;
				
						
				case 1:
				//Setup Name to Cell
				cell.textLabel.text = @"";
				UILabel * nameLabel2 = (UILabel *) [cell.contentView viewWithTag:2];
				[nameLabel2 setFont:[UIFont boldSystemFontOfSize:16.0]];
				nameLabel2.text = coffeeObj2.clientID;
						
				//Setup Pic in Cell
				UIImageView *imageView2 = (UIImageView *) [cell.contentView viewWithTag:1];
				imageView2.image = [UIImage imageNamed:@"ico-id.png"]; // set the image for the imageview
	
				cell.detailTextLabel.text = @"ID";	
				cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
						
				break;		
						
						
				}
			
		break;

			
		case 1:
			cell.textLabel.text = @"";
			
			//Setup Name to Cells
			UILabel * nameLabel2 = (UILabel *) [cell.contentView viewWithTag:2];
			[nameLabel2 setFont:[UIFont boldSystemFontOfSize:16.0]];
			nameLabel2.text = [pageNames objectAtIndex:indexPath.row];
			
			//Setup Images in Cells
			UIImageView *imageView2 = (UIImageView *) [cell.contentView viewWithTag:1];
			imageView2.image = [arryImages objectAtIndex:[indexPath row]];
			
			///cell.textLabel.text = [pageNames objectAtIndex:indexPath.row];	
			cell.detailTextLabel.text = [pageNames2 objectAtIndex:indexPath.row];	
			cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
			
			//Setup Custom Notes Cell to Cell
			if ([[pageNames objectAtIndex:indexPath.row] isEqualToString:@"Notes"]==TRUE) {
				NSLog(@"Setting up Cell: %@",[pageNames objectAtIndex:indexPath.row]);
				
				UILabel * notesLabel = (UILabel *) [cell.contentView viewWithTag:3];
				[notesLabel setFont:[UIFont systemFontOfSize:14.0]];
				notesLabel.text =coffeeObj2.notes;
				notesLabel.numberOfLines = 3;
				notesLabel.textColor = [UIColor darkGrayColor];
				
			}
			

			break;

	}
	
	return cell;
}




- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Only allow selection if editing.
    return (self.editing) ? indexPath : nil;
}

- (void)tableView:(UITableView *)tblView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	//Keep track of the row selected.
	selectedIndexPath = indexPath;
	
	if(evController == nil)
		evController = [[EditViewController2 alloc] initWithNibName:@"EditView" bundle:nil];
	
	//Find out which field is being edited.
	switch(indexPath.section) 
{	
	case 0:
		switch(indexPath.row)  {
			case 0:
			evController.keyOfTheFieldToEdit = @"coffeeName";
			evController.editValue = coffeeObj2.coffeeName;
			break;
				
			case 1:
			evController.keyOfTheFieldToEdit = @"clientID";
			evController.editValue = coffeeObj2.clientID;
			break;	
		}
		
		break;
		
		
	case 1:		//Values Section
			
			switch (indexPath.row) {
				case 0: //companyName
					evController.keyOfTheFieldToEdit = @"CompanyName";
					evController.editValue = coffeeObj2.companyName;

					break;
				case 1: //Price
					evController.keyOfTheFieldToEdit = @"Price";
					evController.editValue = coffeeObj2.price;

					break;
				case 2: //Date
					evController.keyOfTheFieldToEdit = @"LeadDate";
					evController.editValue = coffeeObj2.LeadDate;

					break;
				case 3: //Notes:
					evController.keyOfTheFieldToEdit = @"Notes";
					evController.editValue = coffeeObj2.notes;

				default:
					break;
			}

	}
	
	//Object being edited.
	evController.objectToEdit = coffeeObj2;
	
	//Push the edit view controller on top of the stack.
	[self.navigationController pushViewController:evController animated:YES];
	
}




// CUSTOM Section Title Color and Font

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	
  	UIView* customView = [[[UIView alloc] 
						   initWithFrame:CGRectMake(15.0, 0.0, 300.0, 20.0)]
						  autorelease];
	
	UILabel * headerLabel = [[[UILabel alloc]
							  initWithFrame:CGRectZero] autorelease];
	headerLabel.backgroundColor = [UIColor clearColor];
	headerLabel.opaque = NO;
	headerLabel.textColor = [UIColor whiteColor];
	headerLabel.font = [UIFont boldSystemFontOfSize:16];
	headerLabel.frame = CGRectMake(15,-5, 320.0, 44.0);
	headerLabel.shadowColor = [UIColor blackColor];
	headerLabel.shadowOffset = CGSizeMake(0, 1);

	
	
	switch (section) {
			
		case 0:
			headerLabel.text = sectiontitle1;
			break;
		case 1:
			headerLabel.text = sectiontitle2;
			break;
	}
	
  	[customView addSubview:headerLabel];
	
	return customView;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 30.0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row>2) return 90; else return 40;
}



@end
