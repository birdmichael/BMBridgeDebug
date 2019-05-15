//
//  BridgeDebugResponse.h
//  BMBridgeDebug
//
//  Created by BirdMichael on 2019/5/15.
//  Copyright © 2019 BirdMichael. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BMBridgeDebugProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface BDResponse : NSObject <BMBridgeDebugResponseProtocol>
- (void)fireCallback:(NSString *)callbackKey param:(NSDictionary *)paramDict;

/**
 * <B> 辅助方法，转发到 appHost 的接口 </B>
 */
- (void)fire:(NSString *)actionName param:(NSDictionary *)paramDict;
@end

NS_ASSUME_NONNULL_END
