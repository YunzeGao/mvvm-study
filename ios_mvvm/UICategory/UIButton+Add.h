//
//  UIButton+Add.h
//  ios_mvvm
//
//  Created by Gao on 2022/7/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (Add)

+ (UIButton *)buttonWithName:(NSString *)name target:(id)target action:(SEL)action;

@end

NS_ASSUME_NONNULL_END
