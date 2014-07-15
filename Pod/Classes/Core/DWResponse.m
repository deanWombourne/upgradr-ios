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
                       message:(NSString *)message
                currentVersion:(NSString *)currentVersion {
    if ((self = [super init])) {
        _status = status;
        _message = [message copy];
        _currentVersion = [currentVersion copy];
    }

    return self;
}

- (NSString *)description {
    NSString *message = _message.length > 10 ? [_message substringToIndex:10] : _message;
    return [NSString stringWithFormat:@"<%@:0x08%lx %@ (current=%@) '%@'>",
            NSStringFromClass([self class]),
            (unsigned long)self,
            NSStringFromDWResponseStatus(_status),
            _currentVersion,
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
            [response.message isEqualToString:self.message] &&
            [response.currentVersion isEqualToString:self.currentVersion]);
}

- (NSUInteger)hash {
    return self.message.hash;
}

@end
