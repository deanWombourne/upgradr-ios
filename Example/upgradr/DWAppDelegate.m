//
//  DWAppDelegate.m
//  upgradr
//
//  Created by CocoaPods on 07/13/2014.
//  Copyright (c) 2014 Sam Dean. All rights reserved.
//

#import "DWAppDelegate.h"

#import "DWUpgradr.h"
#import "DWUpgradr+singleton.h"

@implementation DWAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [DWUpgradr setApplicationId:@"1"];
    [DWUpgradr setApplicationToken:@"1"];
    [DWUpgradr verify];

    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [DWUpgradr verify];
}

@end
