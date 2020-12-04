//
//  EditViewController.h
//  SQL
//
//  Created by Jai Kirdatt on 11/1/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface EditViewController : UIViewController <UITextViewDelegate> {
	
	IBOutlet UITextField *txtField;
	IBOutlet UIButton *txtBackground;
	IBOutlet UITextView *txtNotesField;
	IBOutlet UIButton *txtNotesBackground;
	IBOutlet UIImageView *imgView;
	
	NSString *keyOfTheFieldToEdit;
	NSString *editValue;
	NSString *keyboard;
	id objectToEdit;
	
	//datespinner
	UIDatePicker *pickerView;

	//timer
	NSTimer	*timer;

	
}

@property (nonatomic, retain) id objectToEdit;
@property (nonatomic, retain) NSString *keyOfTheFieldToEdit;
@property (nonatomic, retain) NSString *editValue;
@property (nonatomic, retain) NSString *keyboard;


- (IBAction) save_Clicked: (id)sender;		//still used


@end
