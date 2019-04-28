//
//  CCFPSStatus.m
//  CCFPSStatus
//
//  Created by dengyouhua on 2019/4/28 - now.
//  Copyright © 2019 cc | ccworld1000@gmail.com. All rights reserved.
//  https://github.com/ccworld1000/CCFPSStatus

#import "CCFPSStatus.h"

@interface CCFPSStatusLabel : UILabel

@end

@implementation CCFPSStatusLabel

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    CGPoint location = [touch locationInView:self];
    CGPoint previousLocation =[touch previousLocationInView:self];
    
    CGFloat offsetX = location.x - previousLocation.x;
    CGFloat offsetY = location.y - previousLocation.y;
    
    self.transform = CGAffineTransformTranslate(self.transform, offsetX, offsetY);
}

@end

@interface CCFPSStatus () {
    CADisplayLink *displayLink;
    NSTimeInterval lastTime;
    NSUInteger count;
}

@property (nonatomic,strong) CCFPSStatusLabel *fpsLabel;
@property (nonatomic,copy) void (^fpsHandler)(NSInteger fpsValue);

@end

@implementation CCFPSStatus

- (void)dealloc {
    [displayLink setPaused:YES];
    [displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

+ (CCFPSStatus *)sharedInstance {
    static CCFPSStatus *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [CCFPSStatus new];
    });
    return sharedInstance;
}

- (CCFPSStatusLabel *)fpsLabel {
    if (!_fpsLabel) {
        CGRect frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height / 2.0, 50, 20);
        
        _fpsLabel = [[CCFPSStatusLabel alloc] initWithFrame: frame];
        _fpsLabel.font = [UIFont boldSystemFontOfSize:12];
        _fpsLabel.textColor = [UIColor whiteColor];
        _fpsLabel.backgroundColor = [UIColor purpleColor];
        _fpsLabel.textAlignment = NSTextAlignmentCenter;
        _fpsLabel.userInteractionEnabled = YES;
    }
    
    return _fpsLabel;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(applicationDidBecomeActiveNotification)
                                                     name: UIApplicationDidBecomeActiveNotification
                                                   object: nil];
        
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(applicationWillResignActiveNotification)
                                                     name: UIApplicationWillResignActiveNotification
                                                   object: nil];
        
        // Track FPS using display link
        displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkTick:)];
        [displayLink setPaused:YES];
        [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
    
    return self;
}

- (void)displayLinkTick:(CADisplayLink *)link {
    if (lastTime == 0) {
        lastTime = link.timestamp;
        return;
    }
    
    count++;
    NSTimeInterval interval = link.timestamp - lastTime;
    if (interval < 1) return;
    lastTime = link.timestamp;
    float fps = count / interval;
    count = 0;
    
    NSString *text = [NSString stringWithFormat:@"%d FPS",(int)round(fps)];
    [self.fpsLabel setText: text];
    if (_fpsHandler) {
        _fpsHandler((int)round(fps));
    }
}

- (void)open {
    NSArray *rootVCViewSubViews=[[UIApplication sharedApplication].delegate window].rootViewController.view.subviews;
    for (UIView *label in rootVCViewSubViews) {
        if ([label isKindOfClass:[CCFPSStatusLabel class]]) {
            return;
        }
    }
    
    [displayLink setPaused:NO];
    [[((NSObject <UIApplicationDelegate> *)([UIApplication sharedApplication].delegate)) window].rootViewController.view addSubview:self.fpsLabel];
}

- (void)openWithHandler:(void (^)(NSInteger fpsValue))handler{
    [[CCFPSStatus sharedInstance] open];
    _fpsHandler=handler;
}

- (void)close {
    [displayLink setPaused:YES];
    
    NSArray *rootVCViewSubViews=[[UIApplication sharedApplication].delegate window].rootViewController.view.subviews;
    for (UIView *label in rootVCViewSubViews) {
        if ([label isKindOfClass:[CCFPSStatusLabel class]]) {
            [label removeFromSuperview];
            return;
        }
    }
}

- (void)applicationDidBecomeActiveNotification {
    [displayLink setPaused:NO];
}

- (void)applicationWillResignActiveNotification {
    [displayLink setPaused:YES];
}

@end
