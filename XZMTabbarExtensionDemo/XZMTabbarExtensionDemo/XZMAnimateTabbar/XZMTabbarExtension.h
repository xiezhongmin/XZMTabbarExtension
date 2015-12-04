//
//  XZMAnimateTabbar.h
//  XZMAnimateTabbarDemo
//
//  Created by Mac_Nelson on 15/12/2.
//  Copyright © 2015年 Mac_Duke. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XZMTabbarExtension;
@protocol XZMTabbarExtensionDelegate <NSObject>
@optional

/**
 *  tabar代理回调方法
 *
 *  @param tabBar tabBar
 *  @param index  index
 */
- (void)xzm_tabBar:(XZMTabbarExtension *  _Nonnull)tabBar didSelectItem:(NSInteger)index; // called when a new view is selected by the user (but not programatically)

@end

@interface XZMTabbarExtension : UIView

@property(nullable,nonatomic,assign) id<XZMTabbarExtensionDelegate> delegate;     // weak reference. default is nil

@property(nullable,nonatomic,copy) NSArray<UITabBarItem *> *items;        // get/set visible UITabBarItems. default is nil. changes not animated. shown in order

// 设置个性化中间按钮
@property (nonatomic,weak) UIButton *centerButton;

// 取消动画
@property (nonatomic,assign) BOOL cancelAnimation;;

/**
 *  设置高亮背景图片
 *
 *  @param backgroundImage 高亮背景图片
 */
- (void)xzm_setShadeItemBackgroundImage:(UIImage * _Nonnull)backgroundImage;

/**
 *  设置高亮背景颜色
 *
 *  @param coloer 高亮背景颜色
 */
- (void)xzm_setShadeItemBackgroundColor:(UIColor * _Nonnull)coloer;

@end


// ———————————————————— 如果图片与文字分开请使用类扩展 ——————————————————————

@interface UITabBar (XZMTabbarExtension)

// 设置个性化中间按钮
- (void)setUpTabBarCenterButton:(void ( ^ _Nullable )(UIButton * _Nullable centerButton ))centerButtonBlock;

@end


