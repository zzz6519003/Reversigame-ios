//
//  SHCReversiBoard.m
//  SHCReversiGame
//
//  Created by Zhengzhong Zhao on 2/21/13.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "SHCReversiBoard.h"

@implementation SHCReversiBoard
- (void)setToInitialState
{
    // clear the board
    [super clearBoard];
    
    // add initial play counters
    [super setCellState:BoardCellStateWhitePiece forColumn:3 andRow:3];
    [super setCellState:BoardCellStateBlackPiece forColumn:4 andRow:3];
    [super setCellState:BoardCellStateBlackPiece forColumn:3 andRow:4];
    [super setCellState:BoardCellStateWhitePiece forColumn:4 andRow:4];
    
    _whiteScore = 2;
    _blackScore = 2;
    
    // Black gets the first turn
    _nextMove = BoardCellStateBlackPiece;
    
}

- (BOOL)isValidMoveToColumn:(NSInteger)column andRow:(NSInteger)row {
    // check empty
    if ([super cellStateAtColumn:column andRow:row] != BoardCellStateEmpty) {
        return NO;
    }
    return YES;
}

- (void)makeMoveToColumn:(NSInteger)column andRow:(NSInteger)row {
    // place the playing piece at the given location
    [self setCellState:self.nextMove forColumn:column andRow:row];
    _nextMove = [self invertState];
}

- (BoardCellState)invertState {
    BoardCellState a;
    if (self.nextMove == BoardCellStateWhitePiece) {
        a = BoardCellStateBlackPiece;
    }
    if (self.nextMove == BoardCellStateBlackPiece) {
        a = BoardCellStateWhitePiece;
    }
    return a;
}

@end
