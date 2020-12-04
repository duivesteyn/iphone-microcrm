//
//  Leads.m
//  SQL
//
//  Created by iPhone SDK Articles on 10/26/08.
//  Copyright 2008 www.iPhoneSDKArticles.com.
//

#import "Leads.h"

static sqlite3 *database = nil;
static sqlite3_stmt *deleteStmt = nil;
static sqlite3_stmt *addStmt = nil;
static sqlite3_stmt *detailStmt = nil;
static sqlite3_stmt *updateStmt = nil;

NSInteger currencyisworking = 0;

@implementation Leads

//de.001 adding Company Info too //NSString - companyName

@synthesize coffeeID, coffeeName, price, companyName, leadDate, notes, isDirty, section, clientID, personID, isDetailViewHydrated;

+ (void) getInitialDataToDisplay:(NSString *)dbPath {
	
	SQLAppDelegate *appDelegate = (SQLAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
		
		const char *sql = "select coffeeID, coffeeName, price, companyName, leadDate, Notes, ABRecordRef from Leads where section = 1";
		sqlite3_stmt *selectstmt;
		if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
			
			while(sqlite3_step(selectstmt) == SQLITE_ROW) {
				
				NSInteger primaryKey = sqlite3_column_int(selectstmt, 0);
				Leads *coffeeObj = [[Leads alloc] initWithPrimaryKey:primaryKey];
				coffeeObj.coffeeName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 1)];
				//de.002 added line for companyName
				coffeeObj.price = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 2)];
				coffeeObj.companyName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 3)];
				coffeeObj.leadDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 4)];
				coffeeObj.notes = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 5)];

				coffeeObj.personID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 6)];			

				
				
				coffeeObj.isDirty = NO;
				
				[appDelegate.coffeeArray addObject:coffeeObj];
				[coffeeObj release];
			}
							
		}
	}
	else
		sqlite3_close(database); //Even though the open call failed, close the database connection to release all the memory.

	int InvoiceCount = [appDelegate.coffeeArray count];
	NSString *string = [NSString stringWithFormat:@"%d", InvoiceCount];
	NSLog (@"Leads Page Loaded: %@ Entries",string);
}

+ (void) finalizeStatements {
	
	if (database) sqlite3_close(database);
	if (deleteStmt) sqlite3_finalize(deleteStmt);
	if (addStmt) sqlite3_finalize(addStmt);
	if (detailStmt) sqlite3_finalize(detailStmt);
	if (updateStmt) sqlite3_finalize(updateStmt);
}

- (id) initWithPrimaryKey:(NSInteger) pk {
	
	[super init];
	coffeeID = pk;
	
	isDetailViewHydrated = NO;
	
	return self;
}

- (void) deleteLeads {
	
	if(deleteStmt == nil) {
		const char *sql = "delete from Leads where coffeeID = ?";
		if(sqlite3_prepare_v2(database, sql, -1, &deleteStmt, NULL) != SQLITE_OK)
			NSAssert1(0, @"Error while creating delete statement. '%s'", sqlite3_errmsg(database));
	}
	
	//When binding parameters, index starts from 1 and not zero.
	sqlite3_bind_int(deleteStmt, 1, coffeeID);
	
	if (SQLITE_DONE != sqlite3_step(deleteStmt)) 
		NSAssert1(0, @"Error while deleting. '%s'", sqlite3_errmsg(database));
	
	sqlite3_reset(deleteStmt);
}

- (void) addLeads {

	if(addStmt == nil) {
		const char *sql = "insert into Leads(CoffeeName, Price, CompanyName, LeadDate, notes, section, ClientID, ABRecordRef) Values(?, ?, ?, ?, ?, ?, ?, ?)";
		if(sqlite3_prepare_v2(database, sql, -1, &addStmt, NULL) != SQLITE_OK)
			NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
	}
	
	sqlite3_bind_text(addStmt, 1, [coffeeName UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(addStmt, 2, [price UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(addStmt, 3, [companyName UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(addStmt, 4, [leadDate UTF8String], -1, SQLITE_TRANSIENT);
	notes = @"";
	sqlite3_bind_text(addStmt, 5, [notes UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(addStmt, 6, [@"1" UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(addStmt, 7, [@"000" UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(addStmt, 8, [personID UTF8String], -1, SQLITE_TRANSIENT);
	
	if(SQLITE_DONE != sqlite3_step(addStmt))
		NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
	else
		//SQLite provides a method to get the last primary key inserted by using sqlite3_last_insert_rowid
		coffeeID = sqlite3_last_insert_rowid(database);
	
	//Reset the add statement.
	sqlite3_reset(addStmt);
}



- (void) hydrateDetailViewData {
	
	//If the detail view is hydrated then do not get it from the database.
	if(isDetailViewHydrated) return;
	
	if(detailStmt == nil) {
		const char *sql = "Select price from Leads Where CoffeeID = ?";
		if(sqlite3_prepare_v2(database, sql, -1, &detailStmt, NULL) != SQLITE_OK)
			NSAssert1(0, @"Error while creating detail view statement. '%s'", sqlite3_errmsg(database));
	}
	
	sqlite3_bind_int(detailStmt, 1, coffeeID);
	
	//Reset the detail statement.
	sqlite3_reset(detailStmt);
	
	
	
	//Set isDetailViewHydrated as YES, so we do not get it again from the database.
	isDetailViewHydrated = YES;
}

- (void) saveAllDataLeads {
	section = @"1";
	NSLog(@"saving Data from Leads.m");
	
	if(isDirty) {
		
		if(updateStmt == nil) {
			const char *sql = "update Leads Set CoffeeName = ?, Price = ?, CompanyName = ?, LeadDate = ?, Notes = ?, ClientID = ?, ABRecordRef = ? Where CoffeeID = ?";
			if(sqlite3_prepare_v2(database, sql, -1, &updateStmt, NULL) != SQLITE_OK) 
				NSAssert1(0, @"Error while creating update statement. '%s'", sqlite3_errmsg(database));
		}
		
		sqlite3_bind_text(updateStmt, 1, [coffeeName UTF8String], -1, SQLITE_TRANSIENT);
	

		
		if (price == nil) price = @"0";
		if (price == @"") price = @"0";
		
		sqlite3_bind_text(updateStmt, 2, [price UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(updateStmt, 3, [companyName UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(updateStmt, 4, [leadDate UTF8String], -1, SQLITE_TRANSIENT);

		if (notes == nil) notes = @"";
		sqlite3_bind_text(updateStmt, 5, [notes UTF8String], -1, SQLITE_TRANSIENT);
		
		if (clientID == nil) clientID = @"";
		sqlite3_bind_text(updateStmt, 6, [clientID UTF8String], -1, SQLITE_TRANSIENT);
		
		if (personID == nil) personID = @"0";
		sqlite3_bind_text(updateStmt, 7, [personID UTF8String], -1, SQLITE_TRANSIENT);
		
		sqlite3_bind_int(updateStmt, 8, coffeeID);
		
		if(SQLITE_DONE != sqlite3_step(updateStmt))
			NSAssert1(0, @"Error while updating. '%s'", sqlite3_errmsg(database));
		
		sqlite3_reset(updateStmt);
		
		isDirty = NO;
	}
	
	//Reclaim all memory here.
	[coffeeName release];
	coffeeName = nil;
	[price release];
	price = nil;
	[companyName release];
	companyName = nil;
	[leadDate release];
	leadDate = nil;
	[notes release];
	notes = nil;
	[clientID release];
	clientID = nil;
	[personID release];
	personID = nil;
	
	isDetailViewHydrated = NO;
}

- (void) setCoffeeName:(NSString *)newValue {
	
	self.isDirty = YES;
	[coffeeName release];
	coffeeName = [newValue copy];
}

- (void) setPrice:(NSString *)newValue {
	
	self.isDirty = YES;
	[price release];
	price = [newValue copy];
}

- (void) setCompanyName:(NSString *)newValue {
	
	self.isDirty = YES;
	[companyName release];
	companyName = [newValue copy];
}

- (void) setLeadDate:(NSString *)newValue {
	
	self.isDirty = YES;
	[leadDate release];
	leadDate = [newValue copy];
}

- (void) setNotes:(NSString *)newValue {
	
	self.isDirty = YES;
	[notes release];
	notes = [newValue copy];
}

- (void) setSection:(NSString *)newValue {
	
	self.isDirty = YES;
	[section release];
	section = [newValue copy];
}
- (void) setClientID:(NSString *)newValue {
	
	self.isDirty = YES;
	[clientID release];
	clientID = [newValue copy];
}
- (void) setPersonID:(NSString *)newValue {
	
	self.isDirty = YES;
	[personID release];
	personID = [newValue copy];
}


- (void) dealloc {
	
	[companyName release];
	[leadDate release];
	[price release];
	[coffeeName release];
	[clientID release];
	[notes release];
	[super dealloc];
}

@end
