//
//  DraggableView.h
//  InterruptableAnimation
//
//  Created by Patrick B. Gibson on 1/10/13.
//
//

#import <UIKit/UIKit.h>

@interface DraggableView : UIView

@property (nonatomic, assign) BOOL dragsHorizontally;
@property (nonatomic, assign) BOOL dragsVertically;

- (void)setup;

@end
