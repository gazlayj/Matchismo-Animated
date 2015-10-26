//
//  PileCardsBehavior.m
//  Matchismo Animated
//
//  Created by Justin Gazlay on 10/25/15.
//  Copyright © 2015 Justin Gazlay. All rights reserved.
//

#import "PileCardsBehavior.h"

@interface PileCardsBehavior()

@end

@implementation PileCardsBehavior



-(instancetype)init
{
    self = [super init];
    
    return self;
}

-(void)snapItem:(id<UIDynamicItem>)item toPoint:(CGPoint)point
{
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:item snapToPoint:point];
    [self addChildBehavior:snap];
}

-(void)removeAllBehaviors
{
    for (UIDynamicBehavior *behavior in self.childBehaviors) {
        [self removeChildBehavior:behavior];
    }
}

@end
