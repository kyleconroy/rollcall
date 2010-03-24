//
//  AddStudentViewController.h
//  Roll Call
//
//  Created by Kyle Conroy on Mar24.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AddStudentViewController : UIViewController {
    IBOutlet UITextField *firstName;
    IBOutlet UITextField *lastName;
}

@property(nonatomic,retain) IBOutlet UITextField *firstName;
@property(nonatomic,retain) IBOutlet UITextField *lastName;

@end
