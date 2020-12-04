//
//  RootViewController.m
//  SQL
//
//  Created by iPhone SDK Articles on 10/26/08.
//  Copyright 2008 www.iPhoneSDKArticles.com.
//

#import "InvoicesViewController.h"
#import "Invoices.h";
#import "AddViewController3.h"
#import "DetailViewController3.h"

@implementation InvoicesViewController

#pragma mark -
#pragma mark The Rest



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [appDelegate.coffeeArray3 count];
	
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
	Invoices *coffeeObj3 = [appDelegate.coffeeArray3 objectAtIndex:indexPath.row];
	
	//Convert Price to NSNumber
	NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
	[f setNumberStyle:NSNumberFormatterDecimalStyle];
	NSNumber * somePrice2 = [f numberFromString:coffeeObj3.price];
	[f release];
	
	//Convert Stored Price to Currency String in Price
	NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
	[currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
	//coffeeObj3.price = [currencyFormatter stringFromNumber:somePrice2];

	
	//Setup Name to Cell
	UILabel * nameLabel = (UILabel *) [cell.contentView viewWithTag:2];
	[nameLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
	nameLabel.text = coffeeObj3.coffeeName;
	nameLabel.backgroundColor = [UIColor clearColor];


	//Setup Pic in Cell
	UIImageView *imageView = (UIImageView *) [cell.contentView viewWithTag:1];
	imageView.image = [UIImage imageNamed:@"ico-invoice.png"]; // set the image for the imageview
	
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
	
	if(dvController3 == nil) 
		dvController3 = [[DetailViewController3 alloc] initWithNibName:@"DetailView3" bundle:nil];
	
	Invoices *coffeeObj3 = [appDelegate.coffeeArray3 objectAtIndex:indexPath.row];
	
	//Get the detail view data if it does not exists.
	//We only load the data we initially want and keep on loading as we need.
	[coffeeObj3 hydrateDetailViewData];
	
	dvController3.coffeeObj3 = coffeeObj3;
	
	[self.navigationController pushViewController:dvController3 animated:YES];
	
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] 
											 initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
											 target:self action:@selector(add_Clicked:)];
	
	appDelegate = (SQLAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	self.title = @"Invoices";
	self.view.backgroundColor = [UIColor clearColor];
	
	//MicroCRM Nice Blue 
	self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.12 green:0.45 blue:0.87 alpha:0.9];

	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(removeItemfromInvoices:) name: @"keyboardDoneInvoices" object: nil];

}


- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if(editingStyle == UITableViewCellEditingStyleDelete) {
		
		//Get the object to delete from the array.
		Invoices *coffeeObj3 = [appDelegate.coffeeArray3 objectAtIndex:indexPath.row];
		[appDelegate removeInvoices:coffeeObj3];
		
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
	int InvoiceCount = [appDelegate.coffeeArray3 count];
	NSString *array3count = [NSString stringWithFormat:@"%d", InvoiceCount];
	NSLog (@"Invoices Page Loaded: %@ Entries",array3count);
	if (InvoiceCount==0) {
		
		NSLog (@"Adding First Run Image");
		
		firstRunImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img-FirstRun3.png"]];
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
	
	if(avController3 == nil)
		avController3 = [[AddViewController3 alloc] initWithNibName:@"AddView3" bundle:nil];
	
	if(addNavigationController == nil)
		addNavigationController = [[UINavigationController alloc] initWithRootViewController:avController3];
	
	[self.navigationController presentModalViewController:addNavigationController animated:YES];
}


- (void)dealloc {
	[dvController3 release];
	[addNavigationController release];
	[avController3 release];
    [super dealloc];
}

#pragma mark -
#pragma mark Contact Link

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{;	

	//Get the object from the array.
	Invoices *coffeeObj3 = [appDelegate.coffeeArray3 objectAtIndex:indexPath.row];
	
	//Setup Name to Cell
	NSLog(@"Clicked Person Name: %@",coffeeObj3.coffeeName);
	NSLog(@"Clicked Person ID: %@",coffeeObj3.personID);
	
	NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
	[f setNumberStyle:NSNumberFormatterDecimalStyle];
	NSNumber * recordId = [f numberFromString:coffeeObj3.personID];
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




@end

