//
//  TextDocument.h
//  Count
//
//  Created by Taylor Trimble on 9/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TextDocument : NSDocument <NSTextViewDelegate> {
    NSAttributedString *text;
    
    IBOutlet NSTextView *textView;
    IBOutlet NSTextField *lineCount;
    IBOutlet NSTextField *wordCount;
    IBOutlet NSTextField *uniqueWordCount;
    IBOutlet NSTextField *characterCount;
}

@property (nonatomic, copy) NSAttributedString *text;
@property (readonly) NSUInteger numberOfLines;
@property (readonly) NSUInteger numberOfWords;
@property (readonly) NSUInteger numberOfUniqueWords;
@property (readonly) NSUInteger numberOfCharacters;

- (IBAction)count:(id)sender;

@end
