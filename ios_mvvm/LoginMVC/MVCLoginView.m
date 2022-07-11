//
//  MVCLoginView.m
//  ios_mvvm
//
//  Created by Gao on 2022/7/11.
//

#import "MVCLoginView.h"
#import <Masonry/Masonry.h>

@interface MVCLoginView()

@property (nonatomic, strong) UITextField *nameInput;
@property (nonatomic, strong) UITextField *passwordInput;

@end

@implementation MVCLoginView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.nameInput];
    [self addSubview:self.passwordInput];
    
    [self.nameInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(16);
        make.left.offset(16);
        make.right.offset(-16);
        make.height.mas_equalTo(32);
    }];
    
    [self.passwordInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameInput.mas_bottom).offset(16);
        make.left.offset(16);
        make.right.offset(-16);
        make.height.mas_equalTo(32);
        make.bottom.offset(-16);
    }];
}

# pragma mark - events
- (void)textFieldDidChange:(UITextField *)textField {
    if (textField == self.nameInput) {
        !self.usernameInputBlock ?: self.usernameInputBlock(textField.text);
    } else if (textField == self.passwordInput) {
        !self.passwordInputBlock ?: self.passwordInputBlock(textField.text);
    }
}

# pragma mark - setters & getters

- (UITextField *)nameInput {
    if (!_nameInput) {
        _nameInput = [[UITextField alloc] init];
        _nameInput.keyboardType = UIKeyboardTypeNumberPad;
        _nameInput.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        _nameInput.clearButtonMode = UITextFieldViewModeWhileEditing;
        _nameInput.placeholder = @"请输入账号";
        [_nameInput addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _nameInput;
}

- (UITextField *)passwordInput {
    if (!_passwordInput) {
        _passwordInput = [[UITextField alloc] init];
        _passwordInput.keyboardType = UIKeyboardTypeNumberPad;
        _passwordInput.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        _passwordInput.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordInput.placeholder = @"请输入密码";
        [_passwordInput addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _passwordInput;
}

@end
