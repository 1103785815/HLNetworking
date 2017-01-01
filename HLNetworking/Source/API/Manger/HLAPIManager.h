//
//  HLAPIManager.h
//  HLPPShop
//
//  Created by wangshiyu13 on 2016/9/17.
//  Copyright © 2016年 wangshiyu13. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLAPIType.h"

// 判断当前是否为审核版本
FOUNDATION_EXPORT BOOL HLJudgeVersion(void);
// 设置是否为审核版本
FOUNDATION_EXPORT void HLJudgeVersionSwitch(BOOL isR);

@protocol HLNetworkErrorProtocol;
@protocol HLAPIResponseDelegate;
@class HLNetworkConfig;
@class HLAPI;
@class HLAPIBatchRequests;
@class HLAPIChainRequests;
NS_ASSUME_NONNULL_BEGIN
@interface HLAPIManager : NSObject

@property (nonatomic, strong, readonly) HLNetworkConfig *config;

// 请使用manager或sharedManager
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

// 返回一个新的manager对象
+ (HLAPIManager *)manager;

// 配置设置
- (void)setupConfig:(void(^)(HLNetworkConfig *config))configBlock;

/**
 发送API请求

 @param api 要发送的api
 */
- (void)sendAPIRequest:(HLAPI *)api;

/**
 取消API请求
 如果该请求已经发送或者正在发送，则无法取消，但会将Block回落点置空，delegate正常回调

 @param api 要取消的api
 */
- (void)cancelAPIRequest:(HLAPI *)api;

/**
 发送一系列API请求

 @param apis 待发送的API请求集合
 */
- (void)sendBatchAPIRequests:(HLAPIBatchRequests *)apis;

/**
 发送同步请求

 @param apis 带发送的同步请求集合
 */
- (void)sendChainAPIRequests:(HLAPIChainRequests *)apis;

/**
 移除网络请求监听者

 @param observer 监听者
 */
- (void)registerNetworkResponseObserver:(id<HLAPIResponseDelegate>)observer;

/**
 删除网络请求监听者
 
 @param observer 监听者
 */
- (void)removeNetworkResponseObserver:(id<HLAPIResponseDelegate>)observer;

/**
 添加网络传输错误时的监控observer

 @param observer 遵循HLNetworkErrorProtocol的observer
 */
- (void)registerNetworkErrorObserver:(id<HLNetworkErrorProtocol>)observer;

/**
 删除网络传输错误时的监控observer

 @param observer 遵循HLNetworkErrorProtocol的observer
 */
- (void)removeNetworkErrorObserver:(id<HLNetworkErrorProtocol>)observer;

#pragma mark - sharedManager类方法

#pragma mark - 初始化方法
// 默认单例
+ (HLAPIManager *)sharedManager;

// 为sharedManager单例配置设置
+ (void)setupConfig:(void(^)(HLNetworkConfig *config))configBlock;

#pragma mark - API操作
/**
 使用sharedManager单例发送API
 
 @param api 需要发送的API
 */
+ (void)sendAPIRequest:(HLAPI *)api;

/**
 使用sharedManager取消API请求
 如果该请求已经发送或者正在发送，则无法取消，但会将Block回落点置空，delegate正常回调

 @param api 要取消的api
 */
+ (void)cancelAPIRequest:(HLAPI *)api;

#pragma mark - API集合请求
/**
 使用sharedManager发送一系列API请求

 @param apis 待发送的API请求集合
 */
+ (void)sendBatchAPIRequests:(HLAPIBatchRequests *)apis;

/**
 使用sharedManager发送同步请求
 
 @param apis 带发送的同步请求集合
 */
+ (void)sendChainAPIRequests:(HLAPIChainRequests *)apis;

#pragma mark - 注册/销毁网络消息监听
/**
 使用sharedManager移除网络请求监听者
 
 @param observer 监听者
 */
+ (void)registerNetworkResponseObserver:(id<HLAPIResponseDelegate>)observer;

/**
 使用sharedManager删除网络请求监听者
 
 @param observer 监听者
 */
+ (void)removeNetworkResponseObserver:(id<HLAPIResponseDelegate>)observer;

/**
 使用sharedManager添加网络传输错误时的监控observer

 @param observer 遵循HLNetworkErrorProtocol的observer
 */
+ (void)registerNetworkErrorObserver:(id<HLNetworkErrorProtocol>)observer;

/**
 使用sharedManager删除网络传输错误时的监控observer

 @param observer 遵循HLNetworkErrorProtocol的observer
 */
+ (void)removeNetworkErrorObserver:(id<HLNetworkErrorProtocol>)observer;

#pragma mark - reachability相关
// 当前reachability状态
@property (nonatomic, assign, readonly) HLReachabilityStatus reachabilityStatus;
// 当前是否可访问网络
@property (nonatomic, assign, readonly, getter = isReachable) BOOL reachable;
// 当前是否使用数据流量访问网络
@property (nonatomic, assign, readonly, getter = isReachableViaWWAN) BOOL reachableViaWWAN;
// 当前是否使用WiFi访问网络
@property (nonatomic, assign, readonly, getter = isReachableViaWiFi) BOOL reachableViaWiFi;

// 开启默认reachability监视器，block返回状态
+ (void)networkListening:(void(^)(HLReachabilityStatus status))listener;

// 默认reachability监视器停止监听
+ (void)stopListening;

// 监听给定的域名是否可以访问，block内返回状态
- (void)networkListeningWithDomain:(NSString *)domain listeningBlock:(void (^)(HLReachabilityStatus))listener;

// 停止给定域名的网络状态监听
- (void)stopListeningWithDomain:(NSString *)domain;
@end
NS_ASSUME_NONNULL_END
