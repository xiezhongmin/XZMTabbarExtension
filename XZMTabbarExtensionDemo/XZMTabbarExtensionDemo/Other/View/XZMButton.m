//
//  XZMButton.m
//  百思不得姐
//
//  Created by 谢忠敏 on 15/7/26.
//  Copyright (c) 2015年 谢忠敏. All rights reserved.
//

#import "XZMButton.h"
#import "UIView+XZMFrame.h"
@implementation XZMButton


- (void)awakeFromNib
{
     [self setUp];
    
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.titleLabel.font = [UIFont systemFontOfSize:14];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.x = 0;
    self.imageView.y = 0;
    self.imageView.width = self.width;
    self.imageView.height = self.imageView.width;
    
    self.titleLabel.x = 0;
    self.titleLabel.y = self.imageView.height;
    self.titleLabel.width = self.width;
    self.titleLabel.height = self.height - self.imageView.height;
}

@end
