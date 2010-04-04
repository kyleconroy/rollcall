//
//  Presence.h
//  Roll Call
//
//  Created by Kyle Conroy on Apr4.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Course;
@class Student;

@interface Presence :  NSManagedObject  
{
}

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSManagedObject * status;
@property (nonatomic, retain) Student * student;
@property (nonatomic, retain) Course * class;

@end



