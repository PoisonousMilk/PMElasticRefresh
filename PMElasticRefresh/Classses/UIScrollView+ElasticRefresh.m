//
//  UIScrollView+ElasticRefresh.m
//  PMElasticRefresh
//
//  Created by Andy on 16/4/16.
//  Copyright © 2016年 AYJk. All rights reserved.
//

#import "UIScrollView+ElasticRefresh.h"
#import <objc/runtime.h>

static const void *PMElasticViewKey = &PMElasticViewKey;

@implementation UIScrollView (ElasticRefresh)

- (void)pm_RefreshHeader {
    
    PMElasticView *elasticView = [[PMElasticView alloc] initWithBindingScrollView:self];
    self.elasticView = elasticView;
    [self addSubview:elasticView];
}

- (PMElasticView *)elasticView {
    
    return objc_getAssociatedObject(self, PMElasticViewKey);
}

- (void)setElasticView:(PMElasticView *)elasticView {
    
    objc_setAssociatedObject(self, PMElasticViewKey, elasticView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
