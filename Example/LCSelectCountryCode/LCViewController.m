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

@property (nonatomic,strong) UILabel *title_label;


@end

@implementation LCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *title_label = [[UILabel alloc] init];
    _title_label = title_label;
    title_label.font = [UIFont systemFontOfSize:16.0];
//    title_label.textColor = [UIColor whiteColor];
    
    title_label.text = @"点击选择国际手机代号";
    [self.view addSubview:title_label];
    title_label.frame = self.view.frame;
    [title_label sizeToFit];
    title_label.center = self.view.center;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    LCWordCodeViewController *vc = [[LCWordCodeViewController alloc] init];
    __weak typeof(self) self__ = self;
    vc.successBlock = ^(NSString *wordName,NSString *wordCode) {
        NSLog(@"PhoneNumber = %@", wordCode);
        self__.title_label.text = [NSString stringWithFormat:@"%@ %@", wordName, wordCode];
    };
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:true completion:nil];
}
@end
