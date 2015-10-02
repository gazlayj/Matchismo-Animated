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
#import "CardsViewController.h"
#import "Grid.h"

@interface ViewController ()
@property (strong, nonatomic) Deck *deck;
@property (weak, nonatomic) IBOutlet UIView *cardsContainerView;

@end

@implementation ViewController

static const int NUMBER_OF_CARDS_TO_SHOW = 20;


- (Deck *)deck
{
    if (!_deck) _deck = [[PlayingCardDeck alloc] init];
    return _deck;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidLayoutSubviews
{
    [self displayCardsViewController];
}

- (void)displayCardsViewController
{
    NSMutableArray *cards = [[NSMutableArray alloc] init];
    for (int i = 0; i < NUMBER_OF_CARDS_TO_SHOW; i++) {
        [cards addObject:[self.deck drawRandomCard]];
    }
    CardsViewController *cardsVC = [[CardsViewController alloc] initWithCards:[cards copy]];
    [self displayContentController:cardsVC];
}

- (void) displayContentController:(UIViewController*)content {
    [self addChildViewController:content];
    content.view.frame = self.cardsContainerView.frame;
    [self.view addSubview:content.view];
    [content didMoveToParentViewController:self];
}




@end
