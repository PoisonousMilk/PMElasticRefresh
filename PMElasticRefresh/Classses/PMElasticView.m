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
#define AnimationDISTANCE -100
#define NavigationHeight 64
//typedef enum : NSUInteger {
//    AYLodingStatus,
//    AYPullDownStatus
//} AYRefreshStatus;

@interface PMElasticView ()

@property (nonatomic, strong) UIScrollView *bindingScrollView;
//@property (nonatomic, assign) CGFloat offset;
@property (nonatomic, assign) CGFloat offSet_Y;
//@property (nonatomic, assign) AYRefreshStatus refreshStatus;
@property (nonatomic, strong) CAShapeLayer *elasticShaperLayer;
@property (nonatomic, strong) PMBallLayer *ballLayer;
@property (nonatomic, strong) PMLineLayer *lineLayer;
@end

@implementation PMElasticView

- (void)dealloc {
    
    [self.bindingScrollView removeObserver:self forKeyPath:CONTENTOFFSET_KEYPATH];
}

- (instancetype)initWithBindingScrollView:(UIScrollView *)bindingScrollView {
    
    if (self = [super initWithFrame:CGRectZero]) {
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
//    [self addSubview:self.bindingScrollView];
    [self.bindingScrollView addObserver:self forKeyPath:CONTENTOFFSET_KEYPATH options:NSKeyValueObservingOptionInitial context:nil];
    
    self.ballLayer = [[PMBallLayer alloc] initWithSize:CGSizeMake(60, 60) fillColor:[UIColor whiteColor] animationHeight:ABS(AnimationDISTANCE)];
    [self.elasticShaperLayer addSublayer:self.ballLayer];
    
    self.lineLayer = [[PMLineLayer alloc] initWithSize:CGSizeMake(60, 60) StrokeColor:[UIColor whiteColor] animationHeight:ABS(AnimationDISTANCE)];
    [self.elasticShaperLayer addSublayer:self.lineLayer];

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:CONTENTOFFSET_KEYPATH] && [object isKindOfClass:[UIScrollView class]]) {
        self.offSet_Y = self.bindingScrollView.contentOffset.y + NavigationHeight;
        self.frame = CGRectMake(0, self.offSet_Y >=0 ? 0 : self.offSet_Y, self.bindingScrollView.bounds.size.width, self.offSet_Y >=0 ? 0 : ABS(self.offSet_Y));
        NSLog(@"%f",self.offSet_Y);
        if (self.bindingScrollView.dragging || self.offSet_Y > AnimationDISTANCE) {
            self.elasticShaperLayer.path = [self calculateAnimaPathWithOriginY:-self.offSet_Y];
        }
        [self changeScrollViewProperty];
    }
}

- (void)changeScrollViewProperty {
    
    if (self.offSet_Y <= AnimationDISTANCE) {
//        self.bindingScrollView.alpha = 0;
//  松手刷新状态
        if (!self.bindingScrollView.dragging) {
            [self.bindingScrollView setContentOffset:CGPointMake(0, AnimationDISTANCE - NavigationHeight) animated:NO];
            [self elasticLayerAnimation];
        } else {
//            self.bindingScrollView.alpha = ABS(1 + ((self.offSet_Y + 64) / AnimationDISTANCE));
        }
    } else {
        self.bindingScrollView.alpha = 1;
    }
}

- (void)elasticLayerAnimation {
    
    NSArray *pathValues = @[
                           (__bridge id)[self calculateAnimaPathWithOriginY:ABS(self.offSet_Y)],
                           (__bridge id)[self calculateAnimaPathWithOriginY:ABS(AnimationDISTANCE) * 0.7],
                           (__bridge id)[self calculateAnimaPathWithOriginY:ABS(AnimationDISTANCE) * 1.3],
                           (__bridge id)[self calculateAnimaPathWithOriginY:ABS(AnimationDISTANCE) * 0.9],
                           (__bridge id)[self calculateAnimaPathWithOriginY:ABS(AnimationDISTANCE) * 1.1],
                           (__bridge id)[self calculateAnimaPathWithOriginY:ABS(AnimationDISTANCE)]
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
        self.elasticShaperLayer.path = [self calculateAnimaPathWithOriginY:ABS(AnimationDISTANCE)];
        [self.elasticShaperLayer removeAnimationForKey:@"elasticAnimation"];
    }
}

- (void)endRefresh {
    
    [self.bindingScrollView setContentOffset:CGPointMake(0, -NavigationHeight) animated:YES];
    [self.ballLayer endAnimation];
    [self.lineLayer endAnimation];
}

- (CGPathRef)calculateAnimaPathWithOriginY:(CGFloat)originY {
    
    CGPoint topLeftPoint = CGPointMake(0,0);
    CGPoint bottomLeftPoint = CGPointMake(0, self.offSet_Y <= AnimationDISTANCE ? 100 : originY);
    CGPoint controlPoint = CGPointMake(self.bindingScrollView.bounds.size.width * .5, originY);
    NSLog(@"controlPoing %@",NSStringFromCGPoint(controlPoint));
    CGPoint bottomRightPoint = CGPointMake(self.bindingScrollView.bounds.size.width, self.offSet_Y <= AnimationDISTANCE ? 100 : originY);
    CGPoint topRightPoint = CGPointMake(self.bindingScrollView.bounds.size.width, 0);
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:topLeftPoint];
    [bezierPath addLineToPoint:bottomLeftPoint];
    [bezierPath addQuadCurveToPoint:bottomRightPoint controlPoint:controlPoint];
    [bezierPath addLineToPoint:topRightPoint];
    [bezierPath addLineToPoint:topLeftPoint];
    return bezierPath.CGPath;
}

@end