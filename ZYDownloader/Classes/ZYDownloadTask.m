//
//  ZYDownloadTask.m
//  AFNetworking
//
//  Created by luzhiyong on 2018/9/17.
//

#import "ZYDownloadTask.h"
#import "ZYDownloadFileManager.h"
#import "NSString+MD5.h"

@implementation ZYDownloadTask

+ (ZYDownloadTask *)downloadTask:(NSURL *)downloadUrl {
    ZYDownloadTask *task = [[ZYDownloadTask alloc] init];
    task.downloadUrl = downloadUrl;
    task.filename = [[downloadUrl absoluteString] lastPathComponent];
    task.fileType = [task.filename pathExtension];
    task.folderPath = [ZYDownloadFileManager createDefaultPath];
    task.downloadState = ZYDownloadTaskStateWaiting;
    return task;
}

#pragma mark - 下载相关

- (void)startWithProgress:(void (^)(ZYDownloadTask *task))progressBlock completion:(void (^)(ZYDownloadTask *task, NSError *error))completionBlock {
    NSString *resumePath = [self resumePath];
    // 是否需要断点续传
    if ([[NSFileManager defaultManager] fileExistsAtPath:resumePath]) {
        // resumePath存在内容，需要进行断点续传
        NSData *resumeData = [NSData dataWithContentsOfFile:resumePath];
        _sessionDownloadTask = [[AFHTTPSessionManager manager] downloadTaskWithResumeData:resumeData progress:^(NSProgress * _Nonnull downloadProgress) {
            self.downloadProgress = downloadProgress;
            progressBlock(self);
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            return [NSURL fileURLWithPath:[self destinationPath]];
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            completionBlock(self, error);
        }];
        [_sessionDownloadTask resume];
    } else {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.downloadUrl cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
        _sessionDownloadTask = [[AFHTTPSessionManager manager] downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
            self.downloadProgress = downloadProgress;
            progressBlock(self);
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            return [NSURL fileURLWithPath:[self destinationPath]];
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            completionBlock(self, error);
        }];
        
        [_sessionDownloadTask resume];
    }
}

#pragma mark - Private Methods

- (NSString *)resumePath {
    // 将下载地址md5作为文件名，download作为文件后缀 共同组合成临时的下载文件名称
    NSString *tempFileName = [[[_downloadUrl absoluteString] md5] stringByAppendingPathExtension:self.fileType];
    return [self.folderPath stringByAppendingPathComponent:tempFileName];
}

- (NSString *)destinationPath {
    return [self.folderPath stringByAppendingPathComponent:self.filename];
}

@end
