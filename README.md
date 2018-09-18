# ZYDownloader

## 目的

基于AFNetworking封装一个下载管理类，支持多任务下载、断点续传、后台下载等功能

## 预期

- 多任务下载
- 可灵活控制同时下载的任务数量
- 下载状态及时更新
- 实时显示下载进度
- 实时计算下载速度
- 后台下载

## 实现方案

基于`AFNetworking 3.0`版本进行封装，`AFNetworking 3.0`版本支持使用`NSURLSession`进行下载功能。

###### 基础下载功能
`AFNetworking 3.0`有一个类`AFURLSessionManager`，这个类是用来创建和管理`NSURLSession`对象的，通过封装`NSURLSession`对象和实现相关的代理回调，我们可以方便的使用`AFURLSessionManager`实现HTTP请求、upload、download等工作。主要使用如下两个方法：

```
/**
 Creates an `NSURLSessionDownloadTask` with the specified request.

 @param request The HTTP request for the request.
 @param downloadProgressBlock A block object to be executed when the download progress is updated. Note this block is called on the session queue, not the main queue.
 @param destination A block object to be executed in order to determine the destination of the downloaded file. This block takes two arguments, the target path & the server response, and returns the desired file URL of the resulting download. The temporary file used during the download will be automatically deleted after being moved to the returned URL.
 @param completionHandler A block to be executed when a task finishes. This block has no return value and takes three arguments: the server response, the path of the downloaded file, and the error describing the network or parsing error that occurred, if any.

 @warning If using a background `NSURLSessionConfiguration` on iOS, these blocks will be lost when the app is terminated. Background sessions may prefer to use `-setDownloadTaskDidFinishDownloadingBlock:` to specify the URL for saving the downloaded file, rather than the destination block of this method.
 */
- (NSURLSessionDownloadTask *)downloadTaskWithRequest:(NSURLRequest *)request
                                             progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgressBlock
                                          destination:(nullable NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                                    completionHandler:(nullable void (^)(NSURLResponse *response, NSURL * _Nullable filePath, NSError * _Nullable error))completionHandler;

/**
 Creates an `NSURLSessionDownloadTask` with the specified resume data.

 @param resumeData The data used to resume downloading.
 @param downloadProgressBlock A block object to be executed when the download progress is updated. Note this block is called on the session queue, not the main queue.
 @param destination A block object to be executed in order to determine the destination of the downloaded file. This block takes two arguments, the target path & the server response, and returns the desired file URL of the resulting download. The temporary file used during the download will be automatically deleted after being moved to the returned URL.
 @param completionHandler A block to be executed when a task finishes. This block has no return value and takes three arguments: the server response, the path of the downloaded file, and the error describing the network or parsing error that occurred, if any.
 */
- (NSURLSessionDownloadTask *)downloadTaskWithResumeData:(NSData *)resumeData
                                                progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgressBlock
                                             destination:(nullable NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                                       completionHandler:(nullable void (^)(NSURLResponse *response, NSURL * _Nullable filePath, NSError * _Nullable error))completionHandler;
```

`downloadTaskWithRequest:`方法主要用于实现根据`request`从头到尾下载文件。

`downloadTaskWithResumeData:`方法主要用于实现断点续传，`resumeData`是上次请求时返回的数据。

这两个方法都提供了`progress:`回调用于实时返回下载进度，`destination:`回调用于在下载完成后指定文件存储的路径，`completionHandler:`回调用于通知下载完成并返回相应的信息。

###### 文件命名规则
`ZYDownloader`存储的文件名是根据`downloadUrl`决定的，通常`downloadUrl`都会指明下载文件的名称和后缀，`ZYDownloader`通过获取`downloadUrl`的`lastPathComponent`来获取下载文件的名称与后缀。文件在下载过程中，遇到暂停、断网、下载失败等情况时需要能保存`resumeData`方便进行后续的断点续传，`ZYDownloader`会将`downloadUrl`的md5值作为名称，拼接上后缀，存储在下载目录下面。

###### 下载速度计算
`NSURLSession`并不会返回下载速度给我们，这就需要我们自己计算，我这里的计算思路是：

- 实现 `setDownloadTaskDidWriteDataBlock:`，这个方法是`AFURLSessionManager`提供的一个block回调，在此回调中会返回给我`bytesWritten`、`totalBytesWritten`等数据信息。
- 每次回调此block时对比与上次回调的时间间距与数据差值
- 拿两次回调的数据差值除以时间间距，获得下载速度
- 对下载速度进行优化处理，根据具体数值选择不同单位

###### 层级结构

## 使用方式

## Todo-List

- 完善回调流程，start任务后能方便的返回相应信息
- 完善下载速度计算流程
- 完成后台下载功能
- 完成多任务下载
- demo显示相关功能
