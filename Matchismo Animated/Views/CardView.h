//
//  CardView.h
//  Matchismo Animated
//
//  Created by Justin Gazlay on 10/20/15.
//  Copyright © 2015 Justin Gazlay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardView : UIView

- (void)setCardContents; //for subclassing

- (CGFloat)cornerScaleFactor;
- (CGFloat)cornerRadius;
- (CGFloat)cornerOffset;

@end
