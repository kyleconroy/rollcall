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

@interface KalViewDataSource : NSObject <KalDataSource>{
		
	NSMutableArray *items;
	NSMutableArray *presences;
	NSMutableArray *statuses;
	IBOutlet UITableViewCell *tvCell;
}

@property (nonatomic, retain) NSMutableArray *statuses;
@property (nonatomic, retain) IBOutlet UITableViewCell *tvCell;

+ (KalViewDataSource *)dataSource;
- (Presence *)presenceAtIndexPath:(NSIndexPath *)indexPath; 
- (BOOL)comparedate:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate;

@end
