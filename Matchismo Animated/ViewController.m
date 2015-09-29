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
    [self createCardGrid];
}

-(void)createCardGrid
{
    Grid *cardGrid = [[Grid alloc] init];
    cardGrid.size = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    cardGrid.cellAspectRatio = 0.65;
    cardGrid.minimumNumberOfCells = 10;
    
    if (cardGrid.inputsAreValid) {
        for (NSUInteger column = 0; column < cardGrid.columnCount; column++) {
            for (NSUInteger row = 0; row < cardGrid.rowCount; row++) {
                CGRect cardFrame = [cardGrid frameOfCellAtRow:row inColumn:column];
                PlayingCardView *cardView = [[PlayingCardView alloc] initWithFrame:cardFrame];
                
                [self drawRandomPlayingCardForCardView:cardView];
                cardView.faceUp = YES;
                [self.view addSubview:cardView];
                NSLog(@"Card %lu%@ at Column: %lu, Row: %lu created",(unsigned long)cardView.rank, cardView.suit, (unsigned long)column, (unsigned long)row);
            }
        }
    } else {
        NSLog(@"Inputs not Valid");
    }
    
}

@end
