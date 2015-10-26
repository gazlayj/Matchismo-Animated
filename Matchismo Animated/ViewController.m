//
//  ViewController.m
//  Matchismo Animated
//
//  Created by Justin Gazlay on 9/23/15.
//  Copyright © 2015 Justin Gazlay. All rights reserved.
//

#import "ViewController.h"
#import "CardsViewController.h"
#import "PlayingCardsViewController.h"
#import "CardMatchingGame.h"
#import "PlayingCardDeck.h"
#import "Card.h"

@interface ViewController () <CardsViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *cardsContainerView;
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) NSMutableArray *cardsInPlay;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@end

@implementation ViewController

-(Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

-(NSUInteger)numberOfCardsForGameStart
{
    return 30;
}

-(NSMutableArray *)cardsInPlay
{
    if (!_cardsInPlay) [self resetCardsInPlay];
        
    return _cardsInPlay;
}

-(CardMatchingGame *)game
{
    if (!_game) {
        [self newGame];
    }
    return _game;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self newGame];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        CardsViewController *cardsVC = [self getCardsViewController];
        if (cardsVC) {
            [cardsVC.view setFrame:self.cardsContainerView.frame];
            [cardsVC updateUIAnimated:NO];
        }
    }
                                 completion:nil];
}

- (void)viewDidLayoutSubviews
{
    [self displayPlayingCardsViewController];
}

- (void)displayCardsViewController
{
    CardsViewController *vc = [self getCardsViewController];
    if (!vc) {
        CardsViewController *cardsVC = [[CardsViewController alloc] initWithCards:self.cardsInPlay];
        cardsVC.delegate = self;
        [self addChildViewController:cardsVC];
        [cardsVC.view setFrame:self.cardsContainerView.frame];
        [self.view addSubview:cardsVC.view];
        [cardsVC didMoveToParentViewController:self];
        [cardsVC initCardViews];
    }
}

- (void)displayPlayingCardsViewController
{
    CardsViewController *vc = [self getCardsViewController];
    if (!vc) {
        PlayingCardsViewController *cardsVC = [[PlayingCardsViewController alloc] initWithCards:self.cardsInPlay];
        cardsVC.delegate = self;
        [self addChildViewController:cardsVC];
        [cardsVC.view setFrame:self.cardsContainerView.frame];
        [self.view addSubview:cardsVC.view];
        [cardsVC didMoveToParentViewController:self];
        [cardsVC initCardViews];
    }
}

- (void)hideContentController: (UIViewController*) content {
    [content willMoveToParentViewController:nil];
    [content.view removeFromSuperview];
    [content removeFromParentViewController];
}


-(void)tappedCardAtIndex:(NSUInteger)index
{
    [self.game choosecardAtIndex:index];
    [self updateScoreLabel];
}

- (CardsViewController *)getCardsViewController
{
    for (UIViewController *controller in self.childViewControllers) {
        if ([controller isKindOfClass:[CardsViewController class]]) {
            return (CardsViewController *)controller;
        }
    }
    return nil;
}

- (void)newGame
{
    Deck *deck = [self createDeck];
    self.game = [[CardMatchingGame alloc] initWithCardCount:self.numberOfCardsForGameStart
                                                  usingDeck:deck];
    [self resetCardsInPlay];
    [self updateScoreLabel];
}

-(void)allCardViewsRemoved
{
    [self hideContentController:[self getCardsViewController]];
    [self displayPlayingCardsViewController];
}

-(void)resetCardsInPlay
{
    self.cardsInPlay = [NSMutableArray new];
    
    for (int i = 0; i < self.game.cardsInPlayCount; i++) {
        Card *card = [self.game cardAtIndex:i];
        if (card) {
            [self.cardsInPlay addObject:card];
        }
    }
}


-(void)updateScoreLabel
{
    self.scoreLabel.text = [NSString stringWithFormat:@"SCORE: %ld", (long)[self.game score]];
}

- (IBAction)newGameButtonPressed:(UIButton *)sender {
    [self newGame];
    CardsViewController *cardsVC = [self getCardsViewController];
    [cardsVC removeAllCardsFromViewAnimated:YES];
}


@end
