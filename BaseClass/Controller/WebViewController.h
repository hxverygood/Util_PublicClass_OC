//
//  WebViewController.h
//  HSAdvisorAPP
//
//  Created by hoomsun on 2017/3/3.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import "BaseViewController.h"
#import <WebKit/WebKit.h>

@protocol WebVCContentProtocol <NSObject>

- (void)wk_userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message;

@end



@interface WebViewController : BaseViewController

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, copy) NSString *urlStr;
@property (nonatomic, copy) NSString *scriptMessageHandlerName;
@property (nonatomic, assign) UIEdgeInsets webViewInsets;
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
@property (nonatomic, copy) NSString *waterMarkContent;

@property (nonatomic, copy) NSString *paramStr;

@property (nonatomic, strong) UIColor *progressViewColor;
@property (nonatomic, assign) BOOL showProgressHUD;
@property (nonatomic, assign) BOOL allowRotation;

// 完成某项工作后是否pop回上一个VC
@property (nonatomic, assign) BOOL needPop;

@property (nonatomic, weak) id<WebVCContentProtocol> delegate;


//- (void)sendJSDataWithUserContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message;

@end
