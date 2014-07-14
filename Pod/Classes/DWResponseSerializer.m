//
//  DWResponseSerializer.m
//  Pods
//
//  Created by Sam Dean on 14/07/2014.
//
//

#import "DWResponseSerializer.h"

static const int DWResponseStatusError = INT_MAX;

NSString *DWResponseSerializerErrorDomain = @"DWResponseSerializerErrorDomain";

@implementation DWResponseSerializer

- (DWResponseStatus)responseStatusFromString:(NSString *)string {
    if ([string isEqualToString:@"OK"])
        return DWResponseStatusOK;
    if ([string isEqualToString:@"OPTIONAL"])
        return DWResponseStatusOptional;
    if ([string isEqualToString:@"REQUIRED"])
        return DWResponseStatusRequired;

    return DWResponseStatusError;
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
    if (![statusString isKindOfClass:[NSString class]] ||
        ![message isKindOfClass:[NSString class]]) {
        if (error)
            *error = [NSError errorWithDomain:DWResponseSerializerErrorDomain
                                         code:0
                                     userInfo:@{ NSLocalizedDescriptionKey : @"Failed to parse server response",
                                                 NSLocalizedFailureReasonErrorKey : @"message or status were not the correct format" }];
        return nil;
    }

    // Can we parse the status string?
    DWResponseStatus status = [self responseStatusFromString:statusString];
    if (DWResponseStatusError == status) {
        if (error)
            *error = [NSError errorWithDomain:DWResponseSerializerErrorDomain
                                         code:0
                                     userInfo:@{ NSLocalizedDescriptionKey : @"Failed to parse server response",
                                                 NSLocalizedFailureReasonErrorKey : @"unknown status found" }];
        return nil;
    }

    // Return a successful response object
    if (error)
        *error = nil;
    return [[DWResponse alloc] initWithStatus:status
                                      message:message];
}

@end
