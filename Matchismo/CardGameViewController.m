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
@property (strong, nonatomic) NSMutableArray *actionsHistory;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultsLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameChooser;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;
@end

@implementation CardGameViewController

- (CardMatchingGame *)game {
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                          usingDeck:[[PlayingCardDeck alloc] init]];
    }
    return _game;
}

- (IBAction)scrollHistory:(UISlider *)sender {
    sender.alpha = (sender.value == sender.maximumValue) ? 1.0 : 0.5;
    self.resultsLabel.text = [self.actionsHistory objectAtIndex:floor(sender.value)];
}

- (NSMutableArray *) actionsHistory
{
    if (!_actionsHistory) _actionsHistory = [[NSMutableArray alloc] init];
    return _actionsHistory;
}

- (void) updateLastHistoryAction {
    [self.actionsHistory addObject:self.game.matchResult];
    self.historySlider.maximumValue = self.actionsHistory.count-1;
    [self.historySlider setValue: self.historySlider.maximumValue animated:YES];
    self.historySlider.alpha = 1.0;
}

- (IBAction)newGame:(id)sender {
    self.game = nil;
    self.historySlider.maximumValue = 0;
    [self.historySlider setValue:0];
    self.historySlider.enabled = NO;
    self.actionsHistory = nil;
    self.flipCount = 0;
    self.game.matchResult = [NSString stringWithFormat:@"%d card game. Pick a card!", self.gameChooser.selectedSegmentIndex+2];
    [self updateLastHistoryAction];
    [self updateUI];
    self.gameChooser.enabled = YES;
    self.game.gameMode = [self.gameChooser selectedSegmentIndex];
}

- (IBAction)gameChanged:(UISegmentedControl *)sender {
    [self newGame:sender];
}


- (void)setCardButtons:(NSArray *)cardButtons{
    _cardButtons = cardButtons;
    [self.actionsHistory addObject:self.game.matchResult];
    [self updateUI];
}

- (void)updateUI {
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setImage:card.isFaceUp ? nil : [UIImage imageNamed:@"cardback.jpg"] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:!card.isFaceUp ? nil : [UIImage
                            imageNamed:@"cardfront.jpg"]
                              forState:UIControlStateSelected];
        [cardButton setBackgroundImage:!card.isFaceUp ? nil : [UIImage
                            imageNamed:@"cardfront.jpg"]
                              forState:UIControlStateSelected|UIControlStateDisabled];
        //[cardButton setImageEdgeInsets:UIEdgeInsetsMake(1, 2, 2, 2)];
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
    if (! self.historySlider.enabled){
        self.historySlider.enabled = YES;
    }
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipCount++;
    [self updateLastHistoryAction];
    [self updateUI];
}

@end
