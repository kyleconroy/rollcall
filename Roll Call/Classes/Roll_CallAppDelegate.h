//
//  Roll_CallAppDelegate.h
//  Roll Call
//
//  Created by Kyle Conroy on Mar22.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Status.h"

@interface Roll_CallAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
    NSMutableArray *students;
    NSArray *classes;
    
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property(nonatomic,retain) NSMutableArray *students;
@property(nonatomic,retain) NSArray *classes;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSString *)applicationDocumentsDirectory;
- (NSMutableArray *) getAllStudents;
- (NSMutableArray *) getAllCourses;
- (NSMutableArray *) getAllStatuses;
- (Status *) getStatusWithLetter:(NSString *)letter;
- (Status *) getStatusWithLowestRank;

@end
