//
//  ChangeDateViewController.h
//  Roll Call
//
//  Created by Kyle Conroy on Apr30.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChangeDateViewController;

@protocol DateChangeDelegate <NSObject>

- (void)changeDateViewController:(ChangeDateViewController *)changeDateViewController

                   didChangeDate:(NSDate *)date;

@end

@interface ChangeDateViewController : UIViewController {
    
    IBOutlet UIDatePicker *myPickerView;
    NSDate *myDate;
    id <DateChangeDelegate> delegate;
    
}

@property(nonatomic, retain) IBOutlet UIDatePicker *myPickerView;
@property(nonatomic, retain) NSDate *myDate;
@property (nonatomic, assign) id <DateChangeDelegate> delegate;

- (IBAction) doneDate;
- (IBAction) cancelDate;

@end
