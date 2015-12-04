//
//  ViewController.m
//  XZMTabbarExtensionDemo
//
//  Created by Mac_Nelson on 15/12/4.
//  Copyright © 2015年 Mac_Duke. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLable.text = self.title;
    
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
