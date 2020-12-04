//
//  RootViewController.m
//  SQL
//
//  Created by iPhone SDK Articles on 10/26/08.
//  Copyright 2008 www.iPhoneSDKArticles.com.
//

#import "RootViewController.h"
#import "Leads.h";
#import "Jobs.h";
#import "Invoices.h";
#import "AddViewController.h"
#import "DetailViewController.h"

@implementation RootViewController



#pragma mark -
#pragma mark The Rest

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [appDelegate.coffeeArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
	

	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		CGRect frame; frame.origin.x = 5; frame.origin.y = 10; frame.size.height = 20; frame.size.width = 20;
		
		//Print Icon
		UIImageView *imgLabel = [[UIImageView alloc] initWithFrame:frame];
		imgLabel.tag = 1;
		[cell.contentView addSubview:imgLabel];
		[imgLabel release];

		//Print Text
		frame.origin.x = 30; 
		frame.size.width = 200;	
		UILabel *nameLabel = [[UILabel alloc] initWithFrame:frame];
		nameLabel.tag = 2;
		[cell.contentView addSubview:nameLabel];
		[nameLabel release];

		//Print Value
		frame.origin.x = 180; 
		frame.size.width = 80;	
		UILabel *valueLabel = [[UILabel alloc] initWithFrame:frame];
		valueLabel.tag = 3;
		[cell.contentView addSubview:valueLabel];
		[valueLabel release];
		
		
		

		
    }
	
	//Get the object from the array.
	Leads *coffeeObj = [appDelegate.coffeeArray objectAtIndex:indexPath.row];
	
	//Convert Price to NSNumber
	NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
	[f setNumberStyle:NSNumberFormatterDecimalStyle];
	NSNumber * somePrice2 = [f numberFromString:coffeeObj.price];
	[f release];
	
	//Convert Stored Price to Currency String in Price
	NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
	[currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
	//coffeeObj.price = [currencyFormatter stringFromNumber:somePrice2];
	
	
	//Setup Name to Cell
	UILabel * nameLabel = (UILabel *) [cell.contentView viewWithTag:2];
	[nameLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
	nameLabel.text = coffeeObj.coffeeName;
	nameLabel.backgroundColor = [UIColor clearColor];

	//Setup Pic in Cell
	UIImageView *imageView = (UIImageView *) [cell.contentView viewWithTag:1];
	imageView.image = [UIImage imageNamed:@"ico-person.png"]; // set the image for the imageview

	//Setup Value to Cell
	UILabel * valueLabel = (UILabel *) [cell.contentView viewWithTag:3];
	[valueLabel setFont:[UIFont	systemFontOfSize:14.0]];
	valueLabel.text = [currencyFormatter stringFromNumber:somePrice2];
	valueLabel.backgroundColor = [UIColor clearColor];
	valueLabel.textAlignment = UITextAlignmentRight;
	
	//Set the accessory type.
	cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;


    // Set up the cell
    return cell;

}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	

	
    // Navigation logic -- create and push a new view controller
	
	if(dvController == nil) 
		dvController = [[DetailViewController alloc] initWithNibName:@"DetailView" bundle:nil];
	
	Leads *coffeeObj = [appDelegate.coffeeArray objectAtIndex:indexPath.row];
	
	//Get the detail view data if it does not exists.
	//We only load the data we initially want and keep on loading as we need.
	[coffeeObj hydrateDetailViewData];
	
	dvController.coffeeObj = coffeeObj;

	//Set Row Number pressed
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

	int indexTemp = indexPath.row;
	[[NSUserDefaults standardUserDefaults] setInteger:indexTemp forKey:@"TopScore"];
	[defaults synchronize];
	
	
	[self.navigationController pushViewController:dvController animated:YES];
	

	
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] 
											 initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
											 target:self action:@selector(add_Clicked:)];
	
	appDelegate = (SQLAppDelegate *)[[UIApplication sharedApplication] delegate];
	 
	self.title = @"Leads";
	self.view.backgroundColor = [UIColor clearColor];
	
	//MicroCRM Nice Blue 
	self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.12 green:0.45 blue:0.87 alpha:0.9];

	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(removeItemfromLeads:) name: @"keyboardDoneLeads" object: nil];

}


- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if(editingStyle == UITableViewCellEditingStyleDelete) {
		
		//Get the object to delete from the array.
		Leads *coffeeObj = [appDelegate.coffeeArray objectAtIndex:indexPath.row];
		[appDelegate removeLeads:coffeeObj];
		
		//Delete the object from the table.
		[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}
}


/*
 // Override to support conditional editing of the list
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support rearranging the list
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the list
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	[self.tableView reloadData];
	
	//de.009 - FirstRun Image if ArrayCount is 0
	[firstRunImage removeFromSuperview];
	int InvoiceCount = [appDelegate.coffeeArray count];
	NSString *arraycount = [NSString stringWithFormat:@"%d", InvoiceCount];
	NSLog (@"Leads Page Loaded: %@ Entries",arraycount);
	if (InvoiceCount==0) {
		
		NSLog (@"Adding First Run Image");
		
		firstRunImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img-FirstRun.png"]];
		firstRunImage.frame = CGRectMake(0,0,320,100);
		[self.view addSubview:firstRunImage];
		
	} else {
		[firstRunImage removeFromSuperview];
		[firstRunImage release], firstRunImage=nil;
	}
	
	
	//MicroCRM Nice Blue 
	self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.12 green:0.45 blue:0.87 alpha:0.9];

}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	
	[super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:YES];
	
	//Do not let the user add if the app is in edit mode.
	if(editing)
		self.navigationItem.leftBarButtonItem.enabled = NO;
	else
		self.navigationItem.leftBarButtonItem.enabled = YES;
	


}	


/*
- (void)viewWillDisappear:(BOOL)animated {
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
}
*/

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void) add_Clicked:(id)sender {
	
	if(avController == nil)
		avController = [[AddViewController alloc] initWithNibName:@"AddView" bundle:nil];
	
	if(addNavigationController == nil)
		addNavigationController = [[UINavigationController alloc] initWithRootViewController:avController];
	
	[self.navigationController presentModalViewController:addNavigationController animated:YES];
}


- (void)dealloc {
	[dvController release];
	[addNavigationController release];
	[avController release];
    [super dealloc];
}

#pragma mark -
#pragma mark Contact Link
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{;	

	//Get the object from the array.
	Leads *coffeeObj = [appDelegate.coffeeArray objectAtIndex:indexPath.row];
	
	//Setup Name to Cell
	NSLog(@"Clicked Person Name: %@",coffeeObj.coffeeName);
	NSLog(@"Clicked Person ID: %@",coffeeObj.personID);
	
	NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
	[f setNumberStyle:NSNumberFormatterDecimalStyle];
	NSNumber * recordId = [f numberFromString:coffeeObj.personID];
	[f release];
	

	//NSNumber *recordId = [NSNumber numberWithInteger:11];

	NSLog(@"Looking Up Contact Now");
	ABAddressBookRef ab = ABAddressBookCreate();
	ABPersonViewController *pvc = [[ABPersonViewController alloc] init];
	ABRecordRef person = ABAddressBookGetPersonWithRecordID(ab,recordId.integerValue);
	pvc.displayedPerson = person;
	pvc.addressBook = ab;
	pvc.allowsEditing = YES;

		if (person != nil) {
			self.navigationController.navigationBar.tintColor = [UIColor colorWithHue:0.6 saturation:0.33 brightness:0.69 alpha:0];
			[[self navigationController] pushViewController:pvc animated:YES];
			} else {
				UIAlertView *baseAlert = [[UIAlertView alloc]  initWithTitle:@"Address Link" message:@"Sorry, no address book link available" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
				[baseAlert show];
			}

	
	[pvc release];

}

-(void)removeItemfromLeads: (NSNotification*)notification {
	
	int rowID = [[NSUserDefaults standardUserDefaults] integerForKey:@"TopScore"];
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowID inSection:0];
	NSLog(@"-----");NSLog(@"in removeItemfromLeads");
	Leads *coffeeObj = [appDelegate.coffeeArray objectAtIndex:indexPath.row];

	
	[appDelegate.coffeeArray removeObject:coffeeObj];	
	[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
	
	//Add the object to Database
	Jobs *coffeeObj2 = [[Jobs alloc] initWithPrimaryKey:0];
	coffeeObj2.coffeeName = coffeeObj.coffeeName;
	coffeeObj2.price = coffeeObj.price;
	coffeeObj2.companyName = coffeeObj.companyName;
	coffeeObj2.LeadDate = coffeeObj.leadDate;
	coffeeObj2.notes = coffeeObj.notes;
	coffeeObj2.clientID = coffeeObj.clientID;
	coffeeObj2.personID = coffeeObj.personID;
	[appDelegate addJobs:coffeeObj2]; 

	NSLog(@"coffeeObj Notes: %@",coffeeObj.notes);
	NSLog(@"coffeeObj2 price: %@",coffeeObj.price);
	NSLog(@"coffeeObj2 Notes: %@",coffeeObj2.notes);
	
	//remove coffeeObj2 from Database
	[appDelegate removeLeads:coffeeObj];
	
	
	
	
}



@end

