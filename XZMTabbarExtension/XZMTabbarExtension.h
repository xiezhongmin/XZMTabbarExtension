//
//  XZMTabbarExtension.h
//  XZMTabbarExtensionDemo
//
//  Created by duke on 2017/6/23.
//  Copyright © 2017年 Mac_Duke. All rights reserved.
//

///****** 史上最简单的定制tabBar个性化按钮  配置只需要一个方法 github: https://github.com/xiezhongmin/XZMTabbarExtension *******//

#import <Foundation/Foundation.h>

#ifndef _XZMTabbarExtension_
    #define _XZMTabbarExtension_

#if __has_include(<XZMTabbarExtension/XZMTabbarExtension.h>)

    #import <XZMTabbarExtension/UITabBar+XZMTabbarExtension.h>
    #import <XZMTabbarExtension/UITabBarItem+XZMTabBadgePoint.h>

#else

    #import "UITabBar+XZMTabbarExtension.h"
    #import "UITabBarItem+XZMTabBadgePoint.h"

#endif /* __has_include */

#endif /* _XZMTabbarExtension_ */
