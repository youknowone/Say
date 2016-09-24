//
//  Say.swift
//  Say
//
//  Created by Seungwon Kim on 2016. 9. 24..
//  Copyright © 2016년 youknowone.org. All rights reserved.
//

import Cocoa

class SayAPI {
    let speechSynthesizer: NSSpeechSynthesizer?
    var text: String?
    var voice: String?
    
    init() {
        speechSynthesizer = NSSpeechSynthesizer.init()
    }
    
    func startSpeaking(text:String) {
        speechSynthesizer?.startSpeaking(text);
    }
}
