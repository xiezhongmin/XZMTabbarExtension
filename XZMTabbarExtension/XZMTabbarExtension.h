//
//  XZMAnimateTabbar.h
//  XZMAnimateTabbarDemo
//
//  Created by Mac_Nelson on 15/12/2.
//  Copyright © 2015年 Mac_Duke. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XZMCustomButton <NSObject>

/**
 设置自定义按钮在TabBar中的位置，(默认是在中间，不是奇数会错误提示)

 @param index index
 */
- (void)setTabBarIndex:(NSInteger)index;

/**
 设置自定义按钮Y轴在TabBar中的偏移量, 建议在按钮超出了 tabbar 的边界时实现该方法,
 如果不实现该方法，内部会自动进行比对，预设一个较为合适的位置，如果实现了该方法，预设的逻辑将失效
 @param offsetY 偏移量
 */
- (void)setCenterOffsetY:(CGFloat)offsetY;

@end

@interface UITabBar (XZMTabbarExtension)
// 设置个性化中间按钮
- (void)configTabBarOfCustomButton:(UIButton <XZMCustomButton> *_Nullable(^_Nullable)())configCustomButtonBlock;

@end

@interface UIButton (XZMCustomTabBar) <XZMCustomButton>

@end
