//
//  ZYDownloader.m
//  AFNetworking
//
//  Created by luzhiyong on 2018/9/17.
//

#import "ZYDownloader.h"
#import "ZYMultiDelegate.h"

@interface ZYDownloader()

/**
 操作队列 用于管理每个任务的下载任务操作 提供并发处理
 */
@property(nonatomic, strong) NSOperationQueue *operationQueue;

@property(nonatomic, strong) NSMutableArray *privateDownloadingArray;
@property(nonatomic, strong) NSMutableArray *privateDownloadedArray;

@property(nonatomic, assign) NSInteger currentActiveTaskCount;

@property(nonatomic, strong) ZYMultiDelegate *delegate;

@end

@implementation ZYDownloader

#pragma mark - Life Cycle

+ (ZYDownloader *)sharedInstance {
    static dispatch_once_t onceToken;
    static ZYDownloader *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 默认同时只能下载一个任务
        _maxActiveDownloadCount = 1;
        // 当前正在下载任务数为0
        _currentActiveTaskCount = 0;
        // 创建操作队列
        _operationQueue = [[NSOperationQueue alloc] init];
        // 创建数组
        _privateDownloadingArray = [[NSMutableArray alloc] init];
        _privateDownloadedArray = [[NSMutableArray alloc] init];
        // 创建delegate
        _delegate = [[ZYMultiDelegate alloc] init];
    }
    return self;
}

#pragma mark - Public Methods

- (BOOL)addTask:(ZYDownloadTask *)task {
    for (ZYDownloadTask *tmpTask in self.privateDownloadingArray) {
        if ([tmpTask isEqual:task]) {
            return NO;
        }
    }
    
    for (ZYDownloadTask *tmpTask in self.privateDownloadedArray) {
        if ([tmpTask isEqual:task]) {
            return NO;
        }
    }
    
    task.downloadState = ZYDownloadTaskStateWaiting;
    [self.privateDownloadingArray addObject:task];
    
    if (_currentActiveTaskCount < _maxActiveDownloadCount) {
        // 当前并发数小于最大并发数，直接下载
        [self startTask:task];
    }
    
    return YES;
}

- (void)startTask:(ZYDownloadTask *)task {
    [task startWithProgress:^(ZYDownloadTask *task) {
        dispatch_async(dispatch_get_main_queue(), ^{
            for (id delegate in self.delegate.delegates) {
                [delegate downloadTaskProgressDidChangeWithTask:task];
            }
        });
    } completion:^(ZYDownloadTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    }];
}

- (BOOL)pauseTask:(ZYDownloadTask *)task {
    return NO;
}

- (BOOL)resumeTask:(ZYDownloadTask *)task {
    return NO;
}

- (BOOL)pauseAll {
    return NO;
}

/**
 注册多播代理
 
 @param delegate 需要监听下载任务状态变化的对象
 */
- (void)registerDelegate:(id)delegate {
    if (delegate) {
        [self.delegate addDelegate:delegate];
    }
}

/**
 取消代理
 
 @param delegate 需要取消代理的对象
 */
- (void)unregisterDelegate:(id)delegate {
    if (delegate) {
        [self.delegate removeDelegate:delegate];
    }
}

#pragma mark - Private Methods

@end
