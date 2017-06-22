//
//  XZMAnimateTabbar.m
//  XZMAnimateTabbarDemo
//
//  Created by Mac_Nelson on 15/12/2.
//  Copyright © 2015年 Mac_Duke. All rights reserved.
//

#import "XZMTabbarExtension.h"
#import "UIView+XZMTabbarExtension.h"
#import <objc/runtime.h>

#define kScreenW [UIScreen mainScreen].bounds.size.width

static NSInteger XZMCustomButtonIndex = -1;
static CGFloat XZMCustomButtonOffsetY = 0.f;
@implementation UITabBar (XZMTabbarExtension)

static NSString *AssociatedButtonKey;

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzledMethodWithOriginalSelector:@selector(initWithFrame:)   swizzledSelector:@selector(swizzled_initWithFrame:)];
        [self swizzledMethodWithOriginalSelector:@selector(layoutSubviews) swizzledSelector:@selector(swizzled_layoutSubviews)];
        });
}

+ (void)swizzledMethodWithOriginalSelector:(SEL)originalSelector
                              swizzledSelector:(SEL)swizzledSelector
{
    Method originalMethod = class_getInstanceMethod([self class], originalSelector);
    
    Method swizzledMethod = class_getInstanceMethod([self class], swizzledSelector);
    
    BOOL didAddMethod = class_addMethod([self class], originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod([self class], swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    }
    else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (instancetype)swizzled_initWithFrame:(CGRect)frame
{
    id instance = [self swizzled_initWithFrame:frame];
    
    UIButton *centerButton = objc_getAssociatedObject(self, &AssociatedButtonKey);
    if (!centerButton) {
        centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        objc_setAssociatedObject(self, &AssociatedButtonKey, centerButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [self addSubview:centerButton];
   
    return instance;
}

- (void)swizzled_layoutSubviews {
    [self swizzled_layoutSubviews];
    
    if (!self.customButton) {
        return;
    }
    
    CGFloat tabBarWidth = self.bounds.size.width;
    CGFloat tabBarHeight = self.bounds.size.height;
    CGFloat tabBarItemWidth = (tabBarWidth - self.customButton.bounds.size.width) / self.items.count;
    
    CGFloat customCenterX = tabBarWidth * 0.5;
    CGFloat customCenterY = tabBarHeight * 0.5 + XZMCustomButtonOffsetY;
    
    self.customButton.center = CGPointMake(customCenterX, customCenterY);
    
    if (XZMCustomButtonIndex >= 0) {
        self.customButton.frame = CGRectMake(XZMCustomButtonIndex * tabBarItemWidth,
                                           CGRectGetMinY(self.customButton.frame),
                                           CGRectGetWidth(self.customButton.frame),
                                           CGRectGetHeight(self.customButton.frame)
                                           );
    } else { // 默认设置为中间
        if (self.items.count % 2 != 0) {
            [NSException raise:@"XZMTabbarExtension" format:@"如果UITabbarController的ChildViewControllers个数是奇数，你必须通过setTabBarIndex:来指定customButton的位置"];
        }
        XZMCustomButtonIndex = self.items.count * 0.5;
    }
    
    NSArray *sortedSubviews = [self sortedSubviews];
    NSArray *tabBarButtonArray = [self tabBarButtonFromTabBarSubviews:sortedSubviews];
    
    [tabBarButtonArray enumerateObjectsUsingBlock:^(UIView * _Nonnull childView, NSUInteger buttonIndex, BOOL * _Nonnull stop) {
        //调整UITabBarItem的位置
        CGFloat childViewX;
        if (buttonIndex >= XZMCustomButtonIndex) {
            childViewX = buttonIndex * tabBarItemWidth + self.customButton.bounds.size.width;
        } else {
            childViewX = buttonIndex * tabBarItemWidth;
        }
        childView.frame = CGRectMake(childViewX,
                                     CGRectGetMinY(childView.frame),
                                     tabBarItemWidth,
                                     CGRectGetHeight(childView.frame)
                                     );
    }];
    
    [self bringSubviewToFront:self.customButton];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.hidden || (self.alpha <= 0.01f) || (self.userInteractionEnabled == NO)) { // 不能响应事件
        return nil;
    }
    
    if (self.clipsToBounds && ![self pointInside:point withEvent:event]) {
        return nil;
    }
    
    if (self.customButton) { // 事件响应是否在customButton上
        CGRect customButtonFrame = self.customButton.frame;
        if (CGRectContainsPoint(customButtonFrame, point)) {
            return self.customButton;
        }
    }
    
    NSArray *tabBarButtonArray = [self tabBarButtonFromTabBarSubviews:self.subviews];
    for (NSUInteger index = 0; index < tabBarButtonArray.count; index++) {
        UIView *selectedTabBarButton = tabBarButtonArray[index];
        CGRect selectedTabBarButtonFrame = selectedTabBarButton.frame;
        BOOL isTabBarButtonFrame = CGRectContainsPoint(selectedTabBarButtonFrame, point);
        if (isTabBarButtonFrame) {
            return selectedTabBarButton;
        }
    }
    
    UIView *result = [super hitTest:point withEvent:event];
    if (result) {
        return result;
    }
    
    // TabBarItems 凸出的部分
    for (UIView *subview in self.subviews.reverseObjectEnumerator) {
        CGPoint subPoint = [subview convertPoint:point fromView:self];
        result = [subview hitTest:subPoint withEvent:event];
        if (result) {
            return result;
        }
    }
    
    return nil;
}

- (void)configTabBarOfCustomButton:(UIButton <XZMCustomButton> *_Nullable(^_Nullable)())configCustomButtonBlock {
    if (configCustomButtonBlock) {
        UIButton <XZMCustomButton> *customButton = configCustomButtonBlock();
        if (!customButton) return;
        
        self.customButton = customButton;
        [self addSubview:self.customButton];
        [self.customButton sizeToFit];
    }
}

- (void)setCustomButton:(UIButton <XZMCustomButton>*)customButton {
    UIButton <XZMCustomButton>*_customButton = objc_getAssociatedObject(self, &AssociatedButtonKey);
    if (_customButton != customButton) {
        [self willChangeValueForKey:@"customButton"];
        objc_setAssociatedObject(self, &AssociatedButtonKey, customButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self didChangeValueForKey:@"customButton"];
    }
}

- (UIButton <XZMCustomButton>*)customButton {
    return objc_getAssociatedObject(self, &AssociatedButtonKey);
}

- (NSArray *)sortedSubviews {
    NSArray *sortedSubviews = [self.subviews sortedArrayUsingComparator:^NSComparisonResult(UIView * formerView, UIView * latterView) {
        CGFloat formerViewX = formerView.frame.origin.x;
        CGFloat latterViewX = latterView.frame.origin.x;
        return  (formerViewX > latterViewX) ? NSOrderedDescending : NSOrderedAscending;
    }];
    return sortedSubviews;
}

- (NSArray *)tabBarButtonFromTabBarSubviews:(NSArray *)tabBarSubviews {
    NSMutableArray *tabBarButtonArray = [NSMutableArray arrayWithCapacity:tabBarSubviews.count - 1];
    [tabBarSubviews enumerateObjectsUsingBlock:^(UIView * _Nonnull subview, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([subview duke_isTabBarButton]) {
            [tabBarButtonArray addObject:subview];
        }
    }];
    return [tabBarButtonArray copy];
}
@end

@implementation UIButton (XZMCustomButton)
- (void)setTabBarIndex:(NSInteger)index {
    if (XZMCustomButtonIndex != index) {
        [self willChangeValueForKey:@"index"];
        XZMCustomButtonIndex = index;
        [self didChangeValueForKey:@"index"];
    }
}

- (void)setCenterOffsetY:(CGFloat)offsetY {
    if (XZMCustomButtonOffsetY != offsetY) {
        [self willChangeValueForKey:@"offsetY"];
        XZMCustomButtonOffsetY = offsetY;
        [self didChangeValueForKey:@"offsetY"];
    }
}
@end

