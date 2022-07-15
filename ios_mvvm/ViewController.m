//
//  ViewController.m
//  ios_mvvm
//
//  Created by Gao on 2022/7/11.
//

#import "ViewController.h"
#import <Masonry/Masonry.h>
#import "MVCLoginViewController.h"
#import "MVVMLoginViewController.h"
#import "UIButton+Add.h"
#import "NetworkRequest.h"
#import "GGReachability/GGReachability.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton *mvcBtn;
@property (nonatomic, strong) UIButton *mvvmBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"测试";
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
//    [GGReachability startWithDefaultDomain:@"www.baidu.com"];
#if TARGET_OS_SIMULATOR
    NSLog(@"nb");
#else
    NSLog(@"nnb");
#endif
}

- (void)setupUI {
    [self.view addSubview:self.mvcBtn];
    [self.view addSubview:self.mvvmBtn];
    
    [self.mvcBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(120, 80));
        make.right.mas_equalTo(self.view.mas_centerX).offset(-30);
        make.centerY.offset(0);
    }];
    [self.mvvmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(120, 80));
        make.left.mas_equalTo(self.view.mas_centerX).offset(30);
        make.centerY.offset(0);
    }];
}

# pragma mark - private methods
- (void)pushToMVC {
    [self.navigationController pushViewController:[MVCLoginViewController new] animated:YES];
}

- (void)pushToMVVM {
    [self.navigationController pushViewController:[MVVMLoginViewController new] animated:YES];
}

- (void)testDemo {
    NetworkRequest *req = [[NetworkRequest alloc] init];
    req.GET(@"baidu", @{}).set_modelClass([NetworkBaseResponse class]);
    req.success(^(NetworkBaseResponse *res){
        NSLog(@"requestID = %@", res.requestID);
    }).fail(^(NSError *error, NSString *msg) {
        NSLog(@"mas = %@", msg);
    }).commitAsync();
}

# pragma mark - getters & setters

- (UIButton *)mvcBtn {
    if (!_mvcBtn) {
        _mvcBtn = [UIButton buttonWithName:@"mvc" target:self  action:@selector(testDemo)];
    }
    return _mvcBtn;
}

- (UIButton *)mvvmBtn {
    if (!_mvvmBtn) {
        _mvvmBtn = [UIButton buttonWithName:@"mvvm" target:self action:@selector(testDemo)];
    }
    return _mvvmBtn;
}


@end
