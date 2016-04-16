//
//  PMElasticView.m
//  PMElasticRefresh
//
//  Created by Andy on 16/4/13.
//  Copyright © 2016年 AYJk. All rights reserved.
//

#import "PMElasticView.h"
#import "PMBallLayer.h"
#import "PMLineLayer.h"
#define CONTENTOFFSET_KEYPATH @"contentOffset"
#define PULLDISTANCE 100

//typedef enum : NSUInteger {
//    AYLodingStatus,
//    AYPullDownStatus
//} AYRefreshStatus;

@interface PMElasticView ()

@property (nonatomic, strong) UIScrollView *bindingScrollView;
//@property (nonatomic, assign) CGFloat offset;
@property (nonatomic, assign) CGFloat offSet_Y;
//@property (nonatomic, assign) AYRefreshStatus refreshStatus;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) CAShapeLayer *elasticShaperLayer;
@property (nonatomic, strong) PMBallLayer *ballLayer;
@property (nonatomic, strong) PMLineLayer *lineLayer;
@end

@implementation PMElasticView

- (void)dealloc {
    
    [self.bindingScrollView removeObserver:self forKeyPath:CONTENTOFFSET_KEYPATH];
}

- (instancetype)initWithFrame:(CGRect)frame bindingScrollView:(UIScrollView *)bindingScrollView {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.bindingScrollView = bindingScrollView;
        self.bindingScrollView.backgroundColor = [UIColor clearColor];
        [self configSubViews];
    }
    return self;
}

- (void)configSubViews {
    
    self.elasticShaperLayer = [[CAShapeLayer alloc] initWithLayer:self.layer];
    self.elasticShaperLayer.path = [self calculateAnimaPathWithOriginY:0];
    self.elasticShaperLayer.fillColor = [UIColor greenColor].CGColor;
    [self.layer addSublayer:self.elasticShaperLayer];
    [self addSubview:self.bindingScrollView];
    [self.bindingScrollView addObserver:self forKeyPath:CONTENTOFFSET_KEYPATH options:NSKeyValueObservingOptionInitial context:nil];
    
    self.ballLayer = [[PMBallLayer alloc] initWithSize:CGSizeMake(60, 60) fillColor:[UIColor whiteColor] riseDistance:130];
    [self.elasticShaperLayer addSublayer:self.ballLayer];
    
    self.lineLayer = [[PMLineLayer alloc] initWithSize:CGSizeMake(60, 60) StrokeColor:[UIColor whiteColor]];
    [self.elasticShaperLayer addSublayer:self.lineLayer];

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:CONTENTOFFSET_KEYPATH] && [object isKindOfClass:[UIScrollView class]]) {
        self.offSet_Y = self.bindingScrollView.contentOffset.y;
        if (self.bindingScrollView.dragging || self.offSet_Y > -164) {
            self.elasticShaperLayer.path = [self calculateAnimaPathWithOriginY:-self.offSet_Y];
        }
        [self changeScrollViewProperty];
//        self.ballLayer.position = CGPointMake(self.frame.size.width * .5, -self.offSet_Y);
    }
}

- (void)changeScrollViewProperty {
    
    if (self.offSet_Y < -64) {
//        self.ballLayer.position = CGPointMake(self.ballLayer.position.x, 194);
        if (self.offSet_Y <= -164) {
            self.bindingScrollView.alpha = 0;
//  松手刷新状态
            if (!self.bindingScrollView.dragging) {
                [self.bindingScrollView setContentOffset:CGPointMake(0, -164) animated:NO];
                [self elasticLayerAnimation];
            }
        } else {
            self.bindingScrollView.alpha = ABS(1 + ((self.offSet_Y + 64) / PULLDISTANCE));
        }
    } else {
        self.bindingScrollView.alpha = 1;
    }
}

- (void)elasticLayerAnimation {
    
    NSArray *pathValues = @[
                           (__bridge id)[self calculateAnimaPathWithOriginY:-self.offSet_Y],
                           (__bridge id)[self calculateAnimaPathWithOriginY:164 * 0.7],
                           (__bridge id)[self calculateAnimaPathWithOriginY:164 * 1.3],
                           (__bridge id)[self calculateAnimaPathWithOriginY:164 * 0.9],
                           (__bridge id)[self calculateAnimaPathWithOriginY:164 * 1.1],
                           (__bridge id)[self calculateAnimaPathWithOriginY:164]
                           ];
    CAKeyframeAnimation *elasticAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    elasticAnimation.values = pathValues;
    elasticAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    elasticAnimation.duration = 1;
    elasticAnimation.fillMode = kCAFillModeForwards;
    elasticAnimation.removedOnCompletion = NO;
    elasticAnimation.delegate = self;
    [self.elasticShaperLayer addAnimation:elasticAnimation forKey:@"elasticAnimation"];
    
    [self.ballLayer startAnimation];
    [self.lineLayer startAnimation];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    if (flag) {
        self.elasticShaperLayer.path = [self calculateAnimaPathWithOriginY:164];
        [self.elasticShaperLayer removeAnimationForKey:@"elasticAnimation"];
    }
}

- (void)endRefresh {
    
    [self.bindingScrollView setContentOffset:CGPointMake(0, -64) animated:YES];
    [self.ballLayer endAnimation];
    [self.lineLayer endAnimation];
}

- (CGPathRef)calculateAnimaPathWithOriginY:(CGFloat)originY {
    
    CGPoint topLeftPoint = CGPointMake(0,64);
    CGPoint bottomLeftPoint = CGPointMake(0, self.offSet_Y <= -164 ? 164 : originY);
    CGPoint controlPoint = CGPointMake(self.bindingScrollView.bounds.size.width * .5, originY);
    CGPoint bottomRightPoint = CGPointMake(self.bindingScrollView.bounds.size.width, self.offSet_Y <= -164 ? 164 : originY);
    CGPoint topRightPoint = CGPointMake(self.bindingScrollView.bounds.size.width, 64);
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:topLeftPoint];
    [bezierPath addLineToPoint:bottomLeftPoint];
    [bezierPath addQuadCurveToPoint:bottomRightPoint controlPoint:controlPoint];
    [bezierPath addLineToPoint:topRightPoint];
    [bezierPath addLineToPoint:topLeftPoint];
    return bezierPath.CGPath;
}

@end