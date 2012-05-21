//
//  ViewController.m
//  ArrestsPlotter
//
//  Created by Ed van Beinum on 20/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"
#import "SBJson.h"
#import "PointOfInterest.h"

@implementation ViewController
@synthesize mapView = _mapView;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 39.281516;
    zoomLocation.longitude = -76.580806;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)plotCrimePositions:(NSString *)responseString
{
    for (id<MKAnnotation> annotation in self.mapView.annotations) {
        [self.mapView removeAnnotation:annotation];
    }
    
    NSDictionary * root = [responseString JSONValue];
    NSArray *data = [root objectForKey:@"data"];
    
    for (NSArray *row in data) {
        NSNumber *latitude = [[row objectAtIndex:21]objectAtIndex:1];
        NSNumber *longitude = [[row objectAtIndex:21]objectAtIndex:2];
        NSString *crimeDescription =[row objectAtIndex:17];
        NSString *address = [row objectAtIndex:13];
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = latitude.doubleValue;
        coordinate.longitude = longitude.doubleValue;
        
        PointOfInterest *annotation = [[PointOfInterest alloc] initWithName:crimeDescription address:address coordinate:coordinate];
        [self.mapView addAnnotation:annotation];
    }
}

- (IBAction)refresh:(id)sender 
{
    MKCoordinateRegion mapRegion = [self.mapView region];
    CLLocationCoordinate2D centerLocation = mapRegion.center;
    
    NSString *jsonFile = [[NSBundle mainBundle] pathForResource:@"command" ofType:@"json"];
    NSString *formatString = [NSString stringWithContentsOfFile:jsonFile encoding:NSUTF8StringEncoding error:nil];
    NSString *json = [NSString stringWithFormat:formatString, centerLocation.latitude, centerLocation.longitude, 0.5*METERS_PER_MILE];
    
    NSURL *url = [NSURL URLWithString:@"http://data.baltimorecity.gov/api/views/INLINE/rows.json?method=index"];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request appendPostData:[json dataUsingEncoding:NSUTF8StringEncoding]];
    [request setDelegate:self];
    [request setCompletionBlock:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *responseString = [request responseString];
        NSLog(@"Response: %@", responseString);
        [self plotCrimePositions:responseString]; 
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@"Error: %@", error);
    }];
    [request startAsynchronous];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading data...";
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *identifier = @"PointOfInterest";
    if ([annotation isKindOfClass:[PointOfInterest class]]) {
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        return annotationView;
    }
    return nil;
}

@end
