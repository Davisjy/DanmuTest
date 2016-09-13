//
//  DanmuView.m
//  DanmuDemo
//
//  Created by Davis on 16/8/23.
//  Copyright © 2016年 Davis. All rights reserved.
//

#import "DanmuView.h"

@interface DanmuView ()
/** 弹幕label */
@property (nonatomic, strong) UILabel *danmuLabel;
/** 弹幕前面的头像 */
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation DanmuView

#define kPadding 10
#define kWh      30

/** 初始化方法 */
- (instancetype)initWithComment:(NSString *)commentStr {
    if (self = [super init]) {
        // 计算弹幕实际宽度
        CGFloat width = [commentStr sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}].width;
        self.layer.cornerRadius = kWh / 2;
        self.layer.masksToBounds = YES;
        self.bounds = CGRectMake(0, 0, width + kPadding * 2 + kWh, 30);
        self.backgroundColor = [UIColor redColor];
        self.danmuLabel.text = commentStr;
        self.danmuLabel.frame = CGRectMake(kPadding + kWh, 0, width, 30);
        
        self.imageView.image = [UIImage imageNamed:@"strat-1"];
        self.imageView.layer.cornerRadius = kWh / 2;
        self.imageView.layer.masksToBounds = YES;
        self.imageView.frame = CGRectMake(0, 0, kWh, kWh);
    }
    return self;
}

- (void)startAnimation {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat duration = 4.f;
    CGFloat wholeWidth = CGRectGetWidth(self.bounds) + screenWidth;
    
    if (self.moveStatuBlock) {
        self.moveStatuBlock(Start);
    }
    
    CGFloat speed = wholeWidth / duration;
    CGFloat time = CGRectGetWidth(self.bounds) / speed;
    [self performSelector:@selector(enterScreen) withObject:self afterDelay:time];
    
    __block CGRect frame = self.frame;
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        frame.origin.x -= wholeWidth;
        self.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.moveStatuBlock) {
            self.moveStatuBlock(End);
        }
    }];
}

- (void)enterScreen {
    if (self.moveStatuBlock) {
        self.moveStatuBlock(Enter);
    }
}

- (void)stopAnimation {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self.layer removeAllAnimations];
    [self removeFromSuperview];
}

- (UILabel *)danmuLabel {
    if (!_danmuLabel) {
        _danmuLabel = [[UILabel alloc] init];
        _danmuLabel.textColor = [UIColor cyanColor];
        _danmuLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_danmuLabel];
    }
    return _danmuLabel;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
    }
    return _imageView;
}

@end
