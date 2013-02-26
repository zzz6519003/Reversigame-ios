//
//  SHCReversiBoard.h
//  SHCReversiGame
//
//  Created by Zhengzhong Zhao on 2/21/13.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "SHCBoard.h"

@interface SHCReversiBoard : SHCBoard
// the white player's score
@property (readonly) NSInteger whiteScore;

// the black payer's score
@property (readonly) NSInteger blackScore;

// sets the board to the opening positions for Reversi
- (void)setToInitialState;

// indicates the player who makes the next move
@property (readonly) BoardCellState nextMove;

// Returns whether the player who's turn it is can make the given move
- (BOOL)isValidMoveToColumn:(NSInteger)column andRow:(NSInteger)row;

// Makes the given move for the player who is currently taking their turn
- (void)makeMoveToColumn:(NSInteger)column andRow:(NSInteger)row;

// multicasts game state changes
@property (readonly) SHCMulticastDelegate* reversiBoardDelegate;

@end
