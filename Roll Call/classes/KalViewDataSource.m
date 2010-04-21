//
//  KalViewDataSource.m
//  Roll Call
//
//  Created by Weizhi on 4/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "KalViewDataSource.h"
#import "Presence.h"
#import "Status.h"
#import "Course.h"
#import "RollSheetAddNoteController.h"


static BOOL IsDateBetweenInclusive(NSDate *date, NSDate *begin, NSDate *end)
{
	return [date compare:begin] != NSOrderedAscending && [date compare:end] != NSOrderedDescending;
}

@interface KalViewDataSource ()
- (NSArray *)presencesFrom:(NSDate *)fromDate to:(NSDate *)toDate;
@end

@implementation KalViewDataSource

@synthesize statuses, tvCell;

+ (KalViewDataSource *)dataSource
{
	return [[[[self class] alloc] init] autorelease];
}

- (id)init
{
	if ((self = [super init])) {
		items = [[NSMutableArray alloc] init];
		presences = [[NSMutableArray alloc] init];
	}
	return self;
}



- (Presence *) presenceAtIndexPath:(NSIndexPath *)indexPath
{
	return [items objectAtIndex:indexPath.row];
}

#pragma mark UITableViewDataSource protocol conformance

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	Presence *presence = [self presenceAtIndexPath:indexPath];
	static NSString *CellIdentifier = @"MyCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"KalViewCell" owner:self options:nil];
		cell = tvCell;
        self.tvCell = nil;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
	UIButton *button;
    button = (UIButton *)[cell viewWithTag:1];
	[button setTitle:presence.status.letter forState: UIControlStateNormal];
	[button setBackgroundImage:[UIImage imageNamed:presence.status.imageName] forState:UIControlStateNormal];
    UILabel *label = (UILabel *)[cell viewWithTag:2];
	label.textAlignment=UITextAlignmentCenter;
	label.text = presence.course.name;
	
	UILabel *dateLabel = (UILabel *)[cell viewWithTag:3];
	dateLabel.textAlignment=UITextAlignmentRight;
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"EEEE, ha"];
	NSDate *date=presence.date;
	NSString *theDate = [dateFormat stringFromDate:date];
	dateLabel.text =[NSString stringWithFormat:@"%@", theDate];
	
	
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [items count];
}

- (BOOL)comparedate:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate
{
	if ([date compare:beginDate] == NSOrderedAscending)
		return NO;
			
	if ([date compare:endDate] == NSOrderedDescending) 
		return NO;
			
	return YES;
}
		 
- (void)loadPresencesFrom:(NSDate *)fromDate to:(NSDate *)toDate delegate:(id<KalDataSourceCallbacks>)delegate
{
	
	for (Presence *p in statuses) {
		if ([self comparedate: p.date isBetweenDate:fromDate andDate:toDate])
			if (![p.status.letter isEqualToString:@"P"])
				[presences addObject:p];
	}
	[delegate loadedDataSource:self];
}

#pragma mark KalDataSource protocol conformance

- (void)presentingDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate delegate:(id<KalDataSourceCallbacks>)delegate
{
	[presences removeAllObjects];
	[self loadPresencesFrom:fromDate to:toDate delegate:delegate];
}

- (NSArray *)markedDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate
{
	return [[self presencesFrom:fromDate to:toDate] valueForKeyPath:@"date"];
}

- (void)loadItemsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
{
	[items addObjectsFromArray:[self presencesFrom:fromDate to:toDate]];
}

- (void)removeAllItems
{
	[items removeAllObjects];
}

#pragma mark -

- (NSArray *)presencesFrom:(NSDate *)fromDate to:(NSDate *)toDate
{
	NSMutableArray *matches = [NSMutableArray array];
	for (Presence *presence in presences)
		if (IsDateBetweenInclusive(presence.date, fromDate, toDate))
			[matches addObject:presence];
	
	return matches;
}



- (void)dealloc
{
	[items release];
	[presences release];
	[super dealloc];
}

@end
