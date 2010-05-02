//
//  StatusInstanceViewController.h
//  Roll Call
//
//  Created by Kyle Conroy on Apr30.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Status.h"
#import "EditTextFieldViewController.h"
#import "EditStatusColorViewController.h"
#import "Roll_CallAppDelegate.h"

@class AddStatusViewController;

@protocol AddStatusDelegate <NSObject>

- (void)addStatusViewController:(AddStatusViewController *)addStatusViewController

                       withText:(NSString *)text letter:(NSString *)letter imageName:(NSString *)imageName;

@end

@interface AddStatusViewController : UITableViewController <EditTextFieldDelegate, ColorChangeDelegate> {
    id <AddStatusDelegate> delegate;
    Roll_CallAppDelegate *aD;
    NSArray *myTableLayout;
    IBOutlet UITableView * myTableView; 
    NSString *imageName;
    NSString *text;
    NSString *letter;
}


@property (nonatomic, assign) id <AddStatusDelegate> delegate;
@property(nonatomic, retain) NSArray *myTableLayout;
@property(nonatomic, retain) IBOutlet UITableView * myTableView;
@property(nonatomic, assign) Roll_CallAppDelegate *aD;
@property(nonatomic, assign) NSString *imageName;
@property(nonatomic, assign) NSString *text;
@property(nonatomic, assign) NSString *letter;

- (void) save;
- (void) cancel;

@end
