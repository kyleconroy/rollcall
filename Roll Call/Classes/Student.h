//
//  Student.h
//  Roll Call
//
//  Created by Kyle Conroy on Apr4.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Course;
@class Presence;

@interface Student :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSData * thumbnailPhoto;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSSet* presences;
@property (nonatomic, retain) NSSet* courses;

@end


@interface Student (CoreDataGeneratedAccessors)
- (void)addPresencesObject:(Presence *)value;
- (void)removePresencesObject:(Presence *)value;
- (void)addPresences:(NSSet *)value;
- (void)removePresences:(NSSet *)value;

- (void)addCoursesObject:(Course *)value;
- (void)removeCoursesObject:(Course *)value;
- (void)addCourses:(NSSet *)value;
- (void)removeCourses:(NSSet *)value;

@end

