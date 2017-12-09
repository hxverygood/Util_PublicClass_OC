//
//  HSWebViewController.m
//  HSAdvisorAPP
//
//  Created by hoomsun on 2017/3/3.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import "HSWebViewController.h"
#import <WebKit/WebKit.h>
#import "WKWebView+Utils.h"

@interface HSWebViewController () <WKNavigationDelegate>
//@property (weak, nonatomic) IBOutlet WKWebView *webView;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UILabel *waterMarkLabel;
@property (nonatomic, strong) UIImageView *waterMarkImageView;
@end

@implementation HSWebViewController

#pragma mark - Getter

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] init];
        _progressView.frame = CGRectZero;
        //设置进度条的高度，进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
        _progressView.transform = CGAffineTransformMakeScale(1.0, 1.5);
        _progressView.trackTintColor = [UIColor clearColor];
        _progressView.progressTintColor = _progressViewColor;
        [self.view addSubview:self.progressView];
    }
    return _progressView;
}

- (WKWebView *)webView {
    if (!_webView) {
        
        _webView.backgroundColor = [[UIColor alloc] initWithRed:251/255.0 green:251/255.0 blue:251/255.0f alpha:1];
        
        WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
        
//        // 自适应屏幕宽度js
//        NSString *jsString = @" var meta = document.createElement('meta');\
//                                meta.setAttribute('name', 'viewport');\
//                                meta.setAttribute('content', 'width=device-width');\
//                                document.getElementsByTagName('head')[0].appendChild(meta);";
//        
//        WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:jsString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
//        
//        // 添加自适应屏幕宽度js调用的方法
//        [wkWebConfig.userContentController addUserScript:wkUserScript];
        
        _webView = [[WKWebView alloc] initWithFrame:[UIView fullScreenFrame] configuration:wkWebConfig];
        [self.view addSubview:_webView];
    }
    return _webView;
}

- (UILabel *)waterMarkLabel {
    if (!_waterMarkLabel) {
        UILabel *waterMarkLabel = [[UILabel alloc] init];
        waterMarkLabel.frame = CGRectMake(0.0, 0.0, 100.0, 100.0);
        waterMarkLabel.center = self.view.center;
        waterMarkLabel.numberOfLines = 0;
        
        _waterMarkLabel = waterMarkLabel;
    }
    return _waterMarkLabel;
}



#pragma mark - Setter



#pragma mark - UI

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_statusBarStyle) {
        [[UIApplication sharedApplication] setStatusBarStyle:_statusBarStyle animated:YES];
    }
    
//    if (_allowRotation) {
//        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        delegate.allowRotation = YES;
//    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self backBarButtonItemWithImageName:@"button_back"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    if (_allowRotation) {
//        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        delegate.allowRotation = NO;
//    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    if (![NSString isBlankString:self.titleStr]) {
        self.title = self.titleStr;
    }
    
    self.webView.navigationDelegate = self;
    self.webView.allowsBackForwardNavigationGestures = NO;
//    [self.webView reloadFromOrigin];
    
    // 添加“加载进度”的监听
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.progressView.frame = CGRectMake(0.0, 0.0, [[UIScreen mainScreen] bounds].size.width, 2.0);
    self.webView.frame = [UIView fullScreenFrame];
    
    // 加水印
    if (_waterMarkContent.length > 0) {
        if (self.waterMarkImageView) {
            [self.waterMarkImageView removeFromSuperview];
            self.waterMarkImageView = nil;
        }
        BOOL navIsTranlucent = [UINavigationBar appearance].translucent;
//        CGFloat heightDiff = navIsTranlucent ? 0.0 : 64.0;
        
        UIImage *waterMarkImage = [self wateMarkImageInRect:(CGRect){CGPointMake(0.0, navIsTranlucent ? 64.0 : 0.0), CGSizeMake(CGRectGetWidth(self.webView.frame), CGRectGetHeight(self.webView.frame))} waterMarkText:_waterMarkContent];
        self.waterMarkImageView = [[UIImageView alloc] initWithImage:waterMarkImage];
        self.waterMarkImageView.frame = CGRectMake(0.0, navIsTranlucent ? 64.0 : 0.0, CGRectGetWidth(self.webView.frame), CGRectGetHeight(self.webView.frame));
        [self.view insertSubview:self.waterMarkImageView aboveSubview:self.webView];
    }
}

- (BOOL)shouldAutorotate {
    return _allowRotation;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientation {
    return UIInterfaceOrientationMaskLandscape;
}



#pragma mark - WKWebView Delegate

// 开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"开始加载网页");
    [SVProgressHUD showWithStatus:@"正在加载……"];
    //开始加载网页时展示出progressView
    self.progressView.hidden = NO;
    //开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    //防止progressView被网页挡住
    [self.view bringSubviewToFront:self.progressView];
}

// 加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"网页加载完成");
    //加载完成后隐藏progressView
    /*
     *添加一个简单的动画，将progressView的Height变为1.4倍，在开始加载网页的代理中会恢复为1.5倍
     *动画时长0.25s，延时0.3s后开始动画
     *动画结束后将progressView隐藏
     */
    __weak typeof (self)weakSelf = self;
    [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
        weakSelf.progressView.progress = 1.0;
        weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
    } completion:^(BOOL finished) {
        weakSelf.progressView.hidden = YES;
        [SVProgressHUD dismiss];
    }];
    
    // 如果VC的标题为空，并且网页的标题不为空，则把网页标题赋值给VC标题
    if ([NSString isBlankString:self.title] &&
        ![NSString isBlankString:webView.title]) {
        self.navigationItem.title = webView.title;
    }
}

// 加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    //加载失败同样需要隐藏progressView
    self.progressView.progress = 0.0;
    self.progressView.hidden = YES;
    
    NSLog(@"网页加载失败");
    [SVProgressHUD showInfoWithStatus:@"网页加载失败"];
}

// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {

//    decisionHandler(WKNavigationActionPolicyAllow);
    
    // 点击链接
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {
        NSURLRequest *request = navigationAction.request;
        NSString *urlStr = request.URL.absoluteString;
        
        HSWebViewController *vc = [[HSWebViewController alloc] init];
        vc.urlStr = urlStr;
        
//        NSString *tmpURLStr = [urlStr lowercaseString];
//        BOOL isPDFUrl = [tmpURLStr hasSuffix:@"pdf"];
//        if (isPDFUrl) {
//            HSUser *user = [HSLoginInfo savedLoginInfo];
//            vc.waterMarkContent = user.USER_NAME ? : @"红上财富";
//        }
        
        vc.allowRotation = _allowRotation;
        vc.hidesBottomBarWhenPushed = YES;
        if (_progressViewColor) {
            vc.progressViewColor = _progressViewColor;
        }
        [self.navigationController pushViewController:vc animated:YES];
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}



#pragma mark - Func

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        if (self.progressView.progress < 1.0) {
            self.progressView.progress = self.webView.estimatedProgress;
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

/**
 * 加半透明水印
 * @param rect 需要加水印的区域
 * @param waterMarkText 水印文字
 * @returns 加好水印的图片
 */
- (UIImage *)wateMarkImageInRect:(CGRect)rect
                   waterMarkText:(NSString *)waterMarkText {
    
    CGFloat w = 100.0;
    CGFloat h = 40.0;
    
    UIGraphicsBeginImageContext(CGSizeMake(w, h));
    
    UIColor *color = [UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:0.6];
    UIFont *font = [UIFont systemFontOfSize:16.0];
    [waterMarkText drawInRect:CGRectMake(10.0, 0.0, w, h) withAttributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:color}];
    UIImage *tmpImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    

    UIGraphicsBeginImageContext(CGSizeMake(w, h*2));
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformRotate(transform, M_PI/6);
    
    CGContextRef ctx_ = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(ctx_, transform);
    CGContextDrawImage(ctx_, (CGRect){CGPointMake(10.0, 0.0), tmpImage.size}, tmpImage.CGImage);
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();

    
    
    UIGraphicsBeginImageContext(rect.size);
    // 平铺
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextDrawTiledImage(ctx, (CGRect){CGPointZero, CGSizeMake(w, h*2)}, [smallImage CGImage]);
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}



#pragma mark - Dealloc

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView deleteWebCache];
    self.webView.scrollView.delegate = nil;
}



#pragma mark - 内存警告

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
