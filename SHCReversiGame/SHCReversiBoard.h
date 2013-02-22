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

@end
