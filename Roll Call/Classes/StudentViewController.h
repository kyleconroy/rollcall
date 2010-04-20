//
//  StudentViewController.h
//  Roll Call
//
//  Created by Weizhi Li on Mar22.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Roll_CallAppDelegate.h"
#import "Student.h"
#import "Address.h"
#import "KalViewController.h"

@class AddStudentNameViewController;

@interface StudentViewController : UITableViewController  <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UITableViewDelegate> {
    Roll_CallAppDelegate *aD;
    Student *currentStudent;
	UIView *tableHeaderView;    
	UIButton *photoButton;
	UIButton *addNameButton;
	UILabel *name;
	NSInteger tC;
	NSInteger aC;
	NSInteger eC;
	KalViewController *calendar;
}


@property(nonatomic, retain) Roll_CallAppDelegate *aD;
@property(nonatomic, retain) Student *currentStudent;
@property (nonatomic, retain) IBOutlet UIView *tableHeaderView;
@property (nonatomic, retain) IBOutlet UIButton *photoButton;
@property (nonatomic, retain) IBOutlet UIButton *addNameButton;
@property (nonatomic, retain) IBOutlet UILabel *name;
@property(nonatomic, retain) KalViewController *calendar;


- (IBAction) photoTapped;
- (IBAction) addName: (id)sender;
- (IBAction) deleteStudent;
- (void) addPhone;
- (void) addEmail;
- (void) addAddress;
- (void) addCourse;
- (void) updatePhotoButton;

@end
