//
//  MVCLoginViewController.m
//  ios_mvvm
//
//  Created by Gao on 2022/7/11.
//

#import "MVCLoginViewController.h"
#import "MVCLoginView.h"
#import "LoginModel.h"
#import <Masonry/Masonry.h>
#import <ReactiveObjC/RACEXTScope.h>
#import "UIButton+Add.h"

@interface MVCLoginViewController ()

@property (nonatomic, strong) MVCLoginView *loginView;
@property (nonatomic, strong) LoginModel *model;
@property (nonatomic, strong) UIButton *loginButton;

@end

@implementation MVCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"MVC-Controller";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setupUI];
}

- (void)setupUI {
    [self.view addSubview:self.loginView];
    [self.view addSubview:self.loginButton];
    
    [self.loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(44);
        make.left.right.offset(0);
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(120, 80));
        make.top.mas_equalTo(self.loginView.mas_bottom).offset(24);
        make.centerX.offset(0);
    }];
    
    @weakify(self);
    self.loginView.usernameInputBlock = ^(NSString * _Nonnull text) {
        @strongify(self);
        self.model.username = text;
    };
    
    self.loginView.passwordInputBlock = ^(NSString * _Nonnull text) {
        @strongify(self);
        self.model.password = text;
    };
}

- (void)loginButtongClick {
    NSLog(@"登陆成功!\nusername = %@\npassword = %@", self.model.username, self.model.password);
}

# pragma mark - setters & getters

- (MVCLoginView *)loginView {
    if (!_loginView) {
        _loginView = [[MVCLoginView alloc] init];
    }
    return _loginView;
}

- (LoginModel *)model {
    if (!_model) {
        _model = [[LoginModel alloc] init];
    }
    return _model;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithName:@"登录" target:self action:@selector(loginButtongClick)];
    }
    return _loginButton;
}
@end
