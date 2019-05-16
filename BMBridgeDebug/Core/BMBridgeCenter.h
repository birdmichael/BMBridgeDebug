//
//  BMBirdgeCenter.h
//  BMBridgeDebug
//
//  Created by BirdMichael on 2019/5/15.
//  Copyright © 2019 BirdMichael. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "BMBridgeDebugHeader.h"

static NSString * _Nullable kBMBridgeDebugInvokeRequestEvent = @"kBMBridgeDebugInvokeRequestEvent";
static NSString * _Nullable kBMBridgeDebugInvokeResponseEvent = @"kBMBridgeDebugInvokeResponseEvent";

NS_ASSUME_NONNULL_BEGIN

@interface BMBridgeCenter : NSObject

@property (nonatomic, strong, readonly) WKWebView *webView;

@end

NS_ASSUME_NONNULL_END
