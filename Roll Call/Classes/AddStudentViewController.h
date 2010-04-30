//
//  AddStudentViewController.h
//  Roll Call
//
//  Created by Weizhi Li on Mar24.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Roll_CallAppDelegate.h"
@class Student;

@interface AddStudentViewController : UITableViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    Roll_CallAppDelegate *aD;
	Student *student;
	UIView *tableHeaderView;    
	UIButton *photoButton;
	NSMutableArray *courses;
	UIButton *addNameButton;
	UILabel *name;
	BOOL *add;
}

@property (nonatomic) BOOL *add;
@property (nonatomic, retain) Student *student;
@property (nonatomic, retain) Roll_CallAppDelegate *aD;
@property (nonatomic, retain) NSMutableArray *courses;
@property (nonatomic, retain) IBOutlet UIView *tableHeaderView;
@property (nonatomic, retain) IBOutlet UIButton *photoButton;
@property (nonatomic, retain) IBOutlet UIButton *addNameButton;
@property (nonatomic, retain) IBOutlet UILabel *name;

- (void)cancel;
- (void)save;
- (IBAction)photoTapped;
- (IBAction)addName: (id)sender;
- (void) addPhone;
- (void) addEmail;
- (void) addAddress;
- (void) addCourse;
- (void)updatePhotoButton;

@end
