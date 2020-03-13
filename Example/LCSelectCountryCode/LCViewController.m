//
//  LCViewController.m
//  LCSelectCountryCode
//
//  Created by Swift on 03/13/2020.
//  Copyright (c) 2020 Swift. All rights reserved.
//

#import "LCViewController.h"
#import "LCWordCodeViewController.h"

@interface LCViewController ()

@end

@implementation LCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    LCWordCodeViewController *vc = [[LCWordCodeViewController alloc] init];
    //__weak typeof(self) self__ = self;
    vc.successBlock = ^(NSString *wordCode) {
        NSLog(@"PhoneNumber = %@",wordCode);
    };
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:true completion:nil];
}
@end
