//
//  DWAlertManager.m
//  Pods
//
//  Created by Sam Dean on 14/07/2014.
//
//

#import "DWAlertManager.h"

#import "DWAlertView.h"

#import "NSString+app_store.h"

static NSString *DWAlertManagerSkippedVersionsKey = @"DWAlertManagerSkippedVersionsKey";

@interface DWAlertManager () <UIAlertViewDelegate>

@property (nonatomic, readonly, strong) DWUpgradr *upgradr;

@property (nonatomic, copy) NSSet *skippedVersions;

@end

@implementation DWAlertManager

@synthesize skippedVersions = _skippedVersions;

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithUpgradr:(DWUpgradr *)upgradr {
    if ((self = [super init])) {
        _upgradr = upgradr;

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(upgradrDidVerify:)
                                                     name:DWUpgradrDidVerifyNotification
                                                   object:upgradr];
    }
    return self;
}

- (NSSet *)skippedVersions {
    if (nil == _skippedVersions) {
        NSArray *temp = [[NSUserDefaults standardUserDefaults] objectForKey:DWAlertManagerSkippedVersionsKey];
        if (NO == [temp isKindOfClass:[NSArray class]])
            temp = @[];
        _skippedVersions = [NSSet setWithArray:temp];
    }
    return _skippedVersions;
}

- (void)setSkippedVersions:(NSSet *)skippedVersions {
    if (skippedVersions != _skippedVersions) {
        _skippedVersions = [skippedVersions copy];

        if (_skippedVersions)
            [[NSUserDefaults standardUserDefaults] setObject:[skippedVersions allObjects] forKey:DWAlertManagerSkippedVersionsKey];
        else
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:DWAlertManagerSkippedVersionsKey];
    }
}

- (void)upgradrDidVerify:(NSNotification *)notification {
    DWResponse *response = notification.userInfo[DWUpgradrNotificationResponseKey];
    if (nil == response) {
        NSError *error = notification.userInfo[DWUpgradrNotificationErrorKey];
        NSLog(@"Failed to verify with error : %@", error);
        return;
    }

    if (response.status == DWResponseStatusOK) {
        // If it's OK then we don't have to do anything
    } else if (response.status == DWResponseStatusRequired) {
        [self presentRequiredAlertWithResponse:response];
    } else if (NO == [self.skippedVersions containsObject:response.currentVersion]) {
        [self presentOptionalAlertWithResponse:response];
    }
}

- (void)presentRequiredAlertWithResponse:(DWResponse *)response {
    DWAlertView *alert = [[DWAlertView alloc] initWithTitle:@"Upgrade Required"
                                                    message:response.message
                                                   delegate:self
                                          cancelButtonTitle:@"Upgrade"
                                          otherButtonTitles:nil];
    alert.response = response;
    [alert show];

}

- (void)presentOptionalAlertWithResponse:(DWResponse *)response {
    DWAlertView *alert = [[DWAlertView alloc] initWithTitle:@"Upgrade Optional"
                                                    message:response.message
                                                   delegate:self
                                          cancelButtonTitle:@"Upgrade"
                                          otherButtonTitles:@"Skip", nil];
    alert.response = response;
    [alert show];
}

- (void)alertView:(DWAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // Cancel is always upgrade
    if (buttonIndex == alertView.cancelButtonIndex) {
        NSString *name = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleNameKey];
        NSString *path = [NSString stringWithFormat:@"http://appstore.com/%@", [name DW_appStoreSafeString]];
        NSURL *url = [NSURL URLWithString:path];
        NSLog(@"Opening upgrade URL : %@", [url absoluteString]);
        [[UIApplication sharedApplication] openURL:url];
    }

    // If we are skipping, then store that we don't want this update again
    else if (alertView.response.status == DWResponseStatusOptional) {
        self.skippedVersions = [self.skippedVersions setByAddingObject:alertView.response.currentVersion];
    }
}

@end
