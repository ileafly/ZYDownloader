//
//  ZYMultiDelegate.h
//  AFNetworking
//
//  Created by luzhiyong on 2018/9/18.
//

#import <Foundation/Foundation.h>

@interface ZYMultiDelegate : NSObject

/**
 注册的delegate数组
 */
@property(nonatomic, strong, readonly) NSPointerArray *delegates;

- (id)initWithDelegates:(NSArray *)delegates;

- (void)addDelegate:(id)delegate;

- (void)removeDelegate:(id)delegate;
- (void)removeAllDelegates;

@end
