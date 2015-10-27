//
//  CardsViewController.h
//  Matchismo Animated
//
//  Created by Justin Gazlay on 10/1/15.
//  Copyright © 2015 Justin Gazlay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"
#import "CardView.h"

@protocol CardsViewControllerDelegate <NSObject>

- (void)tappedCardAtIndex:(NSUInteger)index;
- (void)allCardViewsRemoved;

@end

@interface CardsViewController : UIViewController

- (instancetype)initWithCards:(NSArray *)cards;

-(void)removeAllCardsFromViewAnimated:(BOOL)animated;

-(void)initCardViews;

-(void)updateUIAnimated:(BOOL)animated;

-(void)addCards:(NSArray *)cards;

-(void)removeCard:(Card *)card;

@property (strong, nonatomic) id<CardsViewControllerDelegate> delegate;

//for subclassing

- (void)setCardAtIndex:(NSUInteger)index forCardView:(CardView *)cardView;

-(void)tappedCard:(UITapGestureRecognizer *)sender;

-(void)updateCardsUI;

-(CardView *)newCardViewWithFrame:(CGRect)frame;

@property (strong, nonatomic) NSMutableArray *cards;
@property (strong, nonatomic) NSMutableArray *currentCardViews;


@end
