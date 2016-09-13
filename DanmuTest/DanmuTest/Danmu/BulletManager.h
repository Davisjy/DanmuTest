//
//  BulletManager.h
//  DanmuDemo
//
//  Created by Davis on 16/8/23.
//  Copyright © 2016年 Davis. All rights reserved.
//  弹幕管理类

#import <Foundation/Foundation.h>

@class DanmuView;
@interface BulletManager : NSObject

@property (nonatomic, copy) void(^genaralBullet)(DanmuView *view);

- (void)star;

- (void)stop;

@end
