//
//  KalViewDataSource.h
//  Roll Call
//
//  Created by Weizhi on 4/16/10.
//  Copyright 2010 Weizhi Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Kal.h"

@class Presence;
@class StudentViewController;

@interface KalViewDataSource : NSObject <KalDataSource, UITableViewDelegate>{
		
	NSMutableArray *items;
	NSMutableArray *presences;
	NSMutableArray *statuses;
	IBOutlet UITableViewCell *tvCell;
	KalViewController *kal;
	NSString *name;
}

@property (nonatomic, retain) NSMutableArray *statuses;
@property (nonatomic, retain) IBOutlet UITableViewCell *tvCell;
@property (nonatomic, retain) KalViewController *kal;
@property (nonatomic, retain) NSString *name;

+ (KalViewDataSource *)dataSource;
- (Presence *)presenceAtIndexPath:(NSIndexPath *)indexPath; 
- (BOOL)comparedate:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate;

@end
