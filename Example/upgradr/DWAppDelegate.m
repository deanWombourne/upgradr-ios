//
//  DWAppDelegate.m
//  upgradr
//
//  Created by CocoaPods on 07/13/2014.
//  Copyright (c) 2014 Sam Dean. All rights reserved.
//

#import "DWAppDelegate.h"

#import "DWUpgradr.h"
#import "DWAlertManager.h"

@interface DWAppDelegate ()

@property (nonatomic, strong) DWUpgradr *upgradr;
@property (nonatomic, strong) DWAlertManager *alertManager;

@end

@implementation DWAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Create our upgradr object and do an initial verify
    self.upgradr = [[DWUpgradr alloc] initWithApplicationId:@"1"
                                                  authToken:@"1"];
    self.alertManager = [[DWAlertManager alloc] initWithUpgradr:self.upgradr];
    [self.upgradr verify];

    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Verify each time the app is opened again
    [self.upgradr verify];
}

@end
