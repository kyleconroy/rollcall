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
@class Status;

@interface StudentViewController : UITableViewController  <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UITableViewDelegate> {
    Roll_CallAppDelegate *aD;
    Student *currentStudent;
	UIView *tableHeaderView;    
	UIButton *photoButton;
	UIButton *addNameButton;
	UILabel *name;
	IBOutlet UITableViewCell *tvCell;
	KalViewController *calendar;
	IBOutlet UIButton  *aB;
	IBOutlet UILabel  *stName;
	IBOutlet UILabel  *stAll;
	IBOutlet UILabel  *stCount;
	NSMutableArray *presences;
	IBOutlet UITableViewCell *tableCell;
	IBOutlet UILabel *cellLabel;
	IBOutlet UIImageView *cellImage;
	IBOutlet UIButton  *cB;
	IBOutlet UITableViewCell *dsCell;
	NSMutableArray *statusArray;
	NSMutableArray *emtIndex;
	Status *currentStatus;

}

@property(nonatomic, retain) Roll_CallAppDelegate *aD;
@property(nonatomic, retain) Student *currentStudent;
@property (nonatomic, retain) IBOutlet UIView *tableHeaderView;
@property (nonatomic, retain) IBOutlet UIButton *photoButton;
@property (nonatomic, retain) IBOutlet UIButton *addNameButton;
@property (nonatomic, retain) IBOutlet UILabel *name;
@property(nonatomic, retain) KalViewController *calendar;
@property(nonatomic, retain) IBOutlet UITableViewCell *tvCell;
@property(nonatomic, retain) NSMutableArray *presences;
@property(nonatomic, retain) IBOutlet UITableViewCell *tableCell;
@property(nonatomic, retain) IBOutlet UILabel *cellLabel;
@property(nonatomic, retain) IBOutlet UIImageView *cellImage;
@property(nonatomic, retain) IBOutlet UIButton  *cB;
@property(nonatomic, retain) IBOutlet UITableViewCell *dsCell;
@property(nonatomic, retain) NSMutableArray *statusArray;
@property(nonatomic, retain) NSMutableArray *emtIndex;

- (IBAction) photoTapped;
- (IBAction) addName: (id)sender;
- (IBAction) deleteStudent;
- (void) addPhone;
- (void) addEmail;
- (void) addAddress;
- (void) addCourse;
- (void) updatePhotoButton;
- (IBAction) showKal;
- (IBAction) showNotes;

@end
