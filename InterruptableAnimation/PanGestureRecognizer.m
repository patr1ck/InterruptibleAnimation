//
//  PanGestureRecognizer.m
//  InterruptableAnimation
//
//  Created by Patrick B. Gibson on 2/1/13.
//
//

#import "PanGestureRecognizer.h"

#define kPanThreshold 75

@interface PanGestureRecognizer () {
    BOOL _drag;
    int _moveX;
    int _moveY;
}
@end

@implementation PanGestureRecognizer

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    if (self.state == UIGestureRecognizerStateFailed)
        return;
    
    CGPoint nowPoint = [[touches anyObject] locationInView:self.view];
    CGPoint prevPoint = [[touches anyObject] previousLocationInView:self.view];
    
    _moveX += prevPoint.x - nowPoint.x;
    _moveY += prevPoint.y - nowPoint.y;
    
    if (!_drag) {
        if (abs(_moveX) > kPanThreshold) {
            if (_direction == PanDirectionVertical) {
                self.state = UIGestureRecognizerStateFailed;
            }else {
                _drag = YES;
            }
        }else if (abs(_moveY) > kPanThreshold) {
            if (_direction == PanDirectionHorizontal) {
                self.state = UIGestureRecognizerStateFailed;
            }else {
                _drag = YES;
            }
        }
    }
}

- (void)reset {
    [super reset];
    _drag = NO;
    _moveX = 0;
    _moveY = 0;
}

@end
