//
//  DWResponse.h
//  Pods
//
//  Created by Sam Dean on 13/07/2014.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DWResponseStatus) {
    DWResponseStatusOK,
    DWResponseStatusOptional,
    DWResponseStatusRequired
};

extern NSString *NSStringFromDWResponseStatus(const DWResponseStatus status);

@interface DWResponse : NSObject <NSCopying>

- (instancetype)initWithStatus:(DWResponseStatus)status
                       message:(NSString *)message
                currentVersion:(NSString *)currentVersion;

@property (nonatomic, readonly, assign) DWResponseStatus status;
@property (nonatomic, readonly, copy) NSString *message;
@property (nonatomic, readonly, copy) NSString *currentVersion;

@end

@interface DWResponse (coding) <NSCoding>

@end
