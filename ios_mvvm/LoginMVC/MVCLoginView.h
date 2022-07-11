//
//  MVCLoginView.h
//  ios_mvvm
//
//  Created by Gao on 2022/7/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^inputBlock)(NSString *text);

@interface MVCLoginView : UIView

@property (nonatomic, copy) inputBlock usernameInputBlock;
@property (nonatomic, copy) inputBlock passwordInputBlock;

@end

NS_ASSUME_NONNULL_END
