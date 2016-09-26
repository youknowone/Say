//
//  Say.swift
//  Say
//
//  Created by Seungwon Kim on 2016. 9. 24..
//  Copyright © 2016년 youknowone.org. All rights reserved.
//

import Cocoa

class SayAPI: NSObject {
    let speechSynthesizer: NSSpeechSynthesizer?
    var text: String
    var voice: VoiceAPI?
    
    var outputFile: String? = nil
    
    override var description: String {
        get {
            return "<Say: '\(self.text)'>"
        }
    }

    init(text: String, voice: VoiceAPI?) {
        speechSynthesizer = NSSpeechSynthesizer.init()
        self.text = text
        self.voice = voice
        super.init()
    }
    
    public convenience init(text: String) {
        self.init(text: text, voice: nil)
    }
    
    public convenience init?(text: String, voiceIdentifier: String) {
        self.init(text: text, voice: VoiceAPI.init(dictionary: NSSpeechSynthesizer.attributes(forVoice: voiceIdentifier)))
    }

    func play(_ waitUntilDone: Bool) {
        speechSynthesizer?.setVoice(self.voice?.identifier)
        speechSynthesizer?.startSpeaking(text);
    }
    
    func writeToURL(_ URL: Foundation.URL, atomically: Bool) {
        speechSynthesizer?.setVoice(self.voice?.identifier)
        speechSynthesizer?.startSpeaking(text, to: URL)
    }
}
