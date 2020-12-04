//
//  Leads.h
//  SQL
//
//  Created by iPhone SDK Articles on 10/26/08.
//  Copyright 2008 www.iPhoneSDKArticles.com.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface Jobs : NSObject {
	
	NSInteger coffeeID;
	NSString *coffeeName;
	NSString *price;
	NSString *companyName;
	NSString *LeadDate;
	NSString *notes;
	NSString *section;
	NSString *clientID;
	NSString *personID;
	
	//Intrnal variables to keep track of the state of the object.
	BOOL isDirty;
	BOOL isDetailViewHydrated;
}

@property (nonatomic, readonly) NSInteger coffeeID;
@property (nonatomic, copy) NSString *coffeeName;
@property (nonatomic, copy) NSString *price;
//de.001 adding Custom Parameters
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *LeadDate;
@property (nonatomic, copy) NSString *notes;
@property (nonatomic, copy) NSString *section;
@property (nonatomic, copy) NSString *clientID;
@property (nonatomic, copy) NSString *personID;

@property (nonatomic, readwrite) BOOL isDirty;
@property (nonatomic, readwrite) BOOL isDetailViewHydrated;

//Static methods.
+ (void) getInitialDataToDisplay:(NSString *)dbPath;
+ (void) finalizeStatements;

//Instance methods.
- (id) initWithPrimaryKey:(NSInteger)pk;
- (void) deleteJobs;
- (void) addJobs;
- (void) hydrateDetailViewData;
- (void) saveAllDataJobs;

@end
