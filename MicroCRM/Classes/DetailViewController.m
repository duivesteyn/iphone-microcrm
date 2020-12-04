//
//  DetailViewController.m
//  SQL
//
//  Created by iPhone SDK Articles on 10/26/08.
//  Copyright 2008 www.iPhoneSDKArticles.com.
//

#import "DetailViewController.h"
#import "Leads.h"
#import "Jobs.h"
#import "EditViewController.h"


@implementation DetailViewController

@synthesize coffeeObj;

static NSArray *pageNames = nil;
static NSArray *pageNames2 = nil;

//Section Names
static NSString	*sectiontitle1 = @"Lead Name";
static NSString	*sectiontitle2 = @"Parameters";

static NSString *parameter1 = @"Company";
static NSString *parameter2 = @"Estimated Value";
static NSString *parameter3 = @"Date Met";



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
		[self.navigationItem setHidesBackButton:editing animated:animated];
		self.navigationItem.leftBarButtonItem = saveButton;
		[self.tableView setUserInteractionEnabled:YES];

	} else {
		//self.navigationItem.leftBarButtonItem = nil;
		[self.navigationItem setHidesBackButton:editing animated:animated];
		self.navigationItem.hidesBackButton = NO;	
		[self.tableView setUserInteractionEnabled:NO];
	}

	
   // [tableView reloadData];
}

- (BOOL)tableView:(UITableView *)tv shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tv editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return UITableViewCellEditingStyleNone;
}

#pragma mark -
#pragma mark Section Management

- (void) altersection:(id)sender {
	NSLog(@"Clicked Alter Section");
	//Moves from Section 2 to Section 3
	NSString *message = @"Do you want to move ";
	NSString *messageB = @" from Leads to Jobs?";
	
	message = [message stringByAppendingString:coffeeObj.coffeeName];	
	message = [message stringByAppendingString:messageB];
	
	
	
	//ActionSheet, opens in the same window
	//------------
	// open a dialog with an OK and cancel button
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
			coffeeObj.isDirty = YES;
			coffeeObj.isDetailViewHydrated = YES;
			coffeeObj.section = @"3";
		}
		
		NSString *arraycount = [NSString stringWithFormat:@"%d", coffeeObj.coffeeID];
		NSLog(@"coffeeObj.coffeeID: %@",arraycount);		
		NSLog(@"coffeeObj.coffeename:%@",coffeeObj.coffeeName);
		NSLog(@"coffeeObj.price:%@",coffeeObj.price);
		NSLog(@"coffeeObj.company:%@",coffeeObj.companyName);	
		NSLog(@"coffeeObj.section:%@",coffeeObj.section);
		NSLog(@"coffeeObj.notes:%@",coffeeObj.notes);
		NSLog(@"coffeeObj.isDirty: %@",[NSString stringWithFormat:@"%d", coffeeObj.isDirty]);
		
		//Forcing out of Editing
		[super setEditing:NO animated:YES];
		[tableView setEditing:NO animated:YES];
		self.navigationItem.leftBarButtonItem = nil;
		
		//Popping out of view
		[self.navigationController  popViewControllerAnimated:YES];
		//calling save of stuff now and reload
		
		
		//remove coffeeObj2 from appDelegate.coffeeArray2 with the above info
		[[NSNotificationCenter defaultCenter] postNotificationName: @"keyboardDoneLeads" object: nil];
		
		
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
	self.title = coffeeObj.coffeeName;
	
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
	[coffeeObj release];
    [super dealloc];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tblView {
    return 2;
}




- (NSInteger)tableView:(UITableView *)tblView numberOfRowsInSection:(NSInteger)section {

	//de.003 fix later
	switch(section) {
		case 0:
			return 1;
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

	
	static NSString *kCellIdentifier = @"cellID";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
	cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCellIdentifier] autorelease];

	cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.accessoryType = UITableViewCellAccessoryNone;	
	
	//de.005.1 Cell Setup with Image
	CGRect frame; frame.origin.x = 5; frame.origin.y = 10; frame.size.height = 20; frame.size.width = 20;
	//CGRect frameNotes = ; 
	
	//Label Cell
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
	
	//Notes Cell
	UILabel *notesLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,32,280,55)];
	notesLabel.tag = 3;
	notesLabel.backgroundColor = [UIColor clearColor];
	[cell.contentView addSubview:notesLabel];
	[notesLabel release];
	

		//Convert Price to NSNumber
		NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
		[f setNumberStyle:NSNumberFormatterDecimalStyle];
		NSNumber * somePrice2 = [f numberFromString:coffeeObj.price];
		[f release];
		
		//Convert Stored Price to Currency String in Price
		NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
		[currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
		NSString *priceFormatted = [currencyFormatter stringFromNumber:somePrice2];
	

	pageNames = [[NSArray alloc] initWithObjects:coffeeObj.companyName, priceFormatted,coffeeObj.leadDate,@"Notes",coffeeObj.notes, nil]; 


	
	//descriptions
	pageNames2 = [[NSArray alloc] initWithObjects:parameter1, parameter2, parameter3, @"", nil];
	
	//icons
	NSArray *arryImages = [(SQLAppDelegate *)[[UIApplication sharedApplication] delegate] arryImages];
	
	
	switch(indexPath.section) {
		case 0:
			cell.textLabel.text = @"";
		
			//Setup Name to Cell
			UILabel * nameLabel = (UILabel *) [cell.contentView viewWithTag:2];
			[nameLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
			nameLabel.text = coffeeObj.coffeeName;			
	
			//Setup Pic in Cell
			UIImageView *imageView = (UIImageView *) [cell.contentView viewWithTag:1];
			imageView.image = [UIImage imageNamed:@"ico-person.png"]; // set the image for the imageview

			break;
			
		case 1:
			cell.textLabel.text = @"";
			
			//Setup Name to Cell
			UILabel * nameLabel2 = (UILabel *) [cell.contentView viewWithTag:2];
			[nameLabel2 setFont:[UIFont boldSystemFontOfSize:16.0]];
			nameLabel2.text = [pageNames objectAtIndex:indexPath.row];
			
			//Setup Image in Cell
			UIImageView *imageView2 = (UIImageView *) [cell.contentView viewWithTag:1];
			imageView2.image = [arryImages objectAtIndex:[indexPath row]];
				
			//Setup DetailText in Cell
			cell.detailTextLabel.text = [pageNames2 objectAtIndex:indexPath.row];	
			cell.detailTextLabel.font = [UIFont systemFontOfSize:14];

			//Setup Custom Notes Cell to Cell
			if ([[pageNames objectAtIndex:indexPath.row] isEqualToString:@"Notes"]==TRUE) {
			NSLog(@"Setting up Cell: %@",[pageNames objectAtIndex:indexPath.row]);
				
				UILabel * notesLabel = (UILabel *) [cell.contentView viewWithTag:3];
				[notesLabel setFont:[UIFont systemFontOfSize:14.0]];
				notesLabel.text =coffeeObj.notes;
				notesLabel.numberOfLines = 3;
				notesLabel.textColor = [UIColor darkGrayColor];

			}

			break;

	}
	



	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row>2) return 90; else return 40;
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Only allow selection if editing.
	
    return (self.editing) ? indexPath : nil;

	
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {


	
	//Keep track of the row selected.
	selectedIndexPath = indexPath;
	
	if(evController == nil)
		evController = [[EditViewController alloc] initWithNibName:@"EditView" bundle:nil];
	
	//Find out which field is being edited.
	switch(indexPath.section) 
{	
		case 0:
			evController.keyOfTheFieldToEdit = @"coffeeName";
			evController.editValue = coffeeObj.coffeeName;
			break;
		
		
		case 1:		//Values Section
			
			switch (indexPath.row) {
				case 0: //companyName
					evController.keyOfTheFieldToEdit = @"CompanyName";
					evController.editValue = coffeeObj.companyName;
					break;
				case 1: //Price
					evController.keyOfTheFieldToEdit = @"Price";
					evController.editValue = coffeeObj.price;
					
					
					break;
				case 2: //Date
					evController.keyOfTheFieldToEdit = @"LeadDate";
					evController.editValue = coffeeObj.leadDate;

					break;
				case 3: //Notes:
					evController.keyOfTheFieldToEdit = @"Notes";
					evController.editValue = coffeeObj.notes;
				default:
					break;
			}

	}
	
	//Object being edited.
	evController.objectToEdit = coffeeObj;
	
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



@end
