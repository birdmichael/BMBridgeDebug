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

bd_doc_begin(versionNumber, "返回当前的版本。")
bd_doc_code(window.bridgeDebug.invoke("versionNumber"))
bd_doc_return(NSNumber, "返回版本号")
bd_doc_end
- (void)versionNumber {
    NSLog(@"%@", @(BMBridgeDebugVersionNumber));
}

@end
