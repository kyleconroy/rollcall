//
//  AddStudentNameViewController.h
//  Roll Call
//
//  Created by Weizhi Li on 4/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "AddStudentViewController.h"


@interface AddStudentNameViewController : UIViewController {
	IBOutlet UITextField *firstName;
    IBOutlet UITextField *lastName;
	NSString *lastNameText;
    NSString *firstNameText;
}

@property(nonatomic,retain) IBOutlet UITextField *firstName;
@property(nonatomic,retain) IBOutlet UITextField *lastName;
@property (nonatomic, retain) NSString *lastNameText;
@property (nonatomic, retain) NSString *firstNameText;

- (void)cancel;
- (void)save;

@end
