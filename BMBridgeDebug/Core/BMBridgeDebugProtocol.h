//
//  BMBridgeDebugProtocol.h
//  BMBridgeDebug
//
//  Created by BirdMichael on 2019/5/14.
//  Copyright © 2019 BirdMichael. All rights reserved.
//

#ifndef BMBridgeDebugProtocol_h
#define BMBridgeDebugProtocol_h
#import <Foundation/Foundation.h>

@protocol BMBridgeDebugProtocol <NSObject>

@required

/**
 尝试处理来自 h5 的请求，如果不能处理，则返回 NO。
 
 @param action h5 的 actionName
 @param paramDict 本次请求的参数
 @param callbackKey js 端匿名回调
 @return YES 表示可以处理，已处理；
 */
- (BOOL)handleAction:(NSString *)action withParam:(NSDictionary *)paramDict callbackKey:(NSString *)callbackKey;


@end

#endif /* BMBridgeDebugProtocol_h */
