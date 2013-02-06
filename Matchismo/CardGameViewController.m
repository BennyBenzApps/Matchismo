//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Benjamin Lavin on 2013-01-30.
//  Copyright (c) 2013 Benjamin Lavin. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultsLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameChooser;
@end

@implementation CardGameViewController

- (CardMatchingGame *)game {
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                          usingDeck:[[PlayingCardDeck alloc] init]];
    return _game;
}

- (IBAction)newGame:(id)sender {
    self.game = nil;
    self.flipCount = 0;
    self.game.matchResult = [NSString stringWithFormat:@"%d card game. Pick a card!", self.gameChooser.selectedSegmentIndex+2];
    [self updateUI];
    self.gameChooser.enabled = YES;
    self.game.gameMode = [self.gameChooser selectedSegmentIndex];
}

- (IBAction)gameChanged:(UISegmentedControl *)sender {
    self.game.gameMode = sender.selectedSegmentIndex;
    self.game.matchResult = [NSString stringWithFormat:@"%d card game. Pick a card!", sender.selectedSegmentIndex+2];
    [self updateUI];
}


- (void)setCardButtons:(NSArray *)cardButtons{
    _cardButtons = cardButtons;
    [self updateUI];
}

- (void)updateUI {
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setImage:card.isFaceUp ? nil : [UIImage imageNamed:@"playing-card-back.jpg"] forState:UIControlStateNormal];
                [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = (card.isUnplayable ? 0.3 : 1.0);
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.resultsLabel.text = self.game.matchResult;
}

- (void)setFlipCount:(int)flipCount {
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (IBAction)flipCard:(UIButton *)sender {
    if (self.gameChooser.enabled){
        self.gameChooser.enabled = NO;
    }
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipCount++;
    [self updateUI];
}

@end
