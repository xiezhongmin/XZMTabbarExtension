
//
//  Created by 谢忠敏 on 15/6/27.
//  Copyright (c) 2015年 谢忠敏. All rights reserved.
//

#import "XZMTabBarAnimationController.h"
#import "XZMTabbarExtension.h"
#import "ViewController.h"


@interface XZMTabBarAnimationController ()<XZMTabbarExtensionDelegate>
/** 模型数组 */
@property (nonatomic, strong)NSMutableArray *itemArray;
@end

@implementation XZMTabBarAnimationController

- (NSMutableArray *)itemArray
{
    if (_itemArray == nil) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /** 添加子控制器 */
    ViewController *hallVC = [[ViewController alloc] init];
    [self tabBarChildViewController:hallVC norImage:[UIImage imageNamed:@"tabBar_0"] selImage:[UIImage imageNamed:@"tabBar_0_on"]];
    
    ViewController *arenaVC = [[ViewController alloc] init];
    [self tabBarChildViewController:arenaVC norImage:[UIImage imageNamed:@"tabBar_1"] selImage:[UIImage imageNamed:@"tabBar_1_on"]];
    
    ViewController *discoverVC = [[ViewController alloc] init];
    [self tabBarChildViewController:discoverVC norImage:[UIImage imageNamed:@"tabBar_2"] selImage:[UIImage imageNamed:@"tabBar_2_on"]];
    
    ViewController *historyVC = [[ViewController alloc] init];
    [self tabBarChildViewController:historyVC norImage:[UIImage imageNamed:@"tabBar_3"] selImage:[UIImage imageNamed:@"tabBar_3_on"]];
    
    /** 自定义tabbar */
    [self setTatBar];
    
  
}

- (void)setTatBar
{
    /** 创建自定义tabbar */
    XZMTabbarExtension *tabBar = [[XZMTabbarExtension alloc] init];
    tabBar.backgroundColor = [UIColor whiteColor];
    tabBar.frame = self.tabBar.bounds;
    /** 传递模型数组 */
    tabBar.items = self.itemArray;
    [tabBar xzm_setShadeItemBackgroundColor:[UIColor cyanColor]];
    /** 设置代理 */
    tabBar.delegate = self;
    
    // 设置中间按钮
//    [tabBar.centerButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
//    [tabBar.centerButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
//    
//    [tabBar.centerButton addTarget:self action:@selector(chickCenterButton) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tabBar addSubview:tabBar];
}

- (void)chickCenterButton
{
    NSLog(@"点击了中间按钮");
}

/** View激将显示时 */
- (void)viewWillAppear:(BOOL)animated
{   [super viewWillAppear:animated];
    for (UIView *childView in self.tabBar.subviews) {
        if (![childView isKindOfClass:[XZMTabbarExtension class]]) {
            [childView removeFromSuperview];
        }
    }
}

- (void)tabBarChildViewController:(UIViewController *)vc norImage:(UIImage *)norImage selImage:(UIImage *)selImage
{
    /** 创建导航控制器 */
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];

    /** 创建模型 */
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] init];
    tabBarItem.image = norImage;
    tabBarItem.selectedImage = selImage;
    /** 添加到模型数组 */
    [self.itemArray addObject:tabBarItem];
    [self addChildViewController:nav];
}

/** 代理方法 */
- (void)xzm_tabBar:(XZMTabbarExtension *)tabBar didSelectItem:(NSInteger)index{
    self.selectedIndex = index;
}

@end
