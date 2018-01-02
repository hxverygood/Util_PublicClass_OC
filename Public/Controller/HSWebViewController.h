//
//  HSWebViewController.h
//  HSAdvisorAPP
//
//  Created by hoomsun on 2017/3/3.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import "HSBaseViewController.h"
#import <WebKit/WebKit.h>

@protocol HSWebVCContentProtocol <NSObject>

- (void)wk_userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message;

@end



@interface HSWebViewController : HSBaseViewController

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) NSString *urlStr;
@property (nonatomic, assign) UIEdgeInsets webViewInsets;
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
@property (nonatomic, strong) NSString *waterMarkContent;

@property (nonatomic, strong) UIColor *progressViewColor;
@property (nonatomic, assign) BOOL allowRotation;

// 完成某项工作后是否pop回上一个VC
@property (nonatomic, assign) BOOL needPop;

@property (nonatomic, weak) id<HSWebVCContentProtocol> delegate;


- (void)sendJSDataWithUserContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message;

@end
