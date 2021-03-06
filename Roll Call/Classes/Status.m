// 
//  Status.m
//  Roll Call
//
//  Created by Kyle Conroy on Apr12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Status.h"

#import "Presence.h"

@implementation Status 

- (NSComparisonResult) statusCompare:(Status*) s
{
    return [((Status*)self).letter compare: s.letter];
}

@dynamic color;
@dynamic letter;
@dynamic imageName;
@dynamic rank;
@dynamic text;
@dynamic presences;

@end
