//
//  DWResponseSerializer.m
//  Pods
//
//  Created by Sam Dean on 14/07/2014.
//
//

#import "DWUpgradrResponseSerializer.h"

static const int DWUpgradrResponseStatusError = INT_MAX;

NSString *DWUpgradrResponseSerializerErrorDomain = @"DWUpgradrResponseSerializerErrorDomain";

@implementation DWUpgradrResponseSerializer

- (DWUpgradrResponseStatus)responseStatusFromString:(NSString *)string {
    if ([string isEqualToString:@"OK"])
        return DWUpgradrResponseStatusOK;
    if ([string isEqualToString:@"OPTIONAL"])
        return DWUpgradrResponseStatusOptional;
    if ([string isEqualToString:@"REQUIRED"])
        return DWUpgradrResponseStatusRequired;

    return DWUpgradrResponseStatusError;
}

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error {

    // Let our superclass deal with the JSON parsing etc
    NSDictionary *dictionary = [super responseObjectForResponse:response
                                                           data:data
                                                          error:error];

    if (nil == dictionary)
        return nil;

    // Are the fields the correct format?
    NSString *statusString = dictionary[@"status"];
    NSString *message = dictionary[@"message"];
    NSString *currentVersion = dictionary[@"current_version"];
    if (![statusString isKindOfClass:[NSString class]] ||
        ![message isKindOfClass:[NSString class]] ||
        ![message isKindOfClass:[NSString class]]) {
        if (error)
            *error = [NSError errorWithDomain:DWUpgradrResponseSerializerErrorDomain
                                         code:0
                                     userInfo:@{ NSLocalizedDescriptionKey : @"Failed to parse server response",
                                                 NSLocalizedFailureReasonErrorKey : @"message or status were not the correct format" }];
        return nil;
    }

    // Can we parse the status string?
    DWUpgradrResponseStatus status = [self responseStatusFromString:statusString];
    if (DWUpgradrResponseStatusError == status) {
        if (error)
            *error = [NSError errorWithDomain:DWUpgradrResponseSerializerErrorDomain
                                         code:0
                                     userInfo:@{ NSLocalizedDescriptionKey : @"Failed to parse server response",
                                                 NSLocalizedFailureReasonErrorKey : @"unknown status found" }];
        return nil;
    }

    // Return a successful response object
    if (error)
        *error = nil;
    return [[DWUpgradrResponse alloc] initWithStatus:status
                                      message:message
                               currentVersion:currentVersion];
}

@end
