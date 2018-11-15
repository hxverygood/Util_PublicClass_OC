/*
 * author 孔凡列
 *
 * gitHub https://github.com/gitkong
 * cocoaChina http://code.cocoachina.com/user/
 * 简书 http://www.jianshu.com/users/fe5700cfb223/latest_articles
 * QQ 279761135
 * 喜欢就给个like 和 star 喔~
 */

#import "FLSocketManager.h"
#import "SRWebSocket.h"
@interface FLSocketManager ()<SRWebSocketDelegate>
@property (nonatomic,strong)SRWebSocket *webSocket;

@property (nonatomic,assign)FLSocketStatus fl_socketStatus;

@property (nonatomic,weak)NSTimer *timer;

@property (nonatomic,copy)NSString *urlString;

@end

@implementation FLSocketManager{
    NSInteger _reconnectCounter;
}


+ (instancetype)shareManager{
    static FLSocketManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        instance.overtime = 1;
        instance.reconnectCount = 5;
    });
    return instance;
}

- (void)fl_open:(NSString *)urlStr connect:(FLSocketDidConnectBlock)connect receive:(FLSocketDidReceiveBlock)receive failure:(FLSocketDidFailBlock)failure{
    [FLSocketManager shareManager].connect = connect;
    [FLSocketManager shareManager].receive = receive;
    [FLSocketManager shareManager].failure = failure;
    [self fl_open:urlStr];
}

- (void)fl_close:(FLSocketDidCloseBlock)close{
    [FLSocketManager shareManager].close = close;
    [self fl_close];
}

// Send a UTF8 String or Data.
- (void)fl_send:(id)data{
    // 如果 websocket状态时打开，
    if (self.webSocket.readyState != SR_OPEN) {
        return;
    }

    switch ([FLSocketManager shareManager].fl_socketStatus) {
        case FLSocketStatusConnected:
        case FLSocketStatusReceived:{
            NSLog(@"ws发送信息...");
            [self.webSocket send:data];
            break;
        }
        case FLSocketStatusFailed:
            NSLog(@"ws发送失败");
            break;
        case FLSocketStatusClosedByServer:
            NSLog(@"WebSocket被服务端关闭 💻");
            break;
        case FLSocketStatusClosedByUser:
            NSLog(@"WebSocket被用户端关闭 📱");
            break;
    }
    
}

#pragma mark -- private method
- (void)fl_open:(id)params{
//    NSLog(@"params = %@",params);
    NSString *urlStr = nil;
    if ([params isKindOfClass:[NSString class]]) {
        urlStr = (NSString *)params;
    }
    else if([params isKindOfClass:[NSTimer class]]){
        NSTimer *timer = (NSTimer *)params;
        urlStr = [timer userInfo];
    }
    [FLSocketManager shareManager].urlString = urlStr;
    [self.webSocket close];
    self.webSocket.delegate = nil;
    
    self.webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    self.webSocket.delegate = self;

    [self.webSocket open];
}

- (void)fl_close{
    
    [self.webSocket close];
    self.webSocket = nil;
    [self.timer invalidate];
    self.timer = nil;
}

- (void)fl_reconnect{
    // 计数+1
    if (_reconnectCounter < self.reconnectCount - 1) {
        _reconnectCounter ++;
        // 开启定时器
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.overtime target:self selector:@selector(fl_open:) userInfo:self.urlString repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        self.timer = timer;
    }
    else{
        NSLog(@"Websocket Reconnected Outnumber ReconnectCount");
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
        return;
    }
    
}

#pragma mark -- SRWebSocketDelegate
- (void)webSocketDidOpen:(SRWebSocket *)webSocket{
    NSLog(@"Websocket Connected");
    
    [FLSocketManager shareManager].connect ? [FLSocketManager shareManager].connect() : nil;
    [FLSocketManager shareManager].fl_socketStatus = FLSocketStatusConnected;
    // 开启成功后重置重连计数器
    _reconnectCounter = 0;
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    NSLog(@":( Websocket Failed With Error %@", error);
    [FLSocketManager shareManager].fl_socketStatus = FLSocketStatusFailed;
    [FLSocketManager shareManager].failure ? [FLSocketManager shareManager].failure(error) : nil;
    // 重连
    [self fl_reconnect];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
//    NSLog(@":( Websocket Receive With message %@", message);
    [FLSocketManager shareManager].fl_socketStatus = FLSocketStatusReceived;
    [FLSocketManager shareManager].receive ? [FLSocketManager shareManager].receive(message,FLSocketReceiveTypeForMessage) : nil;
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    NSLog(@"Closed Reason:%@  code = %zd",reason,code);
    if (reason) {
        [FLSocketManager shareManager].fl_socketStatus = FLSocketStatusClosedByServer;
        // 重连
        [self fl_reconnect];
    }
    else{
        [FLSocketManager shareManager].fl_socketStatus = FLSocketStatusClosedByUser;
    }
    [FLSocketManager shareManager].close ? [FLSocketManager shareManager].close(code,reason,wasClean) : nil;
    self.webSocket = nil;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload{
    [FLSocketManager shareManager].receive ? [FLSocketManager shareManager].receive(pongPayload,FLSocketReceiveTypeForPong) : nil;
}

- (void)dealloc{
    // Close WebSocket
    [self fl_close];
}

@end
