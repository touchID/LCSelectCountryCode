//
//  LCWordCodeViewController.h
//  LCSelectCountryCode_Example
//
//  Created by lu on 2020/3/13.
//  Copyright © 2020 Swift. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCWordCodeViewController : UIViewController

@property (nonatomic, copy) void(^successBlock)(NSString *wordName,NSString *wordCode);

@end

