//
//  UITabBarItem+XZMTabBadgePoint.m
//  XZMTabbarExtensionDemo
//
//  Created by 谢忠敏 on 2017/6/22.
//  Copyright © 2017年 Mac_Duke. All rights reserved.
//

#import "UITabBarItem+XZMTabBadgePoint.h"
#import "UIView+XZMTabbarExtension.h"
@import ObjectiveC.runtime;

#define DUKE_DEFAULT_BADGEPOINT_RADIUS (4.5)
#define DUKE_DEFAULT_BADGEPOINT_COLOR ([UIColor redColor])
#define DUKE_TABBARBUTTON ([self valueForKey:@"view"])

@implementation UITabBarItem (XZMTabBadgePoint)

- (UIView *)duke_badgePointView {
    UIControl *tabBarButton = DUKE_TABBARBUTTON;
    UIView *badgePointView = objc_getAssociatedObject(tabBarButton, _cmd);
    
    if (badgePointView == nil) {
        UIView *defaultBadgePointView = [[UIView alloc] init];
        [defaultBadgePointView setTranslatesAutoresizingMaskIntoConstraints:NO];
        defaultBadgePointView.backgroundColor = DUKE_DEFAULT_BADGEPOINT_COLOR;
        defaultBadgePointView.layer.masksToBounds = YES;
        defaultBadgePointView.hidden = YES;
        objc_setAssociatedObject(tabBarButton, _cmd, defaultBadgePointView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        badgePointView = defaultBadgePointView;
    }
    
    return badgePointView;
}

- (UIImageView *)duke_imageView {
    for (UIView *subview in [DUKE_TABBARBUTTON subviews]) {
        if ([subview duke_isTabBarImageView]) {
            return (UIImageView *)subview;
        }
    }
    return nil;
}

- (void)duke_setShowBadgePoint:(BOOL)showBadgePoint {
    if (showBadgePoint && self.duke_badgePointView.superview == nil) {
        UIControl *tabBarButton = DUKE_TABBARBUTTON;
        [tabBarButton addSubview:self.duke_badgePointView];
        [tabBarButton bringSubviewToFront:self.duke_badgePointView];
        self.duke_badgePointView.layer.zPosition = MAXFLOAT;
        self.duke_badgePointView.layer.cornerRadius = (self.duke_badgePointRadius ?: DUKE_DEFAULT_BADGEPOINT_RADIUS);
        
        // X constraint
        [tabBarButton addConstraint:
         [NSLayoutConstraint constraintWithItem:self.duke_badgePointView
                                      attribute:NSLayoutAttributeCenterX
                                      relatedBy:0
                                         toItem:self.duke_imageView
                                      attribute:NSLayoutAttributeRight
                                     multiplier:1
                                       constant:self.duke_badgePointOffset.horizontal]];
        //Y constraint
        [tabBarButton addConstraint:
         [NSLayoutConstraint constraintWithItem:self.duke_badgePointView
                                      attribute:NSLayoutAttributeCenterY
                                      relatedBy:0
                                         toItem:self.duke_imageView
                                      attribute:NSLayoutAttributeTop
                                     multiplier:1
                                       constant:self.duke_badgePointOffset.vertical]];
        
        // Width constraint
        [tabBarButton addConstraint:[NSLayoutConstraint constraintWithItem:self.duke_badgePointView
                                                                          attribute:NSLayoutAttributeWidth
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:nil
                                                                          attribute: NSLayoutAttributeNotAnAttribute
                                                                         multiplier:1
                                                                           constant:(self.duke_badgePointRadius ?: DUKE_DEFAULT_BADGEPOINT_RADIUS) * 2]];
        // Height constraint
        [tabBarButton addConstraint:[NSLayoutConstraint constraintWithItem:self.duke_badgePointView
                                                                          attribute:NSLayoutAttributeHeight
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:nil
                                                                          attribute: NSLayoutAttributeNotAnAttribute
                                                                         multiplier:1
                                                                  constant:(self.duke_badgePointRadius ?: DUKE_DEFAULT_BADGEPOINT_RADIUS) * 2]];
        [self setValue:tabBarButton forKey:@"view"];
    }
    
    self.duke_badgePointView.hidden = showBadgePoint == NO;
}

- (void)duke_setBadgePointHidden:(BOOL)badgePointHidden {
    self.duke_badgePointView.hidden = badgePointHidden;
    [self duke_setShowBadgePoint:!badgePointHidden];
}

- (BOOL)duke_badgePointHidden {
    return self.duke_badgePointView.hidden;
}

- (void)duke_setBadgePointColor:(UIColor *)badgePointColor {
    self.duke_badgePointView.backgroundColor = badgePointColor;
}

- (UIColor *)duke_badgePointColor {
    return self.duke_badgePointView.backgroundColor;
}

- (void)duke_setBadgePointRadius:(CGFloat)badgePointRadius {
    objc_setAssociatedObject(DUKE_TABBARBUTTON, _cmd, @(badgePointRadius), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.duke_badgePointView removeFromSuperview];
    [self duke_setShowBadgePoint:YES];
}

- (CGFloat)duke_badgePointRadius {
    NSNumber *badgePointRadiusObject = objc_getAssociatedObject(DUKE_TABBARBUTTON, @selector(duke_setBadgePointRadius:));
    CGFloat badgePointRadius = [badgePointRadiusObject floatValue];
    return badgePointRadius;
}

- (void)duke_setBadgePointOffset:(UIOffset)badgePointOffset {
    objc_setAssociatedObject(DUKE_TABBARBUTTON, _cmd, [NSValue valueWithUIOffset:badgePointOffset], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIOffset)duke_badgePointOffset {
    id badgePointOffsetObject = objc_getAssociatedObject(DUKE_TABBARBUTTON, @selector(duke_setBadgePointOffset:));
    UIOffset badgePointOffset = [badgePointOffsetObject UIOffsetValue];
    return badgePointOffset;
}
@end
