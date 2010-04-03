//
//  AddStudentViewController.h
//  Roll Call
//
//  Created by Weizhi Li on Mar24.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Roll_CallAppDelegate.h"

//@class Student;
@class Student;
@class AddStudentNameViewController;

@interface AddStudentViewController : UITableViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    Roll_CallAppDelegate *aD;
	Student *student;
	NSMutableArray *classes;
	UIView *tableHeaderView;    
	UIButton *photoButton;
	UIButton *addNameButton;
	AddStudentNameViewController *addNameViewController;
}

@property(nonatomic, retain) Roll_CallAppDelegate *aD;
@property(nonatomic, retain) AddStudentNameViewController *addNameViewController;
@property(nonatomic, retain) Student *student;
@property(nonatomic, retain) NSMutableArray *classes;
@property (nonatomic, retain) IBOutlet UIView *tableHeaderView;
@property (nonatomic, retain) IBOutlet UIButton *photoButton;
@property (nonatomic, retain) IBOutlet UIButton *addNameButton;

- (void)cancel;
- (void)save;
- (IBAction)photoTapped;
- (IBAction)addName: (id)sender;
- (void)updatePhotoButton ;
@end
