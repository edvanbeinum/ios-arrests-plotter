//
//  ViewController.h
//  ArrestsPlotter
//
//  Created by Ed van Beinum on 20/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#define METERS_PER_MILE 1609.334

@interface ViewController : UIViewController<MKMapViewDelegate> 

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)refresh:(id)sender;

@end
