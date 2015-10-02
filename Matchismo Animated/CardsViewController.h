//
//  CardsViewController.h
//  Matchismo Animated
//
//  Created by Justin Gazlay on 10/1/15.
//  Copyright © 2015 Justin Gazlay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"

@interface CardsViewController : UIViewController

- (instancetype)initWithCards:(NSArray *)cards;

- (void)replaceCards:(NSArray *)currentCards withNewCards:(NSArray *)newCards;


@end
