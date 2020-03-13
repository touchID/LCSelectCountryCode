//
//  LCWordCodeModel.h
//  LCSelectCountryCode_Example
//
//  Created by lu on 2020/3/13.
//  Copyright © 2020 Swift. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCWordCodeModel : NSObject

@property (nonatomic, copy) NSString *user_Name;
@property (nonatomic, copy) NSString *user_Id;
@property (nonatomic, copy) NSString *user_Image_url;
@property (nonatomic, copy) UIImage  *user_Image;
@property (nonatomic, copy) NSString *user_PhoneNumber;

@end

NS_ASSUME_NONNULL_END
