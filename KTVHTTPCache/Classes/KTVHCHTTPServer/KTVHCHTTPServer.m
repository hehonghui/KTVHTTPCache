//
//  KTVHCHTTPServer.m
//  KTVHTTPCache
//
//  Created by Single on 2017/8/10.
//  Copyright © 2017年 Single. All rights reserved.
//

#import "KTVHCHTTPServer.h"
#import "KTVHCHTTPConnection.h"
#import "KTVHCHTTPHeader.h"
#import "KTVHCURLTool.h"
#import "KTVHCLog.h"

@interface KTVHCHTTPServer ()

@property (nonatomic, strong) HTTPServer *server;
@property (nonatomic) UIBackgroundTaskIdentifier backgroundTask;
@property (nonatomic) BOOL wantsRunning;

@end

@implementation KTVHCHTTPServer

+ (instancetype)server
{
    static KTVHCHTTPServer *obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[self alloc] init];
    });
    return obj;
}

- (instancetype)init
{
    if (self = [super init]) {
        KTVHCLogAlloc(self);
        self.backgroundTask = UIBackgroundTaskInvalid;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidEnterBackground)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationWillEnterForeground)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(HTTPConnectionDidDie)
                                                     name:HTTPConnectionDidDieNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc
{
    KTVHCLogDealloc(self);
    [self stopInternal];
}

- (BOOL)running
{
    return self.server.isRunning;
}

- (void)start:(NSError **)error
{
    self.wantsRunning = YES;
    [self startInternal:error];
}

- (void)stop
{
    self.wantsRunning = NO;
    [self stopInternal];
}

- (NSURL *)URLWithOriginalURL:(NSURL *)URL
{
    if (!URL || URL.isFileURL || URL.absoluteString.length == 0) {
        return URL;
    }
    NSString *original = [[KTVHCURLTool tool] URLEncode:URL.absoluteString];
    NSString *server = [NSString stringWithFormat:@"http://localhost:%d/", self.server.listeningPort];
    NSString *extension = URL.pathExtension ? [NSString stringWithFormat:@".%@", URL.pathExtension] : @"";
    NSString *URLString = [NSString stringWithFormat:@"%@request%@?url=%@", server, extension, original];
    URL = [NSURL URLWithString:URLString];
    KTVHCLogHTTPServer(@"%p, Return URL\nURL : %@", self, URL);
    return URL;
}

#pragma mark - Internal

- (void)startInternal:(NSError **)error
{
    self.server = [[HTTPServer alloc] init];
    [self.server setConnectionClass:[KTVHCHTTPConnection class]];
    [self.server setType:@"_http._tcp."];
    [self.server setPort:80];
    if ([self.server start:error]) {
        KTVHCLogHTTPServer(@"%p, Start server success", self);
    } else {
        KTVHCLogHTTPServer(@"%p, Start server failed", self);
    }
}

- (void)stopInternal
{
    [self.server stop];
    self.server = nil;
}

#pragma mark - Background Task

- (void)applicationDidEnterBackground
{
    if (self.server.numberOfHTTPConnections > 0) {
        [self beginBackgroundTask];
    } else {
        [self stopInternal];
    }
}

- (void)applicationWillEnterForeground
{
    if (self.backgroundTask == UIBackgroundTaskInvalid && self.wantsRunning) {
        [self startInternal:nil];
    }
    [self endBackgroundTask];
}

- (void)HTTPConnectionDidDie
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground &&
            self.server.numberOfHTTPConnections == 0) {
            [self endBackgroundTask];
            [self stopInternal];
        }
    });
}

- (void)beginBackgroundTask
{
    self.backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [self endBackgroundTask];
        [self stopInternal];
    }];
}

- (void)endBackgroundTask
{
    if (self.backgroundTask != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
        self.backgroundTask = UIBackgroundTaskInvalid;
    }
}

@end
