//
//  PanGestureRecognizer.h
//  InterruptableAnimation
//
//  Created by Patrick B. Gibson on 2/1/13.
//
//

#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>

typedef enum {
    PanDirectionVertical,
    PanDirectionHorizontal
} PanDirection;

@interface PanGestureRecognizer : UIPanGestureRecognizer

@property (nonatomic, assign) PanDirection direction;

@end
