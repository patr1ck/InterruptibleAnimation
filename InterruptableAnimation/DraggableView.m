//
//  DraggableView.m
//  InterruptableAnimation
//
//  Created by Patrick B. Gibson on 1/10/13.
//
//

#import <QuartzCore/QuartzCore.h>

#import "DraggableView.h"
#import "PanGestureRecognizer.h"

#define kInterpolationPoints 100

@interface DraggableView () {
    
    CGPoint _currentPosition;
    CGPoint _touchDownPoint;
    
    CGPoint _currentOrigin;
    CGPoint _originalOrigin;
    
    CFTimeInterval _startTime;
    CGFloat _releaseLocationX;
    CGFloat _releaseLocationY;
    
    // Animation Time
    CFTimeInterval _duration;
    
    // Animation curve
    CGPoint _firstControlPoint;
    CGPoint _secondControlPoint;
    CGFloat _xValues[kInterpolationPoints];
    CGFloat _yValues[kInterpolationPoints];
    
}

@property (nonatomic, weak) CADisplayLink *displayLink;
@property (nonatomic, strong) PanGestureRecognizer *panGesture;

@end

@implementation DraggableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // easeOutExpo - http://easings.net/#easeOutExpo
        // You can swap this out for other points, or ignore them all together and
        // use an entirely different function.
        _firstControlPoint = CGPointMake(0.19, 1);
        _secondControlPoint = CGPointMake(0.22, 1);
        
        // Pre-calculate out interpolation values
        for (int i = 0; i < kInterpolationPoints; i++) {
            _xValues[i] = [self xCubic:( (CGFloat) (i+1) / kInterpolationPoints)];
            _yValues[i] = [self yCubic:( (CGFloat) (i+1) / kInterpolationPoints)];
        }
        
        self.panGesture = [[PanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        self.panGesture.direction = PanDirectionHorizontal;
        self.direction = PanDirectionHorizontal;
        [self addGestureRecognizer:self.panGesture];
        
        _duration = 1.;
    }
    return self;
}

- (void)setDirection:(PanDirection)direction
{
    if (direction != _direction) {
        [self removeGestureRecognizer:self.panGesture];
        self.panGesture = [[PanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        self.panGesture.direction = direction;
        [self addGestureRecognizer:self.panGesture];
        _direction = direction;
    }
}

- (void)setup
{
    _currentPosition.x = self.frame.origin.x;
    _currentOrigin.x = self.frame.origin.x;
    
    _currentPosition.x = self.frame.origin.x;
    _currentOrigin.y = self.frame.origin.y;
    
    _originalOrigin = CGPointMake(_currentOrigin.x, _currentOrigin.y);
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
        if (timeProgress <= 1.0 && animationProgress > 0) {
            _currentPosition.x = _currentOrigin.x + _releaseLocationX - (_releaseLocationX * animationProgress);
            _currentPosition.y = _currentOrigin.y + _releaseLocationY - (_releaseLocationY * animationProgress);
        } else {
            _startTime = 0;
            _currentPosition.x = _currentOrigin.x;
            _currentPosition.y = _currentOrigin.y;
            if (self.delegate && [self.delegate respondsToSelector:@selector(draggableViewFinishedMoving:)]) {
                [self.delegate draggableViewFinishedMoving:self];
            }
            [self.displayLink invalidate];
            self.displayLink = nil;
        }
    }
    
    CGRect newFrame = CGRectZero;
    
    if (self.panGesture.direction == PanDirectionHorizontal) {
        newFrame = CGRectMake(_currentPosition.x, _currentOrigin.y, self.bounds.size.width, self.bounds.size.height);
    } else if (self.panGesture.direction == PanDirectionVertical) {
        newFrame = CGRectMake(_currentOrigin.x, _currentPosition.y, self.bounds.size.width, self.bounds.size.height);
    }
    
    CGRect altFrame = CGRectNull;
    if (self.delegate && [self.delegate respondsToSelector:@selector(draggableView:shouldChangeFrame:)]) {
        altFrame = [self.delegate draggableView:self shouldChangeFrame:newFrame];
    }
    
    if (CGRectIsNull(altFrame)) {
        altFrame = newFrame;
    }
    
    self.frame = altFrame;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(draggableView:didChangeFrame:)]) {
        [self.delegate draggableView:self didChangeFrame:self.frame];
    }
    
}

#pragma mark - Touch handling

- (void)pan:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint pointDown = [gestureRecognizer translationInView:[self superview]];
    
    if([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(display:)];
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        
        _releaseLocationX = 0;
        _releaseLocationY = 0;
        
        if (_startTime != 0) {
            _touchDownPoint.x = _currentOrigin.x + pointDown.x - _currentPosition.x;
            _touchDownPoint.y = _currentOrigin.y + pointDown.y - _currentPosition.y;
        } else {
            _touchDownPoint.x = pointDown.x;
            _touchDownPoint.y = pointDown.y;
        }
        
        _startTime = 0;
    } else if ([gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        _currentPosition.x = _currentOrigin.x + pointDown.x - _touchDownPoint.x;
        _currentPosition.y = _currentOrigin.y + pointDown.y - _touchDownPoint.y;
        
    } else if ([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
        
        if (self.direction == PanDirectionHorizontal) {
            if (_currentPosition.x > _alternateOrigin.x/2) {
                _currentOrigin.x = _alternateOrigin.x;
            } else {
                _currentOrigin.x = _originalOrigin.x;
            }
        } else {
            if (_currentPosition.y > _alternateOrigin.y/2) {
                _currentOrigin.y = _alternateOrigin.y;
            } else {
                _currentOrigin.y = _originalOrigin.y;
            }
        }

        
        _releaseLocationX = _currentPosition.x - _currentOrigin.x;
        _releaseLocationY = _currentPosition.y - _currentOrigin.y;
        _startTime = CACurrentMediaTime();
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(draggableViewFinishedTouch:)]) {
            [self.delegate draggableViewFinishedTouch:self];
        }
    }
}

- (void)moveToNewOrigin:(CGPoint)newOrigin
{
    _releaseLocationX = (_currentOrigin.x - newOrigin.x);
    _currentOrigin.x = newOrigin.x;
    _releaseLocationY = (_currentOrigin.y - newOrigin.y);
    _currentOrigin.y = newOrigin.y;
    _startTime = CACurrentMediaTime();
}

- (void)setOldFrame:(CGRect)frame
{
    _currentOrigin.x = frame.origin.x;
    _currentOrigin.y = frame.origin.y;
    [super setFrame:frame];
    
}

#pragma mark - Helpers

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
    } while (foundX <= x && t <= kInterpolationPoints);
    
    if (t == kInterpolationPoints) {
        // Couldn't the nearest value, return 1.0.
        return 1.0;
    }
    
    return _yValues[t];
}


#pragma mark - Cleanup

- (void)dealloc
{
    [self.displayLink invalidate];
    self.displayLink = nil;
    self.delegate = nil;
}


@end
