//
//  BDDebugViewController.h
//  BMBridgeDebug
//
//  Created by BirdMichael on 2019/5/14.
//  Copyright © 2019 BirdMichael. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class BDDebugViewController;

@protocol BDDebugViewDelegate <NSObject>

- (void)onCloseWindow:(BDDebugViewController *)viewController;

- (void)fetchData:(BDDebugViewController *)viewController completion:(void (^)(NSArray<NSString *> *))completion;

@end

@interface BDDebugViewController : UIViewController

@property (nonatomic, weak) id<BDDebugViewDelegate> debugViewDelegate;

- (void)showNewLine:(NSArray<NSString *> *)line;

- (void)onWindowHide;
- (void)onWindowShow;

@end

NS_ASSUME_NONNULL_END
