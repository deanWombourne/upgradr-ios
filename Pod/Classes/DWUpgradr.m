//
//  DWUpgradr.m
//  Pods
//
//  Created by Sam Dean on 13/07/2014.
//
//

#import "DWUpgradr.h"

#import "AFHTTPSessionManager.h"
#import "DWResponseSerializer.h"

NSString *DWUpgradrWillVerifyNotification = @"DWUpgradrWillVerifyNotification";
NSString *DWUpgradrDidVerifyNotification = @"DWUpgradrDidVerifyNotification";
NSString *DWUpgradrNotificationResponseKey = @"DWUpgradrNotificationResponseKey";
NSString *DWUpgradrNotificationErrorKey = @"DWUpgradrNotificationErrorKey";

@interface DWUpgradr ()

@property (nonatomic, copy, readonly) NSString *applicationId;
@property (nonatomic, copy, readonly) NSString *authToken;

@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) NSURLSessionDataTask *task;

@end

@implementation DWUpgradr

- (void)dealloc {
    [self.task cancel];
}

- (instancetype)initWithApplicationId:(NSString *)applicationId
                            authToken:(NSString *)authToken {
    NSParameterAssert(applicationId);

    if ((self = [super init])) {
        _applicationId = [applicationId copy];
        _authToken = [authToken copy];
    }

    return self;
}

- (instancetype)init {
    return [self initWithApplicationId:nil
                             authToken:nil];
}

- (AFHTTPSessionManager *)manager {
    if (nil == _manager) {
        NSURL *baseURL = [NSURL URLWithString:@"http://127.0.0.1:5000/api"];//@"https://upgradr.herokuapp.com/api"];
        _manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
        _manager.requestSerializer = [[AFJSONRequestSerializer alloc] init];
        _manager.responseSerializer = [[DWResponseSerializer alloc] init];
    }
    return _manager;
}

- (void)verify {
    if (self.task) return;

    [[NSNotificationCenter defaultCenter] postNotificationName:DWUpgradrWillVerifyNotification
                                                        object:self];

    NSString *applicationVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSLog(@"DWUpgradr: Verify version %@", applicationVersion);

    NSString *path = [NSString stringWithFormat:@"apps/%@/verify", self.applicationId];
    NSDictionary *parameters = @{ @"api_token" : self.authToken, 
                                  @"version" : applicationVersion };

    self.task = [self.manager GET:path
                       parameters:parameters
                          success:^(NSURLSessionDataTask *task, DWResponse *response) {
                              self.task = nil;

                              [[NSNotificationCenter defaultCenter] postNotificationName:DWUpgradrDidVerifyNotification
                                                                                  object:self
                                                                                userInfo:@{ DWUpgradrNotificationResponseKey : response }];

                          } failure:^(NSURLSessionDataTask *task, NSError *error) {
                              self.task = nil;

                              [[NSNotificationCenter defaultCenter] postNotificationName:DWUpgradrDidVerifyNotification
                                                                                  object:self
                                                                                userInfo:@{ DWUpgradrNotificationErrorKey : error }];
                          }];
}

@end
