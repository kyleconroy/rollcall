//
//  Roll_CallAppDelegate.h
//  Roll Call
//
//  Created by Kyle Conroy on Mar22.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Roll_CallAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
    NSMutableArray *students;
    NSArray *classes;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property(nonatomic,retain) NSMutableArray *students;
@property(nonatomic,retain) NSArray *classes;

@end
