//
//  BDResponseManager.h
//  BMBridgeDebug
//
//  Created by BirdMichael on 2019/5/15.
//  Copyright © 2019 BirdMichael. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDResponse.h"
#import "BMBridgeDebugProtocol.h"
#import "BMBridgeCenter.h"

NS_ASSUME_NONNULL_BEGIN

@interface BDResponseManager : NSObject

/**
 自定义response类
 */
@property (nonatomic, strong, readonly) NSMutableArray *customResponseClasses;

+ (instancetype)defaultManager;

#ifdef BD_DEBUG

/**
 获取所有注册的 Response 的接口
 
 @return 返回所有 class 支持的 methods，以 class 为 key。key 对应的数据包含所有这个 class 支持的方法
 */
- (NSDictionary *)allResponseMethods;

#endif


#pragma mark - 自定义 Response 区域
/**
 注册自定义的 Response
 
 @param cls 可以处理响应的子类 class，其符合 AppHostProtocol
 */
- (void)addCustomResponse:(Class<BMBridgeDebugResponseProtocol>)cls;

- (id<BMBridgeDebugResponseProtocol>)responseForActionSignature:(NSString *)actionSignature withBridgeCenter:(BMBridgeCenter *)center;

- (Class)responseForActionSignature:(NSString *)signature;

- (NSString *)actionSignature:(NSString *)action withParam:(BOOL)hasParamDict withCallback:(BOOL)hasCallback;

@end

NS_ASSUME_NONNULL_END
