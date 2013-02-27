//
//  DraggableView.h
//  InterruptableAnimation
//
//  Created by Patrick B. Gibson on 1/10/13.
//
//

#import <UIKit/UIKit.h>

#import "PanGestureRecognizer.h"

@class DraggableView;

@protocol DraggableViewDelegate <NSObject>
@optional
- (void)draggableView:(DraggableView *)draggableView didChangeFrame:(CGRect)frame;
- (CGRect)draggableView:(DraggableView *)draggableView shouldChangeFrame:(CGRect)frame;
- (void)draggableViewFinishedMoving:(DraggableView *)draggableView;
- (void)draggableViewFinishedTouch:(DraggableView *)draggableView;
@end

@interface DraggableView : UIView
@property (nonatomic, weak) id<DraggableViewDelegate> delegate;
@property (nonatomic, assign) PanDirection direction;

// This can be used to have the view 'snap' to a different location.
@property (nonatomic, assign) CGPoint alternateOrigin;

// Starts the CADisplayLink
- (void)setup;

// Animates to a new origin
- (void)moveToNewOrigin:(CGPoint)newOrigin;

// Immediately snaps to a new origin (and can change size)
- (void)setOldFrame:(CGRect)frame;

@end
