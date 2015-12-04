//
//  XZMAnimateTabbar.m
//  XZMAnimateTabbarDemo
//
//  Created by Mac_Nelson on 15/12/2.
//  Copyright © 2015年 Mac_Duke. All rights reserved.
//

#import "XZMTabbarExtension.h"
#import <objc/runtime.h>

#define kScreenW [UIScreen mainScreen].bounds.size.width

#define btnW (kScreenW/self.items.count)

static CGFloat const btnH = 49;
@interface XZMTabbarExtension ()
@property (nonatomic,strong) UIImageView  *btnImgView;
@property (nonatomic,weak) UIButton *seletBtn;
@property (nonatomic,weak) UIButton *shadeItem;
@end

@implementation XZMTabbarExtension

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
       
        // 设置高亮背景
        UIButton *shadeItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [shadeItem setBackgroundImage:[UIImage imageNamed:@"toolBar_shade"] forState:UIControlStateNormal];
        [shadeItem setBackgroundImage:[UIImage imageNamed:@"toolBar_shade"] forState:UIControlStateSelected];
        [self addSubview:shadeItem];
        _shadeItem = shadeItem;
        
        // 设置个性化中间按钮
        UIButton *centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:centerButton];
        _centerButton = centerButton;
      
    }
    return self;
}

- (void)setItems:(NSArray<UITabBarItem *> *)items
{
    _items = items;

    /** 添加item */
    [items enumerateObjectsUsingBlock:^(UITabBarItem * _Nonnull tabBarItem, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton *item = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _btnImgView = [[UIImageView alloc] initWithImage:tabBarItem.image highlightedImage:tabBarItem.selectedImage];

        item.tag = idx;
        
        _btnImgView.center = CGPointMake(btnW/2, btnH/2);
    
        [item addSubview:_btnImgView];
        
        [item addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:item];
        
    }];

}

- (void)xzm_setShadeItemBackgroundImage:(UIImage *)backgroundImage
{
    [_shadeItem setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    [_shadeItem setBackgroundImage:backgroundImage forState:UIControlStateSelected];
}

- (void)xzm_setShadeItemBackgroundColor:(UIColor *)coloer
{
    [_shadeItem setBackgroundColor:coloer];
    [_shadeItem setBackgroundImage:nil forState:UIControlStateNormal];
    [_shadeItem setBackgroundImage:nil forState:UIControlStateSelected];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    /** 布局按钮 */
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    _shadeItem.frame = CGRectMake(0, 0, btnW, btnH);

    if (_centerButton.currentImage || _centerButton.currentBackgroundImage) {
        
        // 设置尺寸
        CGRect frame = _centerButton.frame;
        frame.size = _centerButton.currentBackgroundImage.size;
        _centerButton.frame = frame;
        
        CGFloat width = self.frame.size.width;
        CGFloat height = self.frame.size.height;
        
        _centerButton.center = CGPointMake(width * 0.5, height * 0.5);
        
        NSInteger index = 0;
        for (UIControl *button in self.subviews) {
            if (![button isKindOfClass:[UIControl class]] || button == _centerButton || button == _shadeItem) continue;
            
            // 计算按钮的x值
            btnX = btnW * ((index > 1)?(index + 1):index);
            button.frame = CGRectMake(btnX, btnY, btnW, btnH);
            
            // 增加索引
            index++;
        }
        
    }else {
        for (int i = 2; i < self.subviews.count; i++) {
            UIButton *btn = self.subviews[i];
            btnX = (i - 2) * btnW;
            btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        }
    }
    
   
   
}

- (void)buttonClickAction:(UIButton *)btn{
    
    if (btn == self.seletBtn) return;
    
    ((UIImageView *)self.seletBtn.subviews[0]).highlighted = NO;
    
    ((UIImageView *)btn.subviews[0]).highlighted = YES;
    
    self.seletBtn = btn;
   
    if (!_cancelAnimation) {
        _shadeItem.hidden = NO;
        [self moveShadeBtn:btn];
        [self imgAnimate:btn];
    }else {
        _shadeItem.hidden = YES;
    }
    
    ((UIImageView *)btn.subviews[0]).highlighted = YES;

    if ([self.delegate respondsToSelector:@selector(xzm_tabBar:didSelectItem:)]) {
        
        [self.delegate xzm_tabBar:self didSelectItem:btn.tag];
    }
}


- (void)setCancelAnimation:(BOOL)cancelAnimation
{
    _cancelAnimation = cancelAnimation;
    
    _shadeItem.hidden = !cancelAnimation;
}


- (void)moveShadeBtn:(UIButton*)btn{
    
    [UIView animateWithDuration:0.3 animations:
     ^(void){
         
         CGRect frame = _shadeItem.frame;
         frame.origin.x = btn.frame.origin.x;
         _shadeItem.frame = frame;
         
     } completion:^(BOOL finished){//do other thing
     }];
    
}

- (void)imgAnimate:(UIButton*)btn{
    
    UIView *view=btn.subviews[0];
    
    [UIView animateWithDuration:0.1 animations:
     ^(void){
         
         view.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.5, 0.5);
         
     } completion:^(BOOL finished){//do other thing
         [UIView animateWithDuration:0.2 animations:
          ^(void){
              
              view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.2, 1.2);
              
          } completion:^(BOOL finished){//do other thing
              [UIView animateWithDuration:0.1 animations:
               ^(void){
                   
                   view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1,1);
                   
               } completion:^(BOOL finished){//do other thing
               }];
          }];
     }];
    
    
}
@end


@implementation UITabBar (XZMTabbarExtension)

static NSString *AssociatedButtonKey;

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originalMethod = class_getInstanceMethod([self class], @selector(layoutSubviews));
        Method swizzledMethod = class_getInstanceMethod([self class], @selector(swizzled_layoutSubviews));
        method_exchangeImplementations(originalMethod, swizzledMethod);
    });
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UIButton  *centerButton = objc_getAssociatedObject(self, &AssociatedButtonKey);
        
        if (!centerButton) {
            centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
            objc_setAssociatedObject(self, &AssociatedButtonKey, centerButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    
        [self addSubview:centerButton];
    }
    
    return self;
}

- (void)swizzled_layoutSubviews
{
    [self swizzled_layoutSubviews];

    [self setValue:[NSValue valueWithCGRect:self.bounds] forKeyPath:@"_backgroundView.frame"];
    
    UIButton  *centerButton = objc_getAssociatedObject(self, &AssociatedButtonKey);
    
    centerButton.bounds = CGRectMake(0, 0, centerButton.currentBackgroundImage.size.width, centerButton.currentBackgroundImage.size.height);
    CGFloat buttonW = self.frame.size.width / (self.items.count + 1);
    CGFloat buttonH = self.frame.size.height;
    CGFloat buttonY = 0;
    CGFloat buttonX = 0;
    int index = 0;
    
    centerButton.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    for (UIView *chidView in self.subviews) {
        if ([chidView isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            buttonX = index *buttonW;
            index++;
            if (index == 2) {
                index++;
            }
            chidView.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        }
    }
}

- (void)setUpTabBarCenterButton:(void ( ^ _Nullable )(UIButton * _Nullable centerButton ))centerButtonBlock
{
    centerButtonBlock(objc_getAssociatedObject(self, &AssociatedButtonKey));
}

@end

