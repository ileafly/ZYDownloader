//
//  ZYDownloadTask.h
//  AFNetworking
//
//  Created by luzhiyong on 2018/9/17.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>


/*
@enum 下载状态
 */
typedef NS_ENUM(NSUInteger, ZYDownloadTaskState)
{
    ZYDownloadTaskStateWaiting, // 未开始下载状态
    ZYDownloadTaskStateDownloading, // 正在下载状态
    ZYDownloadTaskStatePaused, // 暂停下载状态
    ZYDownloadTaskStateFailed, // 下载失败
};

@interface ZYDownloadTask : NSObject

/**
 创建一个下载任务

 @param downloadUrl 下载地址
 @return 下载任务
 */
+ (ZYDownloadTask *)downloadTask:(NSURL *)downloadUrl;

/**
 创建一个下载任务

 @param downloadUrl 下载地址
 @param targetPath 存储路径
 @return 下载任务
 */
+ (ZYDownloadTask *)downloadTask:(NSURL *)downloadUrl targetPath:(NSString *)targetPath;


/**
 当前下载资源url
 */
@property(nonatomic, strong) NSURL *downloadUrl;

/**
 文件名称
 */
@property(nonatomic, strong) NSString *filename;

/**
 文件类型
 */
@property(nonatomic, strong) NSString *fileType;

/**
 下载目录文件夹
 */
@property(nonatomic, strong) NSString *folderPath;

#pragma mark - 状态属性

/**
 下载状态
 */
@property(nonatomic, assign) ZYDownloadTaskState downloadState;

/**
 下载进度
 */
@property(nonatomic, strong) NSProgress *downloadProgress;

/**
 下载速度
 */
@property(nonatomic, assign) CGFloat downloadSpeed;

#pragma mark - 下载相关

/**
 session下载
 */
@property(nonatomic, strong) NSURLSessionDownloadTask *sessionDownloadTask;


/**
 开启下载

 @param progressBlock 下载进度block回调
 @param completionBlock 下载完成block回调
 */
- (void)startWithProgress:(void (^)(ZYDownloadTask *task))progressBlock completion:(void (^)(ZYDownloadTask *task, NSError *error))completionBlock;

@end
