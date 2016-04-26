//
//  ViewController.m
//  JSandOC
//
//  Created by Momo on 16/4/22.
//  Copyright © 2016年 Momo. All rights reserved.
//

#import "ViewController.h"
#import "WebViewJavascriptBridge.h"
@interface ViewController ()<UIWebViewDelegate>

//声明`WebViewJavascriptBridge`对象为属性
@property (nonatomic,strong)  WebViewJavascriptBridge * bridge;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //方法一
    //[self chooseWebViewDelegate];
    
    //方法二
    [self chooseWebViewJavascriptBridge];
    
    
}

// *************************** 方法一  **********************************

/**
    利用webview协议的方法截取网络请求
 */
-(void)chooseWebViewDelegate{
    
    /* 
        1.此时的网址一定要放在服务器上能够请求到的
        2.为了方便大家看代码 已经把initHtml.html放在本地文件（只是为了给你们看代码，此处无用，放在服务器上请求才有用）
        3.http: //127.0.0.1/WEB/initHtml.html 是指向我自己电脑的服务器的文件，
          会服务器基础的同学可以把initHtml.html取出放在服务器根目录进行请求
     */
    UIWebView * webview = [[UIWebView alloc]initWithFrame:self.view.bounds];
    webview.delegate = self;
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://127.0.0.1/WEB/initHtml.html"]]];
    [self.view addSubview:webview];
    
}

#pragma mark ---webview协议方法
#pragma mark ---拦截web网络请求
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSString *url = request.URL.absoluteString;
    NSString *scheme = @"xmg://";
    
    NSLog(@"~~~~~ %@",url);
    if ([url hasPrefix:scheme])
    {
        NSString *actionName = [url substringFromIndex:scheme.length];
        [self performSelector:NSSelectorFromString(actionName) withObject:nil];
        return NO;
    }
    return YES;
}



#pragma mark - 点击FaceBook按钮
-(void)facebookShare{
    NSLog(@"facebookShare");
}

#pragma mark - 点击QQ按钮
-(void)QQShare{
    NSLog(@"QQShare");
}

#pragma mark - 点击微信按钮
-(void)WXShare{
    NSLog(@"WXShare");
}

#pragma mark - 点击信息按钮
-(void)messageShare{
    NSLog(@"messageShare");
}

#pragma mark - 点击邮件按钮
-(void)mailShare{
    
    NSLog(@"1shareMail");
}




// *************************** 方法二  **********************************
-(void)chooseWebViewJavascriptBridge{
    
    // 1.用UIWebView加载web网页
    UIWebView * webview = [[UIWebView alloc]initWithFrame:self.view.bounds];
    webview.delegate = self;
    [self.view addSubview:webview];
    
    // 自定义按钮  （有需要的可以自行打开 写自己需要的方法 比如 给网页发消息或者刷新页面）
    // [self renderButtons:webview];
    
    
    // 注：此处为本地的HTML文件（为了方便说明，所以将文件放在了本地，可自行打开本地看修改的html部分）
    // 加载服务器上的网页同第39行
    [self loadExamplePage:webview];
    
    
    // 2.设置能够进行桥接
    [WebViewJavascriptBridge enableLogging];
    
    
    // 3.指定桥接网页
    _bridge = [WebViewJavascriptBridge bridgeForWebView:webview];

    
    // 4.OC和JS开始交互的部分
    
    // 4.1 点击网页上的Facebook分享按钮
    [_bridge registerHandler:@"facebookObjcCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@" ======FacebookObjcCallback =========  %@", data);
        
        // 1.传话给网页说已经接收到
        responseCallback(@"Response from facebookObjcCallback");
        
        // 2.可以在此执行相应的代码
        [self facebookShare];
        
    }];
    
    // 4.2 点击网页上的QQ分享按钮
    [_bridge registerHandler:@"QQShareObjcCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@" ======QQShareObjcCallback ========= %@", data);
        
        // 1.传话给网页说已经接收到
        responseCallback(@"Response from QQShareObjcCallback");
        
        // 2.可以在此执行相应的代码
        [self QQShare];
        
    }];
    
    // 4.3 点击网页上的微信分享按钮
    [_bridge registerHandler:@"WXShareObjcCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@" ======WXShareObjcCallback =========  %@", data);
        
        // 1.传话给网页说已经接收到
        responseCallback(@"Response from WXShareObjcCallback");
        
        // 2.可以在此执行相应的代码
        [self WXShare];
        
    }];
    
    // 4.4 点击网页上的信息分享按钮
    [_bridge registerHandler:@"MessageShareObjcCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@" ======MessageShareObjcCallback =========  %@", data);
        
        // 1.传话给网页说已经接收到
        responseCallback(@"Response from MessageShareObjcCallback");
        
        // 2.可以在此执行相应的代码
        [self messageShare];
        
    }];
    
    
    // 4.5 点击网页上的邮件分享按钮
    [_bridge registerHandler:@"MailShareObjcCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@" ======MailShareObjcCallback =========  %@", data);
        
        // 1.传话给网页说已经接收到
        responseCallback(@"Response from MailShareObjcCallback");
        
        // 2.可以在此执行相应的代码
        [self mailShare];
        
    }];
    
    
    // 当网页接收到OC的消息时，会处理以下代码（网页的JS实现部分）
    /*
     bridge.registerHandler('testJavascriptHandler', function(data, responseCallback) {
     log('ObjC called testJavascriptHandler with', data)
     var responseData = { 'Javascript Says':'Right back atcha!' }
     log('JS responding with', responseData)
     responseCallback(responseData)
     })
     */
    [_bridge callHandler:@"testJavascriptHandler" data:@{ @"foo":@"before ready" }];
    
    
}


- (void)renderButtons:(UIWebView*)webView {
    UIFont* font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
    
    UIButton *callbackButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [callbackButton setTitle:@"给JS发消息" forState:UIControlStateNormal];
    [callbackButton addTarget:self action:@selector(callHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:callbackButton aboveSubview:webView];
    callbackButton.frame = CGRectMake(10, 400, 100, 35);
    callbackButton.titleLabel.font = font;
    
    UIButton* reloadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [reloadButton setTitle:@"刷新页面" forState:UIControlStateNormal];
    [reloadButton addTarget:webView action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:reloadButton aboveSubview:webView];
    reloadButton.frame = CGRectMake(110, 400, 100, 35);
    reloadButton.titleLabel.font = font;
}

- (void)callHandler:(id)sender {
    
    id data = @{ @"ObjCSayToJS": @"Hi there, JS,I am ObjC!" };
    [_bridge callHandler:@"testJavascriptHandler" data:data responseCallback:^(id response) {
        NSLog(@"JS 回复 ObjC: %@", response);
    }];
    
}

- (void)loadExamplePage:(UIWebView*)webView {
    
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"codetest" ofType:@"html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [webView loadHTMLString:appHtml baseURL:baseURL];
}



@end
