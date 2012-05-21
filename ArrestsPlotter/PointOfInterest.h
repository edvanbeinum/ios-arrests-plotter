//
//  PointOfInterest.h
//  ArrestsPlotter
//
//  Created by Ed van Beinum on 20/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface PointOfInterest : NSObject <MKAnnotation>

@property (nonatomic, weak) NSString *name;
@property (nonatomic, weak) NSString *address;
@property (nonatomic) CLLocationCoordinate2D coordinate;

-(PointOfInterest *) initWithName:(NSString *)name address:(NSString *)address coordinate:(CLLocationCoordinate2D)coordinate;

@end
