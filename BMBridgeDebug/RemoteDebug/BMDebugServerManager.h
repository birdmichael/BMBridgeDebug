//
//  BMDebugServerManager.h
//  BMBridgeDebug
//
//  Created by BirdMichael on 2019/5/14.
//  Copyright © 2019 BirdMichael. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DataSigner

- (NSString *)algorithmName;
- (NSString *)signString:(NSString *)string;

@end

@interface BMDebugServerManager : NSObject


+ (instancetype)sharedInstance;

- (void)start;
- (void)stop;
- (void)showDebugWindow;
@end

NS_ASSUME_NONNULL_END
