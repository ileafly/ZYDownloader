//
//  ZYDownloader.h
//  AFNetworking
//
//  Created by luzhiyong on 2018/9/17.
//
// 下载管理类，负责管理下载任务，包含任务的添加、暂停、继续、删除等。实时通过代理或block将下载状态回调给控制器进行页面状态的更新。

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

#import "ZYDownloadTask.h"

@protocol ZYDownloaderDelegate<NSObject>

@optional

- (void)downloadTaskProgressDidChangeWithTask:(ZYDownloadTask *)task;

@end

@interface ZYDownloader : NSObject

/**
 下载单例

 @return 单例对象
 */
+ (ZYDownloader *)sharedInstance;

/**
 最大下载数
 */
@property(nonatomic, assign) NSInteger maxActiveDownloadCount;

#pragma mark - 相关数组

/**
 正在下载的数组
 */
@property(nonatomic, strong, readonly) NSArray *downloadingArray;

/**
 已下载完成的数组
 */
@property(nonatomic, strong, readonly) NSArray *downloadedArray;

#pragma mark - 下载管理

/**
 添加下载任务

 @param task 下载任务
 @return 是否成功
 */
- (BOOL)addTask:(ZYDownloadTask *)task;

/**
 开始下载任务

 @param task 下载任务
 @return 是否成功
 */
- (void)startTask:(ZYDownloadTask *)task;

/**
 暂停下载任务

 @param task 下载任务
 @return 是否成功
 */
- (BOOL)pauseTask:(ZYDownloadTask *)task;

/**
 继续下载任务

 @param task 下载任务
 @return 是否成功
 */
- (BOOL)resumeTask:(ZYDownloadTask *)task;

/**
 移除下载任务

 @param task 下载任务
 @return 是否成功
 */
- (BOOL)removeTask:(ZYDownloadTask *)task;

/**
 暂停所有下载任务

 @return 是否成功
 */
- (BOOL)pauseAll;

/**
 注册多播代理

 @param delegate 需要监听下载任务状态变化的对象
 */
- (void)registerDelegate:(id)delegate;

/**
 取消代理

 @param delegate 需要取消代理的对象
 */
- (void)unregisterDelegate:(id)delegate;

@end
