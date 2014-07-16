//
//  DWResponse.m
//  Pods
//
//  Created by Sam Dean on 13/07/2014.
//
//

#import "DWUpgradrResponse.h"

NSString *NSStringFromDWResponseStatus(const DWUpgradrResponseStatus status) {
    switch (status) {
        case DWUpgradrResponseStatusOK:
            return @"OK";
        case DWUpgradrResponseStatusOptional:
            return @"OPTIONAL";
        case DWUpgradrResponseStatusRequired:
            return @"REQUIRED";
    }
}

@implementation DWUpgradrResponse

- (instancetype)initWithStatus:(DWUpgradrResponseStatus)status
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

- (BOOL)isEqualToResponse:(DWUpgradrResponse *)response {
    return (response.status == self.status &&
            [response.message isEqualToString:self.message] &&
            [response.currentVersion isEqualToString:self.currentVersion]);
}

- (NSUInteger)hash {
    return self.message.hash;
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return self;
}

@end

@implementation DWUpgradrResponse (coding)

static NSString *DWResponseCodingStatusKey = @"s";
static NSString *DWResponseCodingMessageKey = @"m";
static NSString *DWResponseCodingVersionKey = @"v";

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:self.status forKey:DWResponseCodingStatusKey];
    [aCoder encodeObject:self.message forKey:DWResponseCodingMessageKey];
    [aCoder encodeObject:self.currentVersion forKey:DWResponseCodingVersionKey];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super init])) {
        _status = [aDecoder decodeIntegerForKey:DWResponseCodingStatusKey];
        _message = [[aDecoder decodeObjectForKey:DWResponseCodingMessageKey] copy];
        _currentVersion = [[aDecoder decodeObjectForKey:DWResponseCodingVersionKey] copy];
    }
    return self;
}

@end
