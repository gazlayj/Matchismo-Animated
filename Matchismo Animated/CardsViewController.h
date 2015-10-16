//
//  CardsViewController.h
//  Matchismo Animated
//
//  Created by Justin Gazlay on 10/1/15.
//  Copyright © 2015 Justin Gazlay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"

@protocol CardsViewControllerDelegate <NSObject>

- (void)tappedCardAtIndex:(NSUInteger)index;
- (void)allCardViewsRemoved;

@end

@interface CardsViewController : UIViewController

- (instancetype)initWithCards:(NSArray *)cards;

- (void)replaceCards:(NSArray *)currentCards withNewCards:(NSArray *)newCards animated:(BOOL)animated;

-(void)removeAllCardsFromViewAnimated:(BOOL)animated;

@property (strong, nonatomic) id<CardsViewControllerDelegate> delegate;


@end
