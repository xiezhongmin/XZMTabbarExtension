
//
//  Created by 谢忠敏 on 15/7/22.
//  Copyright (c) 2015年 谢忠敏. All rights reserved.
//

///****** 史上最简单的定制tabBar个性化按钮 只需要一个方法 github: https://github.com/xiezhongmin/XZMTabbarExtension


#import "XZMTabBarViewController.h"
#import "XZMViewController.h"
#import "XZMTabbarExtension.h"
#import "XZMPublishViewController.h"
@interface XZMTabBarViewController () <UITabBarControllerDelegate>

@end

@implementation XZMTabBarViewController

+ (void)initialize
{
    // 通过appearance统一设置所有UITabBarItem的文字属性
    UITabBarItem *tabBarItem = [UITabBarItem appearance];
    
    /** 设置默认状态 */
    NSMutableDictionary *norDict = @{}.mutableCopy;
    norDict[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    norDict[NSForegroundColorAttributeName] = [UIColor grayColor];
    [tabBarItem setTitleTextAttributes:norDict forState:UIControlStateNormal];
    
    /** 设置选中状态 */
    NSMutableDictionary *selDict = @{}.mutableCopy;
    selDict[NSFontAttributeName] = norDict[NSFontAttributeName];
    selDict[NSForegroundColorAttributeName] = [UIColor blackColor];
    [tabBarItem setTitleTextAttributes:selDict forState:UIControlStateSelected];
    
    /** 设置tabar工具条 */
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
    //去除 TabBar 自带的顶部阴影
    [[UITabBar appearance] setShadowImage:[UIImage imageNamed:@"tapbar_top_line"]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*添加子控制器 */
    [self addChildViewController];
    
    /// 史上最简单的定制tabBar个性化按钮 只需要一个方法
    ///
    /// 配置tabBar自定义个性化按钮
    [self.tabBar duke_configTabBarOfCustomButton:^UIButton <XZMCustomButton> * _Nullable{
        UIButton <XZMCustomButton> *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [customButton setBackgroundImage:[UIImage imageNamed:@"hood"] forState:UIControlStateNormal];
        [customButton setBackgroundImage:[UIImage imageNamed:@"hood-selected"] forState:UIControlStateSelected];
        [customButton addTarget:self action:@selector(chickCenterButton) forControlEvents:UIControlEventTouchUpInside];
        [customButton duke_setCenterOffsetY:-13];
        return customButton;
    }];
    
    // 默认选中首页
    [self tabBarController:self didSelectViewController:self.viewControllers.firstObject];
    
    self.delegate = self;
}

- (void)addChildViewController {
    /** 首页 */
    [self setUpChildControllerWith:[[XZMViewController alloc] init] norImage:[UIImage imageNamed:@"home_normal"] selImage:[UIImage imageNamed:@"home_highlight"] title:@"首页"];
    
    /** 同城 */
    [self setUpChildControllerWith:[[XZMViewController alloc] init] norImage:[UIImage imageNamed:@"mycity_normal"] selImage:[UIImage imageNamed:@"mycity_highlight"]title:@"同城"];
    
    /** 消息 */
    [self setUpChildControllerWith:[[XZMViewController alloc] init] norImage:[UIImage imageNamed:@"message_normal"] selImage:[UIImage imageNamed:@"message_highlight"] title:@"消息"];
    
    /** 我的 */
    [self setUpChildControllerWith:[[XZMViewController alloc] init] norImage:[UIImage imageNamed:@"account_normal"] selImage:[UIImage imageNamed:@"account_highlight"] title:@"我的"];
}

- (void)chickCenterButton
{
    NSLog(@"点击了中间按钮");
    [self presentViewController:[[XZMPublishViewController alloc] init] animated:NO completion:nil];
}

- (void)setUpChildControllerWith:(UIViewController *)childVc norImage:(UIImage *)norImage selImage:(UIImage *)selImage title:(NSString *)title
{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childVc];
    
    childVc.title = title;
    
    childVc.tabBarItem.image = norImage;
    childVc.tabBarItem.selectedImage = selImage;
    [self addChildViewController:nav];
}

#pragma make - UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    UITabBarItem *item = [(UINavigationController *)viewController tabBarItem];
    if ([item duke_badgePointHidden]) {
        [item setBadgeValue:nil];
        [item duke_setBadgePointHidden:NO];
    } else {
        [item duke_setBadgePointHidden:YES];
        if ([item.title isEqualToString:@"同城"] || [item.title isEqualToString:@"我的"]) {
            return;
        }
        [item setBadgeValue:@"3"];
    }
}
@end
