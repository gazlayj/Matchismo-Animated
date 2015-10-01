//
//  ViewController.m
//  Matchismo Animated
//
//  Created by Justin Gazlay on 9/23/15.
//  Copyright © 2015 Justin Gazlay. All rights reserved.
//

#import "ViewController.h"
#import "PlayingCardView.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "Grid.h"

@interface ViewController ()
@property (strong, nonatomic) Deck *deck;
@end

@implementation ViewController

- (Grid *)cardGrid
{
    if (!_cardGrid) {
        [self createCardGrid];
    }
    return _cardGrid;
}

- (Deck *)deck
{
    if (!_deck) _deck = [[PlayingCardDeck alloc] init];
    return _deck;
}

- (void)drawRandomPlayingCardForCardView:(PlayingCardView *)cardView
{
    Card *card = [self.deck drawRandomCard];
    if ([card isKindOfClass:[PlayingCard class]]) {
        PlayingCard *playingCard = (PlayingCard *)card;
        cardView.rank = playingCard.rank;
        cardView.suit = playingCard.suit;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self populateCardGrid];
}

-(void)createCardGrid
{
    self.cardGrid = [[Grid alloc] init];
    self.cardGrid.size = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    self.cardGrid.cellAspectRatio = 0.65;
    self.cardGrid.minimumNumberOfCells = 10;
}

- (void)populateCardGrid
{
        if (self.cardGrid.inputsAreValid) {
        for (NSUInteger column = 0; column < self.cardGrid.columnCount; column++) {
            for (NSUInteger row = 0; row < self.cardGrid.rowCount; row++) {
                CGRect cardFrame = [self.cardGrid frameOfCellAtRow:row inColumn:column];
                [self addCardViewWithFrame:cardFrame];
            }
        }
    } else {
        NSLog(@"Grid not created! inputs invalid");
    }
}

- (void)addCardViewWithFrame:(CGRect)cardViewFrame
{
    PlayingCardView *cardView = [[PlayingCardView alloc] initWithFrame:cardViewFrame];
                
    [self drawRandomPlayingCardForCardView:cardView];
    cardView.faceUp = YES;
    [self.view addSubview:cardView];
}

@end
