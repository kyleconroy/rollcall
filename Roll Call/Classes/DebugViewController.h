//
//  DebugViewController.h
//  Roll Call
//
//  Created by Kyle Conroy on Apr4.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Roll_CallAppDelegate.h"

@interface DebugViewController : UIViewController {

    Roll_CallAppDelegate *aD;

}

@property(nonatomic, retain) Roll_CallAppDelegate *aD;

-(IBAction) installData;
-(IBAction) installStatuses;

-(void) installStudents;
-(void) installCourses;


@end
