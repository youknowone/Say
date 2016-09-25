//
//  Voice.swift
//  Say
//
//  Created by 1002719 on 2016. 9. 25..
//  Copyright © 2016년 youknowone.org. All rights reserved.
//

import Cocoa

class VoiceAPI: NSObject {
    let identifier: String
    let comment: String
    let locale: String
    let name: String
    
    override var description: String {
        get {
            return "<Voice: '\(self.name)'(\(self.locale)), '\(self.comment)'>"
        }
    }
    
    init(dictionary: [String: Any]) {
        self.identifier = dictionary["VoiceIdentifier"] as! String
        self.comment = dictionary["VoiceDemoText"] as! String
        self.locale = dictionary["VoiceLocaleIdentifier"] as! String
        self.name = dictionary["VoiceName"] as! String
    }
    
    static let voices: [VoiceAPI] = {
        var voices: [VoiceAPI] = []
        for voiceIdentifier in NSSpeechSynthesizer.availableVoices() {
            voices.append(VoiceAPI.init(dictionary: NSSpeechSynthesizer.attributes(forVoice: voiceIdentifier)))
        }
        return voices
    }()
}
