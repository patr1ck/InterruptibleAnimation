//
//  DraggableView.m
//  InterruptableAnimation
//
//  Created by Patrick B. Gibson on 1/10/13.
//
//

#import "DraggableView.h"
#import <QuartzCore/QuartzCore.h>

#define kInterpolationPoints 100

@interface DraggableView () {
    
    CGFloat _positionX;
    CGFloat _touchDownX;
    CFTimeInterval _startTime;
    CGFloat _releaseLocation;
    CFTimeInterval _duration;
    
    CGPoint _firstControlPoint;
    CGPoint _secondControlPoint;
    
    CGFloat _xValues[kInterpolationPoints];
    CGFloat _yValues[kInterpolationPoints];
    
}

@property (nonatomic, strong) CADisplayLink *displayLink;

@end

@implementation DraggableView

- (void)setup
{
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(display:)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    // We only animate anlong the x-axis to keep this demo simple
    _positionX = self.frame.origin.x;
    _duration = 1.5;
    
    // easeOutExpo - http://easings.net/#easeOutExpo
    // Eventually we'll want to use a custom, higher order curve with a bounce, but this is fine for now.
    _firstControlPoint = CGPointMake(0.19, 1);
    _secondControlPoint = CGPointMake(0.22, 1);
    
    // Pre-calculate out interpolation values
    for (int i = 0; i < kInterpolationPoints; i++) {
        _xValues[i] = [self xCubic:( (CGFloat) (i+1) / kInterpolationPoints)];
        _yValues[i] = [self yCubic:( (CGFloat) (i+1) / kInterpolationPoints)];
    }
}

#pragma mark - Display Updating

- (void)display:(CADisplayLink *)displayLink;
{
    if (_startTime != 0) {
        CFTimeInterval currentTime = CACurrentMediaTime() - _startTime;
        
        // Apply our animation curve
        CGFloat timeProgress = currentTime / _duration;
        CGFloat animationProgress = [self easeOutExpo:timeProgress];
        
        // If we're animating, calculate where we should be given the current progress.
        if (animationProgress <= 1.0) {
            _positionX = _releaseLocation - (_releaseLocation * animationProgress);
        } else {
            _startTime = 0;
            _positionX = 0;
        }
    }
    
    self.frame = CGRectMake(_positionX, self.frame.origin.y, self.bounds.size.width, self.bounds.size.height);
}

- (CGFloat)xCubic:(double)t
{
    return powf((1-t), 3) * 0 +                         // P0
    3 * powf((1-t), 2) * t * _firstControlPoint.x +     // P1
    3 * (1-t) * powf(t, 2) * _secondControlPoint.x +    // P2
    powf(t, 3) * 1;                                     // P3
}

- (CGFloat)yCubic:(double)t
{
    return powf((1-t), 3) * 0 +                         // P0
    3 * powf((1-t), 2) * t * _firstControlPoint.y +     // P1
    3 * (1-t) * powf(t, 2) * _secondControlPoint.y +    // P2
    powf(t, 3) * 1;                                     // P3
}


- (CGFloat)easeOutExpo:(double)x
{
    CGFloat foundX = 0;
    int t = 0;
    
    // Find our nearest t value
    do {
        foundX = _xValues[t];
        t++;
    } while (foundX <= x && t < kInterpolationPoints);
    
    return _yValues[t];
}

#pragma mark - Touch handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Set our initial position
    CGPoint pointDown = [[touches anyObject] locationInView:[self superview]];
    
    if (_startTime != 0) {
        _touchDownX = pointDown.x - _positionX;
    } else {
        _touchDownX = pointDown.x;
    }
    
    _startTime = 0;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    _positionX = 0;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint pointMoveTo = [[touches anyObject] locationInView:[self superview]];
    _positionX = pointMoveTo.x - _touchDownX;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    _releaseLocation = _positionX;
    _startTime = CACurrentMediaTime();
}


- (void)dealloc
{
    [self.displayLink invalidate];
    self.displayLink = nil;
//    self.delegate = nil;
}

@end