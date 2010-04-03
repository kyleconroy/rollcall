//
//  Student.h
//  Roll Call
//
//  Created by Kyle Conroy on Apr3.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class SchoolClass;

@interface Student :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSData * thumbnailPhoto;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSSet* classes;

@end


@interface Student (CoreDataGeneratedAccessors)
- (void)addClassesObject:(SchoolClass *)value;
- (void)removeClassesObject:(SchoolClass *)value;
- (void)addClasses:(NSSet *)value;
- (void)removeClasses:(NSSet *)value;

@end

