//
//  SHCBoardTest.m
//  SHCReversiGame
//
//  Created by Zhengzhong Zhao on 2/21/13.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "SHCBoard.h"

#import "SHCBoardTest.h"

@implementation SHCBoardTest

- (void)test_setCellState_setWithValidCoords_cellStateIsChanged
{
    SHCBoard *board = [[SHCBoard alloc] init];
    [board setCellState:BoardCellStateWhitePiece forColumn:4 andRow:5];
    
    BoardCellState retrievedState = [board cellStateAtColumn:4 andRow:5];
    STAssertEquals(BoardCellStateWhitePiece, retrievedState, @"The cell should have been white!");
}

- (void)test_setCellState_setWithInvalidCoords_exceptionWasThrown
{
    SHCBoard* board = [[SHCBoard alloc] init];
    @try {
        // set the state of a cell at an invalid coordinate
        [board setCellState:BoardCellStateBlackPiece forColumn:10 andRow:5];
        // if an exception was not thrown, this line will be reached
        STFail(@"An exception should have been thrown!");
    }
    @catch (NSException *exception) {
    }
}
@end
