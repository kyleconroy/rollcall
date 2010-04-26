//
//  Presence.h
//  Roll Call
//
//  Created by Kyle Conroy on Apr12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Course;
@class Status;
@class Student;

@interface Presence :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) Status * status;
@property (nonatomic, retain) Student * student;
@property (nonatomic, retain) Course * course;

@end



