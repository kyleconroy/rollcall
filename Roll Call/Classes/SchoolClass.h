//
//  SchoolClass.h
//  Roll Call
//
//  Created by Kyle Conroy on Apr3.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Student;

@interface SchoolClass :  NSManagedObject  
{
}

@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSSet* students;

@end


@interface SchoolClass (CoreDataGeneratedAccessors)
- (void)addStudentsObject:(Student *)value;
- (void)removeStudentsObject:(Student *)value;
- (void)addStudents:(NSSet *)value;
- (void)removeStudents:(NSSet *)value;

@end

