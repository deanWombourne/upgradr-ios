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

@interface DWAlertManager () <UIAlertViewDelegate>

@property (nonatomic, readonly, strong) DWUpgradr *upgradr;

@end

@implementation DWAlertManager

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

- (void)upgradrDidVerify:(NSNotification *)notification {
    DWResponse *response = notification.userInfo[DWUpgradrNotificationResponseKey];
    if (nil == response) {
        NSError *error = notification.userInfo[DWUpgradrNotificationErrorKey];
        NSLog(@"Failed to verify with error : %@", error);
        return;
    }

    [self presentAlertWithResponse:response];
}

- (void)presentAlertWithResponse:(DWResponse *)response {
    switch(response.status) {
        case DWResponseStatusOK:
            break;

        case DWResponseStatusRequired:
            [self presentRequiredAlertWithResponse:response];
            break;

        case DWResponseStatusOptional:
            [self presentOptionalAlertWithResponse:response];
            break;
    }
}

- (void)presentRequiredAlertWithResponse:(DWResponse *)response {
    DWAlertView *alert = [[DWAlertView alloc] initWithTitle:@"Upgrade Required"
                                                    message:response.message
                                                   delegate:self
                                          cancelButtonTitle:@"Upgrade"
                                          otherButtonTitles:nil];
    alert.responseStatus = response.status;
    [alert show];

}

- (void)presentOptionalAlertWithResponse:(DWResponse *)response {
    DWAlertView *alert = [[DWAlertView alloc] initWithTitle:@"Upgrade Optional"
                                                    message:response.message
                                                   delegate:self
                                          cancelButtonTitle:@"Upgrade"
                                          otherButtonTitles:@"Skip", nil];
    alert.responseStatus = response.status;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // Cancel is always upgrade
    if (buttonIndex == alertView.cancelButtonIndex) {
        NSString *name = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleNameKey];
        NSString *path = [NSString stringWithFormat:@"http://appstore.com/%@", [name DW_appStoreSafeString]];
        NSURL *url = [NSURL URLWithString:path];
        NSLog(@"Opening upgrade URL : %@", [url absoluteString]);
        [[UIApplication sharedApplication] openURL:url];
    }
}

@end
