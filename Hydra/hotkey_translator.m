#import <Carbon/Carbon.h>

static NSMutableDictionary *SDRelocatableKeys;

static void SDHotkeyInitialize() {
    // List of key codes we'll need to check against current keyboard layout:
    int relocatableKeyCodes[] = {
        kVK_ANSI_A, kVK_ANSI_B, kVK_ANSI_C, kVK_ANSI_D, kVK_ANSI_E, kVK_ANSI_F,
        kVK_ANSI_G, kVK_ANSI_H, kVK_ANSI_I, kVK_ANSI_J, kVK_ANSI_K, kVK_ANSI_L,
        kVK_ANSI_M, kVK_ANSI_N, kVK_ANSI_O, kVK_ANSI_P, kVK_ANSI_Q, kVK_ANSI_R,
        kVK_ANSI_S, kVK_ANSI_T, kVK_ANSI_U, kVK_ANSI_V, kVK_ANSI_W, kVK_ANSI_X,
        kVK_ANSI_Y, kVK_ANSI_Z, kVK_ANSI_0, kVK_ANSI_1, kVK_ANSI_2, kVK_ANSI_3,
        kVK_ANSI_4, kVK_ANSI_5, kVK_ANSI_6, kVK_ANSI_7, kVK_ANSI_8, kVK_ANSI_9,
        kVK_ANSI_Grave, kVK_ANSI_Equal, kVK_ANSI_Minus, kVK_ANSI_RightBracket,
        kVK_ANSI_LeftBracket, kVK_ANSI_Quote, kVK_ANSI_Semicolon, kVK_ANSI_Backslash,
        kVK_ANSI_Comma, kVK_ANSI_Slash, kVK_ANSI_Period };
    
    SDRelocatableKeys = [[NSMutableDictionary alloc] init];
    
    TISInputSourceRef currentKeyboard = TISCopyCurrentKeyboardInputSource();
    CFDataRef layoutData = TISGetInputSourceProperty(currentKeyboard, kTISPropertyUnicodeKeyLayoutData);
    
    if (layoutData) {
        const UCKeyboardLayout *keyboardLayout = (const UCKeyboardLayout *)CFDataGetBytePtr(layoutData);
        UInt32 keysDown = 0;
        UniChar chars[4];
        UniCharCount realLength;
        
        for (int i = 0 ; i < sizeof(relocatableKeyCodes)/sizeof(relocatableKeyCodes[0]) ; i++) {
            UCKeyTranslate(keyboardLayout,
                           relocatableKeyCodes[i],
                           kUCKeyActionDisplay,
                           0,
                           LMGetKbdType(),
                           kUCKeyTranslateNoDeadKeysBit,
                           &keysDown,
                           sizeof(chars) / sizeof(chars[0]),
                           &realLength,
                           chars);
            
            [SDRelocatableKeys setObject:[NSNumber numberWithInt:relocatableKeyCodes[i]]
                                  forKey:[NSString stringWithCharacters:chars length:1]];
        }
    }
    
    CFRelease(currentKeyboard);
}

UInt32 PHKeyCodeForString(NSString* str) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SDHotkeyInitialize();
    });
    
    str = [str lowercaseString];
    NSNumber *keycode;
    if ((keycode = (NSNumber *)[SDRelocatableKeys objectForKey:str])) {
        return [keycode intValue];
    } else {
        str = [str uppercaseString];
        
        // you should prefer typing these in upper-case in your config file,
        // since they look more unique (and less confusing) that way
        if ([str isEqualToString:@"F1"]) return kVK_F1;
        if ([str isEqualToString:@"F2"]) return kVK_F2;
        if ([str isEqualToString:@"F3"]) return kVK_F3;
        if ([str isEqualToString:@"F4"]) return kVK_F4;
        if ([str isEqualToString:@"F5"]) return kVK_F5;
        if ([str isEqualToString:@"F6"]) return kVK_F6;
        if ([str isEqualToString:@"F7"]) return kVK_F7;
        if ([str isEqualToString:@"F8"]) return kVK_F8;
        if ([str isEqualToString:@"F9"]) return kVK_F9;
        if ([str isEqualToString:@"F10"]) return kVK_F10;
        if ([str isEqualToString:@"F11"]) return kVK_F11;
        if ([str isEqualToString:@"F12"]) return kVK_F12;
        if ([str isEqualToString:@"F13"]) return kVK_F13;
        if ([str isEqualToString:@"F14"]) return kVK_F14;
        if ([str isEqualToString:@"F15"]) return kVK_F15;
        if ([str isEqualToString:@"F16"]) return kVK_F16;
        if ([str isEqualToString:@"F17"]) return kVK_F17;
        if ([str isEqualToString:@"F18"]) return kVK_F18;
        if ([str isEqualToString:@"F19"]) return kVK_F19;
        if ([str isEqualToString:@"F20"]) return kVK_F20;
        
        // you should prefer typing these in lower-case in your config file,
        // since there's no concern for ambiguity/confusion with words, just with chars.
        if ([str isEqualToString:@"PAD."]) return kVK_ANSI_KeypadDecimal;
        if ([str isEqualToString:@"PAD*"]) return kVK_ANSI_KeypadMultiply;
        if ([str isEqualToString:@"PAD+"]) return kVK_ANSI_KeypadPlus;
        if ([str isEqualToString:@"PAD/"]) return kVK_ANSI_KeypadDivide;
        if ([str isEqualToString:@"PAD-"]) return kVK_ANSI_KeypadMinus;
        if ([str isEqualToString:@"PAD="]) return kVK_ANSI_KeypadEquals;
        if ([str isEqualToString:@"PAD0"]) return kVK_ANSI_Keypad0;
        if ([str isEqualToString:@"PAD1"]) return kVK_ANSI_Keypad1;
        if ([str isEqualToString:@"PAD2"]) return kVK_ANSI_Keypad2;
        if ([str isEqualToString:@"PAD3"]) return kVK_ANSI_Keypad3;
        if ([str isEqualToString:@"PAD4"]) return kVK_ANSI_Keypad4;
        if ([str isEqualToString:@"PAD5"]) return kVK_ANSI_Keypad5;
        if ([str isEqualToString:@"PAD6"]) return kVK_ANSI_Keypad6;
        if ([str isEqualToString:@"PAD7"]) return kVK_ANSI_Keypad7;
        if ([str isEqualToString:@"PAD8"]) return kVK_ANSI_Keypad8;
        if ([str isEqualToString:@"PAD9"]) return kVK_ANSI_Keypad9;
        if ([str isEqualToString:@"PAD_CLEAR"]) return kVK_ANSI_KeypadClear;
        if ([str isEqualToString:@"PAD_ENTER"]) return kVK_ANSI_KeypadEnter;
        
        if ([str isEqualToString:@"RETURN"]) return kVK_Return;
        if ([str isEqualToString:@"TAB"]) return kVK_Tab;
        if ([str isEqualToString:@"SPACE"]) return kVK_Space;
        if ([str isEqualToString:@"DELETE"]) return kVK_Delete;
        if ([str isEqualToString:@"ESCAPE"]) return kVK_Escape;
        if ([str isEqualToString:@"HELP"]) return kVK_Help;
        if ([str isEqualToString:@"HOME"]) return kVK_Home;
        if ([str isEqualToString:@"PAGE_UP"]) return kVK_PageUp;
        if ([str isEqualToString:@"FORWARD_DELETE"]) return kVK_ForwardDelete;
        if ([str isEqualToString:@"END"]) return kVK_End;
        if ([str isEqualToString:@"PAGE_DOWN"]) return kVK_PageDown;
        if ([str isEqualToString:@"LEFT"]) return kVK_LeftArrow;
        if ([str isEqualToString:@"RIGHT"]) return kVK_RightArrow;
        if ([str isEqualToString:@"DOWN"]) return kVK_DownArrow;
        if ([str isEqualToString:@"UP"]) return kVK_UpArrow;
    }
    
    return -1;
}
