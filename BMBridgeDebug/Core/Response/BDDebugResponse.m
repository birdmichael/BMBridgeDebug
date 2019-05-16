//
//  BDDebugResponse.m
//  BMBridgeDebug
//
//  Created by BirdMichael on 2019/5/15.
//  Copyright © 2019 BirdMichael. All rights reserved.
//

#import "BDDebugResponse.h"
#import "BMBridgeCenter.h"
#import "BMBridgeCenter+Scripts.h"
#import "BDResponseManager.h"
#import "BMBridgeDebugHeader.h"

// 保存 weinre 注入脚本的地址，方便在加载其它页面时也能自动注入。
static NSString *kLastWeinreScript = nil;
@implementation BDDebugResponse

+ (void)setupDebugger
{
#ifdef BD_DEBUG
    NSBundle *bundle = [NSBundle bundleForClass:BMBridgeCenter.class];
    NSMutableArray *scripts = [NSMutableArray arrayWithObjects:
                               @{// 记录 window.DocumentEnd 的时间
                                 @"code": @"window.DocumentEnd =(new Date()).getTime()",
                                 @"when": @(WKUserScriptInjectionTimeAtDocumentEnd),
                                 @"key": @"documentEndTime.js"
                                 },
                               @{// 记录 DocumentStart 的时间
                                 @"code": @"window.DocumentStart = (new Date()).getTime()",
                                 @"when": @(WKUserScriptInjectionTimeAtDocumentStart),
                                 @"key": @"documentStartTime.js"
                                 },
                               @{// 重写 console.log 方法
                                 @"code": @"window.__ah_consolelog = console.log; console.log = function(_msg){window.__ah_consolelog(_msg);appHost.invoke('console.log', {'text':_msg})}",
                                 @"when": @(WKUserScriptInjectionTimeAtDocumentStart),
                                 @"key": @"console.log.js"
                                 },
                               @{// 记录 readystatechange 的时间
                                 @"code": @"document.addEventListener('readystatechange', function (event) {window['readystate_' + document.readyState] = (new Date()).getTime();});",
                                 @"when": @(WKUserScriptInjectionTimeAtDocumentStart),
                                 @"key": @"readystatechange.js"
                                 },nil
                               ];
    
    NSURL *profile = [[bundle bundleURL] URLByAppendingPathComponent:@"/profile/profiler.js"];
    NSString *profileTxt = [NSString stringWithContentsOfURL:profile encoding:NSUTF8StringEncoding error:nil];
    // profile
    [scripts addObject:@{
                         @"code": profileTxt,
                         @"when": @(WKUserScriptInjectionTimeAtDocumentEnd),
                         @"key": @"profile.js"
                         }];
    
    NSURL *timing = [[bundle bundleURL] URLByAppendingPathComponent:@"/profile/pageTiming.js"];
    NSString *timingTxt = [NSString stringWithContentsOfURL:timing encoding:NSUTF8StringEncoding error:nil];
    // timing
    [scripts addObject:@{
                         @"code": timingTxt,
                         @"when": @(WKUserScriptInjectionTimeAtDocumentEnd),
                         @"key": @"timing.js"
                         }];
    
    [scripts enumerateObjectsUsingBlock:^(NSDictionary  * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [BMBridgeCenter prepareJavaScript:[obj objectForKey:@"code"] when:[[obj objectForKey:@"when"] integerValue] key:[obj objectForKey:@"key"]];
    }];
#endif
}

- (BOOL)handleAction:(NSString *)action withParam:(NSDictionary *)paramDict callbackKey:(NSString *)callbackKey
{
#ifdef BD_DEBUG
    if ([@"eval" isEqualToString:action]) {
        [self.bridgeCenter evalExpression:[paramDict objectForKey:@"code"] completion:^(id  _Nonnull result, NSString * _Nonnull error) {
            BDDebugLog(@"%@, error = %@", result, error);
            NSDictionary *r = nil;
            if (result) {
                r = @{
                      @"result":[NSString stringWithFormat:@"%@", result]
                      };
            } else {
                r = @{
                      @"error":[NSString stringWithFormat:@"%@", error]
                      };
            }
            [self fire:@"eval" param:r];
        }];
    } else if ([@"list" isEqualToString:action]) {
        // 遍历所有的可用接口和注释和测试用例
        //TODO 分页
        [self fire:@"list" param:[[BDResponseManager defaultManager] allResponseMethods]];
    } else if ([@"apropos" isEqualToString:action]) {
        NSString *signature = [paramDict objectForKey:@"signature"];
        Class appHostCls = [[BDResponseManager defaultManager] responseForActionSignature:signature];
        SEL targetMethod = bd_doc_selector(signature);
        NSString *funcName = [@"apropos." stringByAppendingString:signature];
        if (appHostCls && [appHostCls respondsToSelector:targetMethod]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            NSDictionary *doc = [appHostCls performSelector:targetMethod withObject:nil];
#pragma clang diagnostic pop

            [self fire:funcName param:doc];
        } else {
            NSString *err = nil;
            if (appHostCls) {
                err = [NSString stringWithFormat:@"The doc of method (%@) is not found!", signature];
            } else {
                err = [NSString stringWithFormat:@"The method (%@) doesn't exsit!", signature];
            }
            [self fire:funcName param:@{@"error":err}];
        }
    }else if ([@"testcase" isEqualToString:action]) {
//        // 检查是否有文件生成，如果没有则遍历
//        NSString *docsdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//        NSString *file = [docsdir stringByAppendingPathComponent:kAppHostTestCaseFileName];
//
//        if (![[NSFileManager defaultManager] fileExistsAtPath:file]) {
//            [self generatorHtml];
//        }
//        [self.appHost loadLocalFile:[NSURL fileURLWithPath:file] domain:@"http://you.163.com"];
//        // 支持 或者关闭 weinre 远程调试
    }else if ([@"weinre" isEqualToString:action]) {
//         $ weinre --boundHost 10.242.24.59 --httpPort 9090
        BOOL disabled = [[paramDict objectForKey:@"disabled"] boolValue];
        if (disabled) {
            [self disableWeinreSupport];
        } else {
            kLastWeinreScript = [paramDict objectForKey:@"url"];
            [self enableWeinreSupport];
        }
    }else if ([@"timing" isEqualToString:action]) {
//        BOOL mobile = [[paramDict objectForKey:@"mobile"] boolValue];
//        if (mobile) {
//            [self.appHost fire:@"requestToTiming" param:@{}];
//        } else {
//            [self.appHost.webView evaluateJavaScript:@"window.performance.timing.toJSON()" completionHandler:^(NSDictionary *_Nullable r, NSError * _Nullable error) {
//                [self fire:@"requestToTiming_on_mac" param:r];
//            }];
//        }
//        //
    } else if ([@"clearCookie" isEqualToString:action]) {
        // 清理 WKWebview 的 Cookie，和 NSHTTPCookieStorage 是独立的
        WKHTTPCookieStore * _Nonnull cookieStorage = [WKWebsiteDataStore defaultDataStore].httpCookieStore;
        [cookieStorage getAllCookies:^(NSArray<NSHTTPCookie *> * _Nonnull cookies) {
            [cookies enumerateObjectsUsingBlock:^(NSHTTPCookie * _Nonnull cookie, NSUInteger idx, BOOL * _Nonnull stop) {
                [cookieStorage deleteCookie:cookie completionHandler:nil];
            }];

            [self.bridgeCenter fire:@"clearCookieDone" param:@{@"count":@(cookies.count)}];
        }];
    } else if ([@"console.log" isEqualToString:action]) {
        // 正常的日志输出时，不需要做特殊处理。
        // 因为在 invoke 的时候，已经向 debugger Server 发送过日志数据，已经打印过了
    } else {
        return NO;
    }
    return YES;
    
#else
    return NO;
#endif
}

// 注入 weinre 文件
- (void)enableWeinreSupport
{
    if (kLastWeinreScript.length == 0) {
        return;
    }
    [BMBridgeCenter prepareJavaScript:[NSURL URLWithString:kLastWeinreScript] when:WKUserScriptInjectionTimeAtDocumentEnd key:@"weinre.js"];
    [self.bridgeCenter fire:@"weinre.enable" param:@{@"jsURL": kLastWeinreScript}];
}

- (void)disableWeinreSupport
{
    kLastWeinreScript = nil;
    [BMBridgeCenter removeJavaScriptForKey:@"weinre.js"];
}

+ (NSDictionary<NSString *, NSString *> *)supportActionList {
    return @{
#ifdef BD_DEBUG
             @"eval_" : @"1",
             @"list" : @"1",
             @"apropos_": @"1",
             @"testcase" : @"1",
             @"weinre_" : @"1",
             @"timing_" : @"1",
             @"console.log_": @"1",
             @"clearCookie": @"1"
#endif
             };
}

@end
