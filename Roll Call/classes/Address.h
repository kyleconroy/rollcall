//
//  Address.h
//  Roll Call
//
//  Created by Weizhi on 4/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Address : NSManagedObject {

}

@property (nonatomic, retain) NSString * apt;
@property (nonatomic, retain) NSString * zip;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString* street;
@property (nonatomic, retain) NSString* city;

@end
