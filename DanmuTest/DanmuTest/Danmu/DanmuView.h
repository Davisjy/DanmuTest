//
//  DanmuView.h
//  DanmuDemo
//
//  Created by Davis on 16/8/23.
//  Copyright © 2016年 Davis. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    Start,
    Enter,
    End,
} Stauts;

@interface DanmuView : UIView
/** 弹道 */
@property (nonatomic, assign) NSInteger trajectory;
/** 移动状态的回调 */
@property (nonatomic, copy) void(^moveStatuBlock)(Stauts stauts);

/** 初始化方法 */
- (instancetype)initWithComment:(NSString *)commentStr;

- (void)startAnimation;
- (void)stopAnimation;

@end
