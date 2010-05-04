//
//  DebugViewController.h
//  Roll Call
//
//  Created by Kyle Conroy on Apr4.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Roll_CallAppDelegate.h"
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MessageUI.h>

@interface DebugViewController : UIViewController <MFMailComposeViewControllerDelegate> {

    Roll_CallAppDelegate *aD;

}

@property(nonatomic, retain) Roll_CallAppDelegate *aD;

-(IBAction) installData;

-(void) installStudents;
-(void) installCourses;
-(IBAction) mailIt;


@end
