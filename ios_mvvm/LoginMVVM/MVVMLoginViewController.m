//
//  MVVMLoginViewController.m
//  ios_mvvm
//
//  Created by Gao on 2022/7/11.
//

#import "MVVMLoginViewController.h"
#import <Masonry/Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "LoginViewModel.h"
#import "MVCLoginView.h"
#import "UIButton+Add.h"

@interface MVVMLoginViewController ()

@property (nonatomic, strong) LoginViewModel *viewModel;
@property (nonatomic, strong) MVCLoginView *loginView;
@property (nonatomic, strong) UIButton *loginButton;

@end

@implementation MVVMLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"MVVM-Controller";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setupUI];
    [self bindViewModel];
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
}

- (void)bindViewModel {
    RAC(self.viewModel.user, username) = self.loginView.nameInput.rac_textSignal;
    RAC(self.viewModel.user, password) = self.loginView.passwordInput.rac_textSignal;
    RAC(self.loginButton, enabled) = self.viewModel.enableLoginSignal;
    [[_loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"vc x = %@", x);
        [self.viewModel.LoginCommand execute:nil];
    }];
}

# pragma mark - getters & setters
- (LoginViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[LoginViewModel alloc] init];
    }
    return _viewModel;
}

- (MVCLoginView *)loginView {
    if (!_loginView) {
        _loginView = [[MVCLoginView alloc] init];
    }
    return _loginView;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithName:@"登录"];
    }
    return _loginButton;
}

@end
