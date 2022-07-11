//
//  UIButton+Add.m
//  ios_mvvm
//
//  Created by Gao on 2022/7/11.
//

#import "UIButton+Add.h"

@implementation UIButton (Add)

+ (UIButton *)buttonWithName:(NSString *)name target:(id)target action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:name forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:27.f weight:UIFontWeightBold]];
    [btn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

@end
