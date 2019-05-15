//
//  BridgeDebugResponse.m
//  BMBridgeDebug
//
//  Created by BirdMichael on 2019/5/15.
//  Copyright © 2019 BirdMichael. All rights reserved.
//

#import "BDResponse.h"
#import "BMBridgeCenter.h"
#import "BMBridgeCenter+Scripts.h"

@interface BDResponse ()
@property (nonatomic, weak, readwrite) WKWebView *webView;

@property (nonatomic, weak, readwrite) UIViewController *viewController;

@property (nonatomic, weak, readwrite) BMBridgeCenter *bridgeCenter;
@end

@implementation BDResponse

- (instancetype)initWithBridgeCenter:(BMBridgeCenter *)bridgeCenter {
    self = [super init];
    if (self) {
        _bridgeCenter = bridgeCenter;
    }
    return self;
}

- (void)fireCallback:(NSString *)callbackKey param:(NSDictionary *)paramDict
{
    [self.bridgeCenter fireCallback:callbackKey param:paramDict];
}

- (void)fire:(NSString *)actionName param:(NSDictionary *)paramDict
{
    [self.bridgeCenter fire:actionName param:paramDict];
}

- (void)dealloc
{
    _webView = nil;
    self.viewController = nil;
    self.bridgeCenter = nil;
}

- (BOOL)handleAction:(NSString *)action withParam:(NSDictionary *)paramDict callbackKey:(NSString *)callbackKey {
    if (action == nil) {
        return false;
    }
    SEL sel = nil;
    if (paramDict == nil || paramDict.allKeys.count == 0) {
        if (callbackKey.length == 0) {
            sel = NSSelectorFromString([NSString stringWithFormat:@"%@", action]);
        } else {
            sel = NSSelectorFromString([NSString stringWithFormat:@"%@WithCallback:", action]);
        }
    } else {
        if (callbackKey.length == 0) {
            sel = NSSelectorFromString([NSString stringWithFormat:@"%@:", action]);
        } else {
            sel = NSSelectorFromString([NSString stringWithFormat:@"%@:callback:", action]);
        }
    }
    
    if (![self respondsToSelector:sel]) {
        return NO;
    }
    [self runSelector:sel withObjects:[NSArray arrayWithObjects:paramDict, callbackKey, nil]];
    return YES;
}

- (id)runSelector:(SEL)aSelector withObjects:(NSArray *)objects {
    NSMethodSignature *methodSignature = [self methodSignatureForSelector:aSelector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    [invocation setTarget:self];
    [invocation setSelector:aSelector];
    
    NSUInteger i = 1;
    
    if (objects.count) {
        for (id object in objects) {
            id tempObject = object;
            [invocation setArgument:&tempObject atIndex:++i];
        }
    }
    [invocation invoke];
    
    if (methodSignature.methodReturnLength > 0) {
        id value;
        [invocation getReturnValue:&value];
        return value;
    }
    return nil;
}

+ (BOOL)isSupportedActionSignature:(NSString *)actionSignature {
    NSDictionary *support = [self supportActionList];
    
    // 如果数值大于0，表示是支持的，返回 YES
    if ([[support objectForKey:actionSignature] integerValue] > 0) {
        return YES;
    }
    return NO;
}

+ (NSDictionary<NSString *,NSString *> *)supportActionList {
    NSAssert(NO, @"Must implement handleActionFromH5 method");
    return @{};
}



@end
