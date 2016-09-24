//
//  Speaker.swift
//  BotTalk
//
//  Created by Jeong YunWon on 2016. 7. 7..
//  Copyright © 2016년 youknowone.org. All rights reserved.
//

import Foundation
import AVFoundation

public class Speaker: NSObject, AVSpeechSynthesizerDelegate {
    static let defaultSpeaker = Speaker()
    var volume: Float = 1.0
    var mute = false

    let synthesizer = AVSpeechSynthesizer()

    override init() {
        super.init()
        self.synthesizer.delegate = self
    }

    public func stopSpeaking() {
        self.synthesizer.stopSpeaking(at: .word)
    }

    public func pauseSpeaking() {
        self.synthesizer.pauseSpeaking(at: .immediate)
    }

    public func continueSpeaking() {
        self.synthesizer.continueSpeaking()
    }

    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
//        Core.core.speaker(self, didFinishSpeechString: utterance.speechString)
//        Do what speeching finished
        print("speeching finished")
    }

    public func speakText(text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = 0.4
        utterance.volume = self.mute ? 0.0 : self.volume
        utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR")
        self.synthesizer.speak(utterance)
    }
}


protocol SpeakerDelegate {
    func speaker(speaker: Speaker, didFinishSpeechString: String);
}
