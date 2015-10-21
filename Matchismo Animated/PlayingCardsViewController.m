//
//  PlayingCardsViewController.m
//  Matchismo Animated
//
//  Created by Justin Gazlay on 10/20/15.
//  Copyright © 2015 Justin Gazlay. All rights reserved.
//

#import "PlayingCardsViewController.h"
#import "PlayingCard.h"

@interface PlayingCardsViewController ()

@end

@implementation PlayingCardsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setCardAtIndex:(NSUInteger)index forCardView:(CardView *)cardView
{
    Card *card = self.cards[index];
    if ([card isKindOfClass:[PlayingCard class]] && [cardView isKindOfClass:[PlayingCardView class]]) {
        PlayingCard *playingCard = (PlayingCard *)card;
        PlayingCardView *playingCardView = (PlayingCardView *)cardView;
        playingCardView.rank = playingCard.rank;
        playingCardView.suit = playingCard.suit;
    }
}

-(void)updateCardsUI
{
    for (CardView *cardView in self.currentCardViews) {
        if ([cardView isKindOfClass:[PlayingCardView class]]) {
            PlayingCardView *playingCardView = (PlayingCardView *)cardView;
            Card *card = self.cards[[self.currentCardViews indexOfObject:cardView]];
            
            if (playingCardView.faceUp != card.isChosen) {
                [self animateCardFlipForCardView:playingCardView];
            }
        }
        
    }
}

-(void)animateCardFlipForCardView:(PlayingCardView *)cardView
{
    [CATransaction flush];
    [UIView transitionWithView:cardView
                      duration:.6
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        cardView.faceUp = !cardView.faceUp;
                    }
                    completion:nil];
    
}

-(void)tappedCard:(UITapGestureRecognizer *)sender
{
 
    if (sender.state == UIGestureRecognizerStateEnded) {
        if ([sender.view isKindOfClass:[PlayingCardView class]]) {
            PlayingCardView *playingCardView = (PlayingCardView *)sender.view;
            [self animateCardFlipForCardView:playingCardView];
        }
    }
    
    [super tappedCard:sender];
}

-(CardView *)newCardViewWithFrame:(CGRect)frame
{
    return [[PlayingCardView alloc] initWithFrame:frame];
}





@end
