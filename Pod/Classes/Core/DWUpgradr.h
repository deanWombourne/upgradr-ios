//
//  DWUpgradr.h
//  Pods
//
//  Created by Sam Dean on 13/07/2014.
//
//

#import <Foundation/Foundation.h>

#import "DWUpgradrResponse.h"

#define DWUpgradrVersionString @"0.1.0"

extern NSString *DWUpgradrWillVerifyNotification;
extern NSString *DWUpgradrDidVerifyNotification;
extern NSString *DWUpgradrNotificationResponseKey;
extern NSString *DWUpgradrNotificationErrorKey;

@interface DWUpgradr : NSObject

- (instancetype)initWithApplicationId:(NSString *)applicationId
                            authToken:(NSString *)authToken;

- (void)verify;

@end
