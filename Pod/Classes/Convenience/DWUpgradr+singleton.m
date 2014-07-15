//
//  DWUpgradr+singleton.m
//  Pods
//
//  Created by Sam Dean on 15/07/2014.
//
//

#import "DWUpgradr+singleton.h"

#import "DWAlertManager.h"

static NSString *applicationId = nil;
static NSString *token = nil;

@implementation DWUpgradr (singleton)

+ (void)setApplicationId:(NSString *)o {
    applicationId = o;
}

+ (void)setApplicationToken:(NSString *)o {
    token = o;
}

+ (DWUpgradr *)sharedInstance {
    static dispatch_once_t onceToken;
    static DWUpgradr *instance = nil;
    static DWAlertManager *manager = nil;
    dispatch_once(&onceToken, ^{
        instance = [[DWUpgradr alloc] initWithApplicationId:applicationId
                                                  authToken:token];
        manager = [[DWAlertManager alloc] initWithUpgradr:instance];
    });

    return instance;
}

+ (void)verify {
    [[self sharedInstance] verify];
}

@end
