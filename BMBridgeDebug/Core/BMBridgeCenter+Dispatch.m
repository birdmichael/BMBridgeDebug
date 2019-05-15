//
//  BMBirdgeCenter+Dispatch.m
//  BMBridgeDebug
//
//  Created by BirdMichael on 2019/5/15.
//  Copyright © 2019 BirdMichael. All rights reserved.
//

#import "BMBridgeCenter+Dispatch.h"
#import "BMBridgeCenter+Scripts.h"
#import "BMBridgeDebugHeader.h"
#import "BDResponseManager.h"
#import "BMBridgeDebugProtocol.h"

@implementation BMBridgeCenter (Dispatch)

#pragma mark - core
- (void)dispatchParsingParameter:(NSDictionary *)contentJSON
{
    // 增加对异常参数的catch
    @try {
        NSDictionary *paramDict = [contentJSON objectForKey:kBDParamKey];
        NSString *callbackKey = [contentJSON objectForKey:@"callbackKey"];
        [self callNative:[contentJSON objectForKey:kBDActionKey] parameter:paramDict callbackKey:callbackKey];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kBMBridgeDebugInvokeRequestEvent object:contentJSON];
    } @catch (NSException *exception) {
//        [self showTextTip:@"H5接口异常"];
        BDDebugLog(@"h5接口解析异常，接口数据：%@", contentJSON);
    } @finally {
    }
}

#pragma mark - public
// 延迟初始化； 短路判断
- (BOOL)callNative:(NSString *)action parameter:(NSDictionary *)paramDict
{
    return [self callNative:action parameter:paramDict callbackKey:nil];
}

#pragma mark - private
- (BOOL)callNative:(NSString *)action parameter:(NSDictionary *)paramDict callbackKey:(NSString *)key
{
    BDResponseManager *rm = [BDResponseManager defaultManager];
    NSString *actionSig = [rm actionSignature:action withParam:paramDict withCallback:key.length > 0];
    id<BMBridgeDebugResponseProtocol> response = [rm responseForActionSignature:actionSig withBridgeCenter:self];
    //
    if (response == nil || ![response handleAction:action withParam:paramDict callbackKey:key]) {
        NSString *errMsg = [NSString stringWithFormat:@"action (%@) not supported yet.", action];
        BDDebugLog(@"action (%@) not supported yet.", action);
        [self fire:@"NotSupported" param:@{
                                           @"error": errMsg
                                           }];
        return NO;
    } else {
        return YES;
    }
}

@end
