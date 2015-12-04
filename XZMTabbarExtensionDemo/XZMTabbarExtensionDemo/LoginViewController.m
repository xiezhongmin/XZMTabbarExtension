

//
//  LoginViewController.m
//  XZMTabbarExtensionDemo
//
//  Created by Mac_Nelson on 15/12/4.
//  Copyright © 2015年 Mac_Duke. All rights reserved.
//

#import "LoginViewController.h"
#import "XZMTabBarViewController.h"
#import "XZMTabBarAnimationController.h"
@interface LoginViewController ()<UIActionSheetDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"亲！请选择tabBar工具条的种类" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"动态tabBar工具条",@"个性化中间按钮tabBar工具条",nil];
    
    [sheet showInView:self.view];
}

#pragma mark - <UIActionSheetDelegate>
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self presentViewController:[[XZMTabBarAnimationController alloc] init] animated:YES completion:nil];
            break;
        case 1:
            [self presentViewController:[[XZMTabBarViewController alloc] init] animated:YES completion:nil];
            break;
        default:
            break;
    }
}

@end
