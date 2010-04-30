//
//  Status.h
//  Roll Call
//
//  Created by Kyle Conroy on Apr12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Presence;

@interface Status :  NSManagedObject  
{
}

@property (nonatomic, retain) id color;
@property (nonatomic, retain) NSString * letter;
@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) NSNumber * rank;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSSet* presences;

@end


@interface Status (CoreDataGeneratedAccessors)
- (void)addPresencesObject:(Presence *)value;
- (void)removePresencesObject:(Presence *)value;
- (void)addPresences:(NSSet *)value;
- (void)removePresences:(NSSet *)value;

@end

