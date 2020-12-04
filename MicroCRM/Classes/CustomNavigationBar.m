//
//  BISNavigationBar.m
//  NavigationColor
//
//  Created by Gaurav Verma on 24/12/09.
//

#import "CustomNavigationBar.h"


@implementation CustomNavigationBar


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
	// Drawing code
	UIImage *image = [[UIImage imageNamed:@"topNavBar.png"] retain];
	[image drawInRect:rect];
	[image release];

}

#pragma mark -
#pragma mark UINavigationDelegate Methods

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
	NSString *title = [viewController title];
	UILabel *myTitleView = [[UILabel alloc] init];
	[myTitleView setFont:[UIFont boldSystemFontOfSize:18]];
	[myTitleView setTextColor:[UIColor yellowColor]];
	myTitleView.text = title;
	myTitleView.backgroundColor = [UIColor clearColor];
	[myTitleView sizeToFit];
	viewController.navigationItem.titleView = myTitleView;
	[myTitleView release];
	
	viewController.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.16f green:0.36f blue:0.46 alpha:0.8];
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
}


- (void)dealloc {
    [super dealloc];
}


@end
