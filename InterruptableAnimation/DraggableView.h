//
//  DraggableView.h
//  InterruptableAnimation
//
//  Created by Patrick B. Gibson on 1/10/13.
//
//

#import <UIKit/UIKit.h>

@class DraggableView;

@protocol DraggableViewDelegate <NSObject>
- (void)draggableView:(DraggableView *)draggableView didChangeFrame:(CGRect)frame;
@end

@interface DraggableView : UIView
@property (nonatomic, assign) BOOL dragsHorizontally;
@property (nonatomic, assign) BOOL dragsVertically;
@property (nonatomic, weak) id<DraggableViewDelegate> delegate;

- (void)setup;

- (void)translateByX:(CGFloat)newX;
- (void)translateByY:(CGFloat)newY;

@end
