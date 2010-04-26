//
//  FirstViewController.h
//  Roll Call
//
//  Created by Kyle Conroy on Mar22.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Roll_CallAppDelegate.h"


@interface FirstViewController : UIViewController {
    NSManagedObjectContext *managedObjectContext;
    Roll_CallAppDelegate *aD;

}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, retain) Roll_CallAppDelegate *aD;

@end
