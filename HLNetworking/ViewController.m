//
//  ViewController.m
//  HLNetworking
//
//  Created by wangshiyu13 on 2016/9/22.
//  Copyright © 2016年 wangshiyu13. All rights reserved.
//
#import "ViewController.h"
#import "HLNetworking.h"
#import "AFNetworking.h"

@interface ViewController ()<HLResponseDelegate, HLRequestDelegate, HLObjReformerProtocol, HLAPISyncBatchRequestsProtocol, HLAPIBatchRequestsProtocol, HLTaskRequestDelegate, HLTaskResponseProtocol>
@property(nonatomic, strong)HLAPI *api1;
@property(nonatomic, strong)HLAPI *api2;
@property(nonatomic, strong)HLAPI *api3;
@property(nonatomic, strong)HLAPI *api4;
@property(nonatomic, strong)HLTask *task1;

@property(nonatomic, assign)BOOL isPause;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAPINetworkConfig];
    [self testAPI];
    [self setupTaskNetworkConfig];
    [self testTask];
}

- (void)pause {
    if (self.isPause) {
        [self.task1 resume];
    } else {
        [self.task1 cancel];
    }
    self.isPause = !self.isPause;
}

- (void)testTask {
    self.isPause = NO;
    UIButton *pauseButton = [UIButton buttonWithType:UIButtonTypeSystem];
    pauseButton.frame = CGRectMake(0, 0, 100, 100);
    pauseButton.backgroundColor = [UIColor redColor];
    [self.view addSubview:pauseButton];
    [pauseButton addTarget:self action:@selector(pause) forControlEvents:UIControlEventTouchUpInside];
    self.task1 = [[HLTask task].setDelegate(self).setFilePath([[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Boom2.dmg"]).setTaskURL(@"https://dl.devmate.com/com.globaldelight.Boom2/Boom2.dmg") start];
}

- (void)setupTaskNetworkConfig {
    HLNetworkConfig *config = [HLNetworkConfig config];
    config.baseURL = @"https://httpbin.org";
    [[HLTaskManager shared] setConfig:config];
    [HLTaskManager shared].responseDelegate = self;
}

#pragma mark - task reponse protocol

- (NSArray<HLTask *> *)requestTasks {
    return @[self.task1];
}

- (void)requestProgress:(nullable NSProgress *)progress atTask:(nullable HLTask *)task {
    NSLog(@"\n进度=====\n当前任务：%@\n当前进度：%@", task.taskURL, progress);
}

- (void)requestSucessWithResponseObject:(nonnull id)responseObject atTask:(nullable HLTask *)task {
    NSLog(@"\n完成=====\n当前任务：%@\n对象：%@", task, responseObject);
}

- (void)requestFailureWithResponseError:(nullable NSError *)error atTask:(nullable HLTask *)task {
    NSLog(@"\n失败=====\n当前任务：%@\n错误：%@", task, error);
}

#pragma mark - task request delegate
- (void)requestWillBeSentWithTask:(HLTask *)task {
    
}
// 请求已经发出
- (void)requestDidSentWithTask:(HLTask *)task {
    
}

- (void)setupAPINetworkConfig {
    HLNetworkConfig *config = [HLNetworkConfig config];
    config.baseURL = @"https://httpbin.org/";
    config.apiVersion = nil;
    [[HLAPIManager shared] setConfig:config];
    [HLAPIManager shared].responseDelegate = self;
}

- (void)testAPI {
    self.api1 = [HLAPI API].setMethod(GET)
    .setPath(@"get")
    .setDelegate(self)
    .success(^(id  _Nonnull responseObject) {
        NSLog(@"\napi 1 --- 已回调 \n----");
    })
    .progress(^(NSProgress *proc){
        NSLog(@"当前进度：%@", proc);
    })
    .failure(^(NSError *error){
        NSLog(@"\napi1 --- 错误：%@", error);
    })
    .formData([HLFormDataConfig configWithData:[NSData data]
                                          name:@"name"
                                      fileName:@"fileName"
                                      mimeType:@"mimeType"]);
    
    self.api2 = [HLAPI API].setMethod(GET)
    .setPath(@"ip")
    .setDelegate(self)
    .success(^(id  _Nonnull responseObject) {
        NSLog(@"\napi 2 --- 已回调 \n----");
    });
    
    self.api3 = [HLAPI API].setMethod(GET)
    .setPath(@"status/418")
    .setParams(@{@"user_id": @194})
    .setDelegate(self)
    .success(^(id  _Nonnull responseObject) {
        NSLog(@"\napi 3 --- 已回调 \n----");
    });
    
    self.api4 = [HLAPI API].setMethod(GET)
    .setPath(@"get")
    .setParams(@{@"show_env": @1})
    .setDelegate(self)
    .success(^(id  _Nonnull responseObject) {
        NSLog(@"\napi 4 --- 已回调 \n----");
    });
    
    HLAPISyncBatchRequests *syncBatch = [[HLAPISyncBatchRequests alloc] init];
    syncBatch.delegate = self;
    [syncBatch addBatchAPIRequests:@[self.api1, self.api2, self.api3, self.api4]];
    [syncBatch start];
    
    //    HLAPIBatchRequests *asyncBatch = [[HLAPIBatchRequests alloc] init];
    //    asyncBatch.delegate = self;
    //    [asyncBatch addBatchAPIRequests:[NSSet setWithObjects:self.api1, self.api2, self.api3, self.api4, self.api5, nil]];
    //    [asyncBatch start];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5), dispatch_get_main_queue(), ^{
        [syncBatch cancel];
    });
}

- (void)batchRequestsAllDidFinished:(HLAPISyncBatchRequests *)batchApis {
    NSLog(@"batchRequestsAllDidFinished");
}

- (void)batchAPIRequestsDidFinished:(HLAPIBatchRequests * _Nonnull)batchApis {
    NSLog(@"batchAPIRequestsDidFinished");
}

#pragma mark - HLObjReformerProtocol
- (id)apiResponseObjReformerWithAPI:(HLAPI *)api andResponseObject:(id)responseObject andError:(NSError *)error {
    return [NSString stringWithFormat:@"我被转换了"];
}

#pragma mark - HLRequestDelegate
- (void)requestWillBeSentWithAPI:(HLAPI *)api {
    NSLog(@"\n%@---willBeSent---", [self getAPIName:api]);
}

- (void)requestDidSentWithAPI:(HLAPI *)api {
    NSLog(@"\n%@---didSent---", [self getAPIName:api]);
}

#pragma mark - HLResponseDelegate
- (NSArray<HLAPI *> *)requestAPIs {
    return @[self.api1, self.api2, self.api3, self.api4];
}

- (void)requestSucessWithResponseObject:(id)responseObject atAPI:(HLAPI *)api {
    NSLog(@"\n%@------RequestSuccessDelegate\n", [self getAPIName:api]);
    NSLog(@"%@", [NSThread currentThread]);
}

- (void)requestFailureWithResponseError:(NSError *)error atAPI:(HLAPI *)api {
    NSLog(@"\n%@------RequestFailureDelegate\n", [self getAPIName:api]);
    NSLog(@"%@", [NSThread currentThread]);
}

- (void)requestProgress:(NSProgress *)progress atAPI:(HLAPI *)api {
    NSLog(@"\n%@------RequestProgress\n", [self getAPIName:api]);
    NSLog(@"%@", [NSThread currentThread]);
}

- (NSString *)getAPIName:(HLAPI *)api {
    NSString *apiName;
    if ([api isEqual:self.api1]) {
        apiName = @"api1";
    } else if ([api isEqual:self.api2]) {
        apiName = @"api2";
    } else if ([api isEqual:self.api3]) {
        apiName = @"api3";
    } else if ([api isEqual:self.api4]) {
        apiName = @"api4";
    }
    return apiName;
}
@end
