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

static NSString *kBMBridgeDebugInvokeRequestEvent = @"kBMBridgeDebugInvokeRequestEvent";
static NSString *kBMBridgeDebugResponseEvent = @"kBMBridgeDebugResponseEvent";

NS_ASSUME_NONNULL_BEGIN

@interface BMBirdgeCenter : NSObject

@property (nonatomic, strong, readonly) WKWebView *webView;

@end

NS_ASSUME_NONNULL_END
