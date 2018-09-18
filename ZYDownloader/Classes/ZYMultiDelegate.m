//
//  ZYMultiDelegate.m
//  AFNetworking
//
//  Created by luzhiyong on 2018/9/18.
//

#import "ZYMultiDelegate.h"

@implementation ZYMultiDelegate

- (id)init {
    return [self initWithDelegates:nil];
}

- (id)initWithDelegates:(NSArray *)delegates {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _delegates = [NSPointerArray weakObjectsPointerArray];
    for (id delegate in delegates) {
        [_delegates addPointer:(__bridge void*)delegate];
    }
    
    return self;
}

#pragma mark - Public Methods

- (void)addDelegate:(id)delegate {
    [_delegates addPointer:(__bridge void*)delegate];
}

- (void)removeDelegate:(id)delegate {
    NSUInteger index = [self indexOfDelegate:delegate];
    if (index != NSNotFound) {
        [_delegates removePointerAtIndex:index];
    }
    [_delegates compact];
}

- (void)removeAllDelegates {
    for (NSUInteger i = _delegates.count; i > 0; i--) {
        [_delegates removePointerAtIndex:i - 1];
    }
}

#pragma mark - Private Methods

- (NSUInteger)indexOfDelegate:(id)delegate {
    for (NSUInteger i = 0; i < _delegates.count; i++) {
        if ([_delegates pointerAtIndex:i] == (__bridge void*)delegate) {
            return i;
        }
    }
    return NSNotFound;
}

@end
