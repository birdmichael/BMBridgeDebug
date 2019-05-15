//
//  BMBirdgeCenter+Dispatch.h
//  BMBridgeDebug
//
//  Created by BirdMichael on 2019/5/15.
//  Copyright © 2019 BirdMichael. All rights reserved.
//

#import "BMBridgeCenter.h"

NS_ASSUME_NONNULL_BEGIN

@interface BMBridgeCenter (Dispatch)

/**
 * 核心的h5调用native接口的分发器；
 * @return 是否已经被处理，YES 表示可被处理；
 */
- (BOOL)callNative:(NSString *)action parameter:(NSDictionary *)paramDict;

#pragma mark - like private

- (void)dispatchParsingParameter:(NSDictionary *)contentJSON;

@end

NS_ASSUME_NONNULL_END
