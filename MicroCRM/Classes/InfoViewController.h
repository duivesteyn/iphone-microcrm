//
//  FourthViewController.h
//  ORBooks
//
//  Created by Benjamin M. Duivesteyn on 3/01/10.
//  Copyright 2010 TBA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "Leads.h"
#import "Jobs.h"
#import "Invoices.h"


@interface InfoViewController : UIViewController <MFMailComposeViewControllerDelegate>  {

	//de001 - About Page
	IBOutlet UIView *secondaryView;
	IBOutlet UIView *helpView;
	
	//de002 - Help Page
	IBOutlet UIScrollView *scrollView2;	// holds one large image to scroll in both directions
	
	//de013 - Test Export Screen
	SQLAppDelegate *appDelegate;
	
}
//de002 - Help Page
@property (nonatomic, retain) UIView *scrollView2;

//de001 - About Page
- (IBAction)toggleView:(id)sender; //Action for toggle view
- (IBAction)returnView:(id)sender;
- (IBAction)toggleViewhelp:(id)sender; //Action for toggle view
- (IBAction)returnViewhelp:(id)sender;

- (IBAction)presentSettings;

- (IBAction)presentEmailExport;
-(void)displayComposerSheetExport;
-(void)launchMailAppOnDevice;

- (IBAction)presentEmailFeedback;
-(void)displayComposerSheetFeedback;


- (IBAction)presentTwitter;




@end
