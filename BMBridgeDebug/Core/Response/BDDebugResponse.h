//
//  BDDebugResponse.h
//  BMBridgeDebug
//
//  Created by BirdMichael on 2019/5/15.
//  Copyright © 2019 BirdMichael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BDResponse.h>

NS_ASSUME_NONNULL_BEGIN
static NSString *kAppHostTestCaseFileName = @"testcase.html";
@interface BDDebugResponse : BDResponse

+ (void)setupDebugger;

@end

NS_ASSUME_NONNULL_END
