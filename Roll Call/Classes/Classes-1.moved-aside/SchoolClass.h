//
//  SchoolClass.h
//  Roll Call
//
//  Created by Kyle Conroy on Mar22.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


@interface SchoolClass : NSObject {
    
    NSString *className;

}

@property(readwrite, assign) NSString *className;

- (id) initWithName:(NSString *)name;

@end
