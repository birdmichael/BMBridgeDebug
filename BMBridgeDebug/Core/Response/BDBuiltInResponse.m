//
//  BDBuiltInResponse.m
//  BMBridgeDebug
//
//  Created by BirdMichael on 2019/5/16.
//  Copyright © 2019 BirdMichael. All rights reserved.
//

#import "BDBuiltInResponse.h"
#import "BMBridgeCenter.h"

@implementation BDBuiltInResponse
+ (NSDictionary<NSString *, NSString *> *)supportActionList
{
    return @{
             @"versionNumber" : @"1",
             };
}

#pragma mark - inner
bd_doc_begin(versionNumber, "loading 的 HUD 动画，这里是AppHost默认实现显示。")
bd_doc_param(text, "字符串，设置和 loading 动画一起显示的文案")
bd_doc_code(window.bridgeDebug.invoke("versionNumber"))
bd_doc_code_expect("在屏幕上出现 loading 动画，多次调用此接口，不应该出现多个")
bd_doc_return(NSNumber, "返回版本号")
bd_doc_end


- (void)versionNumber {
    NSLog(@"%@", @(BMBridgeDebugVersionNumber));
}

@end
