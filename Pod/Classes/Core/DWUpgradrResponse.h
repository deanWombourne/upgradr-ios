//
//  DWResponse.h
//  Pods
//
//  Created by Sam Dean on 13/07/2014.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DWUpgradrResponseStatus) {
    DWUpgradrResponseStatusOK,
    DWUpgradrResponseStatusOptional,
    DWUpgradrResponseStatusRequired
};

extern NSString *NSStringFromDWUpgradrResponseStatus(const DWUpgradrResponseStatus status);

@interface DWUpgradrResponse : NSObject <NSCopying>

- (instancetype)initWithStatus:(DWUpgradrResponseStatus)status
                       message:(NSString *)message
                currentVersion:(NSString *)currentVersion;

@property (nonatomic, readonly, assign) DWUpgradrResponseStatus status;
@property (nonatomic, readonly, copy) NSString *message;
@property (nonatomic, readonly, copy) NSString *currentVersion;

@end

@interface DWUpgradrResponse (coding) <NSCoding>

@end
