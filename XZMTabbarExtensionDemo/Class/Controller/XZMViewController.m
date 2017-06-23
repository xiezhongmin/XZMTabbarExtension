//
//  ViewController.m
//  XZMTabbarExtensionDemo
//
//  Created by Mac_Nelson on 15/12/4.
//  Copyright © 2015年 Mac_Duke. All rights reserved.
//

#import "XZMViewController.h"
#import "XZMTabbarExtension.h"

@interface XZMViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@end

@implementation XZMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLable.text = self.title;
    
    if ([self.title isEqualToString:@"同城"] || [self.title isEqualToString:@"我的"]) {
        [self.navigationController.tabBarItem duke_setBadgePointColor:[UIColor blueColor]];
    }
    
    switch (self.tabBarController.selectedIndex) {
        case 0:
            self.view.backgroundColor = [UIColor redColor];
            break;
        case 1:
            self.view.backgroundColor = [UIColor yellowColor];
            break;
        case 2:
            self.view.backgroundColor = [UIColor orangeColor];
            break;
        case 3:
            self.view.backgroundColor = [UIColor blueColor];
            break;
        default:
            break;
    }
    
}

@end
