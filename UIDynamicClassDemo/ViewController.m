//
//  ViewController.m
//  UIDynamicClassDemo
//
//  Created by Goko on 30/10/2017.
//  Copyright © 2017 Goko. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property(nonatomic, strong) UIDynamicAnimator * animator;
@property(nonatomic, strong) UIView * blueView;
@property(nonatomic, strong) UIView * redView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.blueView];
    [self.view addSubview:self.redView];
    
    [self startAnimator];
}
-(void)startAnimator{
    [self.animator removeAllBehaviors];
    UIGravityBehavior * gravity = [self gravity];
    [gravity addItem:self.blueView];
    [gravity addItem:self.redView];
    [self.animator addBehavior:gravity];
    
    UICollisionBehavior * collision = [self collision];
    [collision addItem:self.blueView];
    [collision addItem:self.redView];
    
    //添加自定义边界
    CGFloat width = self.view.frame.size.width;
    UIBezierPath * path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 500, width, width)];
    [collision addBoundaryWithIdentifier:@"circle" forPath:path];
    [self drawPath:path];
    
    [self.animator addBehavior:collision];
}
-(void)drawPath:(UIBezierPath *)path{
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    shapeLayer.lineWidth = 2;
    shapeLayer.fillColor = UIColor.clearColor.CGColor;
    shapeLayer.strokeColor = UIColor.yellowColor.CGColor;;
    shapeLayer.path = path.CGPath;
    [self.view.layer addSublayer:shapeLayer];
}
-(UIView *)blueView{
    if (nil == _blueView) {
        UIView * view = [UIView new];
        view.backgroundColor = UIColor.blueColor;
        view.frame = CGRectMake(100, 0, 100, 100);
        _blueView = view;
    }
    return _blueView;
}
-(UIView *)redView{
    if (nil == _redView) {
        UIView * view = [UIView new];
        view.backgroundColor = UIColor.redColor;
        view.frame = CGRectMake(100, 0, 50, 300);
        view.layer.anchorPoint = CGPointMake(0.5, 0.5);
        _redView = view;
    }
    return _redView;
}
-(UIDynamicAnimator *)animator{
    if (nil == _animator) {
        UIDynamicAnimator * animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
        _animator = animator;
    }
    return _animator;
}
-(UIGravityBehavior *)gravity{
    UIGravityBehavior * gravity = [UIGravityBehavior new];
    //重力的方向
    //    gravity.gravityDirection = CGVectorMake(100, 100);
    //重力的加速度
    gravity.magnitude = 1;
    return gravity;
}
-(UICollisionBehavior *)collision{
    UICollisionBehavior * collision = [[UICollisionBehavior alloc] init];
    //将参照视图的bounds设置为碰撞边界
    collision.translatesReferenceBoundsIntoBoundary = YES;
    collision.action = ^{
        NSLog(@"%@",NSStringFromCGRect(self.redView.frame));
    };
    return collision;
}
-(UISnapBehavior *)snap{
    UISnapBehavior * snap = [UISnapBehavior new];
    snap.damping = 1.0;
    return snap;
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //获取点击的位置
    UITouch * touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    UISnapBehavior * snap = [[UISnapBehavior alloc] initWithItem:self.redView snapToPoint:point];
    snap.damping = 1.0;
    [self.animator removeAllBehaviors];
    [self.animator addBehavior:snap];
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self startAnimator];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
