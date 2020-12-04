//
//  EditViewController.m
//  SQL
//
//  Created by Jai Kirdatt on 11/1/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

//UIAlertView *baseAlert2 = [[UIAlertView alloc]  initWithTitle:@"" message:@"made it to hide keyboard" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//[baseAlert2 show];

#import "EditViewController.h"
#import "DetailViewController.h"


@implementation EditViewController

@synthesize objectToEdit, keyOfTheFieldToEdit, keyboard, editValue;



// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
	

	
}


- (void)viewWillAppear:(BOOL)animated {
	
	txtField.placeholder = [self.keyOfTheFieldToEdit capitalizedString];
	txtField.text = self.editValue;
	txtField.textAlignment = UITextAlignmentLeft;
	
	// hide notes objects
	txtField.hidden = NO;
	txtBackground.hidden = NO;
	txtNotesField.hidden = YES;
	txtNotesBackground.hidden = YES;
		txtNotesField.editable = NO;
	//hide date picker
	pickerView.hidden = YES;
	
	[timer invalidate];
	timer = nil;
	
	//[super viewWillAppear:animated];
	[super viewWillAppear:YES];
	
	if(keyOfTheFieldToEdit == @"coffeeName"){
		self.title = @"Lead Name";
		
		//defaults
		txtField.enabled = YES;
		txtField.placeholder = @"Name";
		txtField.keyboardType =	UIKeyboardTypeNamePhonePad; //set keyboard to the 9 digit numberpad } 
		[txtField becomeFirstResponder];
		
		//Set Icon
		imgView.image = [UIImage imageNamed:@"ico-person.png"];
		
		
	} else if (keyOfTheFieldToEdit == @"Price") {
		self.title = @"Lead Value";
		
		//txtField.hidden = NO;
		txtField.enabled = YES;
		txtField.placeholder = @"Estimated Lead Value";
		txtField.keyboardType =	UIKeyboardTypeNumberPad;  //set keyboard to the 9 digit numberpad } 
		[txtField becomeFirstResponder];
		keyboard = @"";
		pickerView.hidden = YES;
		
		//Set Icon
		imgView.image = [UIImage imageNamed:@"ico-value.png"];
		
	
		txtField.text = self.editValue;
		
	} else if (keyOfTheFieldToEdit == @"CompanyName") {
		self.title = @"Company";
		
		
		//defaults
		txtField.enabled = YES;
		txtField.placeholder = @"Company";
		txtField.keyboardType =	UIKeyboardTypeNamePhonePad; //set keyboard to the 9 digit numberpad } 
		[txtField becomeFirstResponder];
		
		//Set Icon
		imgView.image = [UIImage imageNamed:@"ico-company.png"];
		
		
		
	} else if (keyOfTheFieldToEdit == @"LeadDate") {
		self.title = @"Invoice Date";
		
		txtField.hidden = NO;
		txtField.textAlignment = UITextAlignmentCenter	;
		
		//dismissKeyboard;
		txtField.enabled = NO;

		
		NSLog(@"editvalue is %@", editValue);
		
		NSString *dateStr = editValue;
		
		// Convert string to date object
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
		[dateFormat setDateFormat:@"MMMM d, yyyy"];
		NSDate *date = [dateFormat dateFromString:dateStr];  
		
		NSLog(@"dateStr is %@", dateStr);
		NSLog(@"date is %@", date);
		
		// Add the date picker
		float height = 216.0f;
		pickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0f, 370.0f - height, 320.0f, height)];
		pickerView.datePickerMode = UIDatePickerModeDate;
		[pickerView addTarget:self action:@selector(changedDate:) forControlEvents:UIControlEventValueChanged];
		[self.view addSubview:pickerView];
		
		[pickerView setDate: date animated:YES];		//set the date  -working
		[pickerView release];
		
		txtField.text = self.editValue;
		
		
		//Set Icon
		imgView.image = [UIImage imageNamed:@"ico-date.png"];
		
		
		
	} else if (keyOfTheFieldToEdit == @"Notes") {
		self.title = @"Notes";

		
		// unhide notes objects
		txtNotesField.hidden = NO;
		txtNotesBackground.hidden = NO;
		txtNotesField.editable = YES;
		//hide other field
		txtField.hidden = YES;
		txtBackground.hidden = YES;
		
		[txtNotesField setEditable:YES];
		[txtNotesField setText:editValue];
		[txtNotesField becomeFirstResponder];
		
		//NSLog(@"timerInt Initialised");
		timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerVoid) userInfo:nil repeats:YES];
		
		pickerView.hidden = YES;
		
		//Set Icon
		imgView.image = [UIImage imageNamed:@""];
		
		
	} 
	
	
	
	
	
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
	[txtField release];
	[editValue release];
	[keyOfTheFieldToEdit release];
	[objectToEdit release];
	[keyboard release];
    [super dealloc];

}

- (IBAction) save_Clicked:(id)sender {


	NSLog(@"Value Modified, Value = %@",txtField.text);
	NSLog(@"KeyOfTheField = %@",self.keyOfTheFieldToEdit);	


	[objectToEdit setValue:txtField.text forKey:self.keyOfTheFieldToEdit];
	
	//de.004 - Update text cell with new view window layout
	//Pop back to the detail view.
	//[self.navigationController popViewControllerAnimated:YES];
	
}

- (void) changedDate: (UIDatePicker *) picker
{
	NSLog(@"In changedDate playing with NSDate");
	
	//Trying new solution
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat:@"MMMM d, yyyy"];
	NSString *caldate2 = [formatter stringFromDate:[picker date]];
	
	NSLog(@"NSDateFormatter (Apple Says Good): %@",caldate2);
	
	txtField.text = caldate2;

	//de.004 - Update text cell with new view window layout
	[objectToEdit setValue:txtField.text forKey:self.keyOfTheFieldToEdit];
	
}

	
	-(void)timerVoid {
		//Workaround timer to get notes to save correctly		
		
		//Runs the following
		[objectToEdit setValue:txtNotesField.text forKey:self.keyOfTheFieldToEdit];

		
}




	

@end
