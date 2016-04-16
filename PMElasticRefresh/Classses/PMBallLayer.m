//
//  PMBallLayer.m
//  PMElasticRefresh
//
//  Created by Andy on 16/4/13.
//  Copyright © 2016年 AYJk. All rights reserved.
//

#import "PMBallLayer.h"

@interface PMBallLayer ()

@property (nonatomic, assign) CGFloat riseDistance;
@property (nonatomic, strong) UIColor *ballColor;


@end

@implementation PMBallLayer

- (instancetype)initWithSize:(CGSize)ballSize fillColor:(UIColor *)fillColor riseDistance:(CGFloat)riseDistance {
    
    if (self = [super init]) {
        self.riseDistance = riseDistance;
        self.ballColor = fillColor;
        self.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - ballSize.width) * .5, 0, ballSize.width, ballSize.height);
        [self configShape];
    }
    return self;
}

- (void)configShape {
    
    CGPoint arcCenterPoint = CGPointMake(self.frame.size.width * .5, 250);
    CGFloat arcRadius = self.frame.size.width * .5;
    CGFloat arcStartAngle = 0;
    CGFloat arcEndAngle =  M_PI * 2;
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:arcCenterPoint radius:arcRadius startAngle:arcStartAngle endAngle:arcEndAngle clockwise:YES];
    self.path = bezierPath.CGPath;
    self.fillColor = self.ballColor.CGColor;
    self.strokeEnd = 1;
    
        
}

- (void)startAnimation {
    
    CABasicAnimation *moveupAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveupAnimation.fromValue = [NSValue valueWithCGPoint:self.position];
    moveupAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.position.x, self.position.y - 135)];
    moveupAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    moveupAnimation.fillMode = kCAFillModeForwards;
    moveupAnimation.removedOnCompletion = NO;
    [self addAnimation:moveupAnimation forKey:@"moveupAnimation"];
}

- (void)endAnimation {
    
    CABasicAnimation *pulldownAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    pulldownAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.position.x, self.position.y - 135)];
    pulldownAnimation.toValue = [NSValue valueWithCGPoint:self.position];
    pulldownAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    pulldownAnimation.fillMode = kCAFillModeForwards;
    pulldownAnimation.removedOnCompletion = NO;
    [self addAnimation:pulldownAnimation forKey:@"pulldownAnimation"];
}

@end
