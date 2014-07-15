//
//  DWUpgradr+singleton.h
//  Pods
//
//  Created by Sam Dean on 15/07/2014.
//
//

#import "DWUpgradr.h"

/**
 Use this category if you don't want to manage instances of the upgrader and alert manager and you're
 ok with the default behaviour.
 */
@interface DWUpgradr (singleton)

/**
 @param applicationId Set the global applicationId
 */
+ (void)setApplicationId:(NSString *)applicationId;

/**
 @param Set the global api token
 */
+ (void)setApplicationToken:(NSString *)token;

/**
 Verify using the global token and applicationId. Don't call this until you've set them!
 */
+ (void)verify;

@end
