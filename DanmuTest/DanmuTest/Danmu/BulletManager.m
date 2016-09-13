//
//  BulletManager.m
//  DanmuDemo
//
//  Created by Davis on 16/8/23.
//  Copyright © 2016年 Davis. All rights reserved.
//  

#import "BulletManager.h"
#import "DanmuView.h"

@interface BulletManager ()
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *dataSource;
/** 当前弹幕显示的评论数组 */
@property (nonatomic, strong) NSMutableArray *bulletComments;
/** 弹幕视图数组 */
@property (nonatomic, strong) NSMutableArray *bulletViews;
/** 停止动画标识 */
@property (nonatomic, assign) BOOL stopAnimator;
@end

@implementation BulletManager

- (instancetype)init {
    if (self = [super init]) {
        _stopAnimator = YES;
    }
    return self;
}

- (void)star {
    if (!self.stopAnimator) {
        return;
    }
    self.stopAnimator = NO;
    [self.bulletComments removeAllObjects];
    [self.bulletComments addObjectsFromArray:self.dataSource];
    
    [self initBulletComment];
}

/** 初始化弹幕, 随机分配弹道 */
- (void)initBulletComment {
    if (self.stopAnimator) {
        return;
    }
    // 弹道数组
    NSMutableArray *danmuLine = [NSMutableArray arrayWithArray:@[@1, @2, @3]];
    for (int i = 0; i < 3; i++) {
        if (self.bulletComments.count > 0) {            
            NSInteger index = arc4random()%danmuLine.count;
            NSInteger currentIndex = [danmuLine[index] integerValue];
            [danmuLine removeObjectAtIndex:index];
            
            // 每次从弹幕数组中取出第一条数据
            NSString *commenStr = [self.bulletComments firstObject];
            [self.bulletComments removeObjectAtIndex:0];
            [self createBulletView:commenStr andLine:currentIndex];
        }
    }
}

// 创建弹幕view
- (void)createBulletView:(NSString *)commentStr andLine:(NSInteger)line {
    if (self.stopAnimator) {
        return;
    }
    DanmuView *view = [[DanmuView alloc] initWithComment:commentStr];
    view.trajectory = line;
    [self.bulletViews addObject:view];
    __weak typeof(view) myView = view;
    __weak typeof(self) mySelf = self;
    view.moveStatuBlock = ^(Stauts status) {
        if (mySelf.stopAnimator) {
            return ;
        }
        switch (status) {
            case Start: {
                // 加入管理起来
                [mySelf.bulletViews addObject:myView];
                break;
            }
            case Enter: {
                // 判断是否有下一条数据
                NSString *comment = [mySelf nextComment];
                if (comment) {
                    [self createBulletView:comment andLine:line];
                }
                break;
            }
            case End: {
                if ([mySelf.bulletViews containsObject:myView]) {
                    [myView stopAnimation];
                    [mySelf.bulletViews removeObject:myView];
                }
                // 如果没有弹幕了就重新开始
                if (mySelf.bulletViews.count == 0) {
                    self.stopAnimator = YES;
                    [mySelf star];
                }
                break;
            }
            default:
                break;
        }
    };
    
    if (_genaralBullet) {
        _genaralBullet(view);
    }
}

- (NSString *)nextComment {
    if (self.bulletComments.count == 0) {
        return nil;
    }
    NSString *comment = self.bulletComments.firstObject;
    if (comment) {
        [self.bulletComments removeObjectAtIndex:0];
    }
    return comment;
}

- (void)stop {
    if (self.stopAnimator) {
        return;
    }
    self.stopAnimator = YES;
    [self.bulletViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        DanmuView *view = obj;
        [view stopAnimation];
        view = nil;
    }];

    
    [self.bulletViews removeAllObjects];
}


#pragma mark - 懒加载
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithArray:@[@"弹幕1~~~~~~~~~~",
                                                       @"弹幕2~~~~~",
                                                       @"弹幕3~~~~~~~~~~~~~~~~~~",
                                                       @"弹幕1~~~~~~~~~~",
                                                       @"弹幕2~~~~~",
                                                       @"弹幕3~~~~~~~~~~~~~~~~~~",
                                                       @"弹幕1~~~~~~~~~~",
                                                       @"弹幕2~~~~~",
                                                       @"弹幕3~~~~~~~~~~~~~~~~~~",
                                                       @"弹幕1~~~~~~~~~~",
                                                       @"弹幕2~~~~~",
                                                       @"弹幕3~~~~~~~~~~~~~~~~~~"]];
    }
    return _dataSource;
}

- (NSMutableArray *)bulletComments {
    if (!_bulletComments) {
        _bulletComments = [NSMutableArray array];
    }
    return _bulletComments;
}

- (NSMutableArray *)bulletViews {
    if (!_bulletViews) {
        _bulletViews = [NSMutableArray array];
    }
    return _bulletViews;
}

@end
