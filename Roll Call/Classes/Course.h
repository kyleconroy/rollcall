//
//  Course.h
//  Roll Call
//
//  Created by Kyle Conroy on Apr4.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Presence;
@class Student;

@interface Course :  NSManagedObject  
{
}

@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSSet* presences;
@property (nonatomic, retain) NSSet* students;

@end


@interface Course (CoreDataGeneratedAccessors)
- (void)addPresencesObject:(Presence *)value;
- (void)removePresencesObject:(Presence *)value;
- (void)addPresences:(NSSet *)value;
- (void)removePresences:(NSSet *)value;

- (void)addStudentsObject:(Student *)value;
- (void)removeStudentsObject:(Student *)value;
- (void)addStudents:(NSSet *)value;
- (void)removeStudents:(NSSet *)value;

@end

