//
//  PointOfInterest.m
//  ArrestsPlotter
//
//  Created by Ed van Beinum on 20/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PointOfInterest.h"

@implementation PointOfInterest

@synthesize name = _name;
@synthesize address = _address;
@synthesize coordinate = _coordinate;

-(PointOfInterest *) initWithName:(NSString *)name address:(NSString *)address coordinate:(CLLocationCoordinate2D)coordinate
{
    if (self = [super init]) {
        self.name = name;
        self.address = address;
        self.coordinate = coordinate;
    }
    return self;
}
 
-(NSString *) title
{
    if ([self.name isKindOfClass:[NSNull class]]) {
        return @"Unkown charge";
    } else {
        return self.name;
    }
}

-(NSString *) subtitle
{
    return self.address;
}

@end
