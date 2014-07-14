//
//  DWResponse.m
//  Pods
//
//  Created by Sam Dean on 13/07/2014.
//
//

#import "DWResponse.h"

NSString *NSStringFromDWResponseStatus(const DWResponseStatus status) {
    switch (status) {
        case DWResponseStatusOK:
            return @"OK";
        case DWResponseStatusOptional:
            return @"OPTIONAL";
        case DWResponseStatusRequired:
            return @"REQUIRED";
    }
}

@implementation DWResponse

- (instancetype)initWithStatus:(DWResponseStatus)status
                       message:(NSString *)message {
    if ((self = [super init])) {
        _status = status;
        _message = [message copy];
    }

    return self;
}

- (NSString *)description {
    NSString *message = _message.length > 10 ? [_message substringToIndex:10] : _message;
    return [NSString stringWithFormat:@"<%@:0x08%lx %@ '%@'>",
            NSStringFromClass([self class]),
            (unsigned long)self,
            NSStringFromDWResponseStatus(_status),
            message
            ];
}

- (BOOL)isEqual:(id)object {
    if (object == self) return YES;
    if (![object isKindOfClass:[self class]]) return NO;

    return [self isEqualToResponse:object];
}

- (BOOL)isEqualToResponse:(DWResponse *)response {
    return (response.status == self.status &&
            [response.message isEqualToString:self.message]);
}

- (NSUInteger)hash {
    return self.message.hash;
}

@end
