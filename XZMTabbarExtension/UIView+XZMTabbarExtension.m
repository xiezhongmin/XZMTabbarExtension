//
//  UIView+XZMTabbarExtension.m
//  XZMTabbarExtensionDemo
//
//  Created by 谢忠敏 on 2017/6/22.
//  Copyright © 2017年 Mac_Duke. All rights reserved.
//

#import "UIView+XZMTabbarExtension.h"

#define DUKE_UITABBAR_PREFIX (@"UITabBar")
#define DUKE_UITABBAR_IMAGEVIEW_PREFIX (@"IndicatorView")

@implementation UIView (XZMTabbarExtension)

- (BOOL)duke_classStringhasPrefix:(NSString *)subString {
    NSString *classString = NSStringFromClass([self class]);
    return [classString hasPrefix:subString];
}

- (BOOL)duke_isKindOfClass:(Class)class {
    BOOL isKindOfClass = [self isKindOfClass:class];
    BOOL isClass = [self isMemberOfClass:class];
    BOOL isKind = isKindOfClass && !isClass;
    if (!isKind) {
        return NO;
    }
    BOOL isTabBarClass = [self duke_classStringhasPrefix:DUKE_UITABBAR_PREFIX];
    return isTabBarClass;
}

- (BOOL)duke_isTabBarButton {
    BOOL isKindOfButton = [self duke_isKindOfClass:[UIControl class]];
    return isKindOfButton;
}

- (BOOL)duke_isTabBarImageView {
    BOOL isKindOfImageView = [self duke_isKindOfClass:[UIImageView class]];
    if (!isKindOfImageView) {
        return NO;
    }
  
    BOOL isBackgroundImage = [self duke_classStringhasPrefix:DUKE_UITABBAR_IMAGEVIEW_PREFIX];
    BOOL isTabBarImageView = !isBackgroundImage;
    return isTabBarImageView;
}
@end
