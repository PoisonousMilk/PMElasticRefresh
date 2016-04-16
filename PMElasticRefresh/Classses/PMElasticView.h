//
//  PMElasticView.h
//  PMElasticRefresh
//
//  Created by Andy on 16/4/13.
//  Copyright © 2016年 AYJk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMElasticView : UIView
- (instancetype)initWithBindingScrollView:(UIScrollView *)bindingScrollView;

- (void)endRefresh;

@end
