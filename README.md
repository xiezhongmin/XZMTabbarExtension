# XZMTabbarExtension

tabBar工具条框架 (适应各种APP风格，集成只需几行代码，没有耦合度)

![(logo)](http://7xkt3g.com1.z0.glb.clouddn.com/tabBartabar.gif)

##动态工具条
```objc
/** 创建自定义tabbar */
XZMTabbarExtension *tabBar = [[XZMTabbarExtension alloc] init];
tabBar.backgroundColor = [UIColor whiteColor];
tabBar.frame = self.tabBar.bounds;
/** 传递模型数组 */
tabBar.items = self.itemArray;
[tabBar xzm_setShadeItemBackgroundColor:[UIColor cyanColor]];
/** 设置代理 */
tabBar.delegate = self;
[self.tabBar addSubview:tabBar];

/** 代理方法 */
- (void)xzm_tabBar:(XZMTabbarExtension *)tabBar didSelectItem:(NSInteger)index{
self.selectedIndex = index;
}
```

##个性化中间按钮
- 使用框架的UITabBar扩展方法即可

```objc
/** 配置中间按钮 */
[self.tabBar setUpTabBarCenterButton:^(UIButton *centerButton) {
[centerButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];

[centerButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateSelected];

[centerButton addTarget:self action:@selector(chickCenterButton) forControlEvents:UIControlEventTouchUpInside];
}];


- (void)chickCenterButton
{
NSLog(@"点击了中间按钮");
[self presentViewController:[[XZMPublishViewController alloc] init] animated:NO completion:nil];
}

```
## 特性说明:
###1.集成简单，使用方便，没有耦合度
###2.支持block回调。
###3.喜欢你就Star一下吧，感谢你的支持！