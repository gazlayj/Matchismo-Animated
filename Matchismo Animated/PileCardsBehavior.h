//
//  PileCardsBehavior.h
//  Matchismo Animated
//
//  Created by Justin Gazlay on 10/25/15.
//  Copyright © 2015 Justin Gazlay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PileCardsBehavior : UIDynamicBehavior

- (void)snapItem:(id <UIDynamicItem>)item toPoint:(CGPoint)point;
- (void)removeAllBehaviors;

@end
