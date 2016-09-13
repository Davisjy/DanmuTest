//
//  ViewController.m
//  DanmuTest
//
//  Created by Davis on 16/9/13.
//  Copyright © 2016年 Davis. All rights reserved.
//

#import "ViewController.h"

#import "BulletManager.h"
#import "DanmuView.h"

@interface ViewController ()
@property (nonatomic, strong) BulletManager *manager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    BulletManager *manager = [[BulletManager alloc] init];
    self.manager = manager;
    __weak typeof(self) mySelf = self;
    manager.genaralBullet = ^(DanmuView *view) {
        [mySelf addDanmmu:view];
    };
    
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [startBtn setTitle:@"开始" forState:UIControlStateNormal];
    startBtn.titleLabel.textColor = [UIColor redColor];
    [startBtn addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    startBtn.backgroundColor = [UIColor cyanColor];
    startBtn.frame = CGRectMake(100, 100, 100, 30);
    [self.view addSubview:startBtn];
    
    UIButton *endBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [endBtn setTitle:@"停止" forState:UIControlStateNormal];
    endBtn.titleLabel.textColor = [UIColor redColor];
    [endBtn addTarget:self action:@selector(endAction) forControlEvents:UIControlEventTouchUpInside];
    endBtn.backgroundColor = [UIColor cyanColor];
    endBtn.frame = CGRectMake(230, 100, 100, 30);
    [self.view addSubview:endBtn];
}

- (void)start {
    [self.manager star];
}

- (void)endAction {
    [self.manager stop];
}

- (void)addDanmmu:(DanmuView *)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    view.frame = CGRectMake(width, 300 + view.trajectory * 40, CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds));
    [self.view addSubview:view];
    [view startAnimation];
}

@end
