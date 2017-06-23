//
//  UITabBarItem+XZMTabBadgePoint.h
//  XZMTabbarExtensionDemo
//
//  Created by 谢忠敏 on 2017/6/22.
//  Copyright © 2017年 Mac_Duke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarItem (XZMTabBadgePoint)
@property (nonatomic, readwrite, copy, nullable, setter=duke_setBadgePointColor:) UIColor *duke_badgePointColor;

@property (nonatomic, readwrite, assign, setter=duke_setBadgePointRadius:) CGFloat duke_badgePointRadius;

@property (nonatomic, readwrite, assign, setter=duke_setBadgePointHidden:) BOOL duke_badgePointHidden;

@property (nonatomic, readwrite, assign, setter=duke_setBadgePointOffset:) UIOffset duke_badgePointOffset;

@end
