//
//  ZYDownloadFileManager.h
//  AFNetworking
//
//  Created by luzhiyong on 2018/9/17.
//

#import <Foundation/Foundation.h>

@interface ZYDownloadFileManager : NSObject

/**
 创建默认下载路径 Documents/downloader
 
 @return 下载路径
 */
+ (NSString *)createDefaultPath;

@end
