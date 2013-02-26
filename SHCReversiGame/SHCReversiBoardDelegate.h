//
//  SHCReversiBoardDelegate.h
//  SHCReversiGame
//
//  Created by Zhengzhong Zhao on 2/25/13.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SHCReversiBoardDelegate <NSObject>
// indicates that the game state has changed
- (void) gameStateChanged;

@end
