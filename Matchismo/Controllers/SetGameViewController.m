//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Benjamin Lavin on 2013-02-28.
//  Copyright (c) 2013 Benjamin Lavin. All rights reserved.
//

#import "SetGameViewController.h"
#import "CardMatchingGame.h"
#import "SetCardDeck.h"
#import "SetCard.h"
#import "GameResult.h"

@interface SetGameViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;

@end

@implementation SetGameViewController


- (CardMatchingGame *)game {
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                  usingDeck:[[SetCardDeck alloc] init]];
    }
    return _game;
}

- (void)setCardButtons:(NSArray *)cardButtons{
    _cardButtons = cardButtons;
    [self updateUI];
}

- (void)updateUI {
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        //[cardButton setImage:card.isFaceUp ? nil : [UIImage imageNamed:@"cardback.jpg"] forState:UIControlStateNormal];
        //[cardButton setBackgroundImage:!card.isFaceUp ? nil : [UIImage
                                                               //imageNamed:@"cardfront.jpg"]
                           //   forState:UIControlStateSelected];
        //[cardButton setBackgroundImage:!card.isFaceUp ? nil : [UIImage
                                                               //imageNamed:@"cardfront.jpg"]
                           //   forState:UIControlStateSelected|UIControlStateDisabled];
        //[cardButton setImageEdgeInsets:UIEdgeInsetsMake(1, 2, 2, 2)];
       //NSMutableAttributedString *myString = [[NSMutableAttributedString alloc] initWithString:card.contents attributes:@{NSForegroundColorAttributeName : [card color]}];
        [cardButton setAttributedTitle:[self getAttributedStringContentsForCard:(SetCard *)card] forState:UIControlStateNormal];
        //[cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = (card.isUnplayable ? 0.3 : 1.0);
    }
}

- (NSAttributedString *)getAttributedStringContentsForCard:(SetCard *)card{
   // NSString *shading = @"";
    UIColor *color = [[UIColor alloc] init];
    NSNumber *width = @1;
    
    if ([card.color isEqualToString:@"red"]) {
        color = [UIColor redColor];
    }
    else if ([card.color isEqualToString:@"green"]) {
        color = [UIColor greenColor];
    }
    else if ([card.color isEqualToString:@"purple"]) {
        color = [UIColor purpleColor];
    }
    UIColor *strokeColor = color;
    if ([card.shading isEqualToString:@"solid"]){
        width = (NSNumber *)@-5;
    }
    else if ([card.shading isEqualToString:@"striped"]){
        color = [color colorWithAlphaComponent:0.2];
        width = (NSNumber *)@-5;
    }
    else if ([card.shading isEqualToString:@"open"]){
        width = (NSNumber *)@5;
    }
    NSAttributedString *contents = [[NSAttributedString alloc] initWithString:card.contents attributes:@{NSForegroundColorAttributeName:color,NSStrokeWidthAttributeName:width,NSStrokeColorAttributeName:strokeColor}];
    return contents;
    
}

@end
