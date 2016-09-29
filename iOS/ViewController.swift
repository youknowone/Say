//
//  ViewController.swift
//  iOS
//
//  Created by Jeong YunWon on 2016. 9. 24..
//  Copyright © 2016년 youknowone.org. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SpeakerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var textView: UITextView! = nil
    @IBOutlet weak var playButton: UIBarButtonItem! = nil
    @IBOutlet weak var rateLabel: UILabel! = nil

    let speaker = Speaker.defaultSpeaker
    var languageNames: [String] = []
    var isSpeaking = false
    var isPaused = false
    
    @IBAction func playClicked(_ sender: AnyObject) {
        if isSpeaking {
            if isPaused {
                speaker.continueSpeaking()
                isPaused = false
                playButton.image = UIImage(named: "Pause.png")
            } else {
                speaker.pauseSpeaking()
                isPaused = true
                playButton.image = UIImage(named: "Play.png")
            }
        } else if let text = self.textView.text {
            speaker.speakText(text: text)
            isSpeaking = true
            playButton.image = UIImage(named: "Pause.png")
        }
    }
    
    @IBAction func stopClicked(_ sender: AnyObject) {
        speaker.stopSpeaking()
        isPaused = false
        isSpeaking = false
        playButton.image = UIImage(named: "Play.png")
    }
    
    func speaker(speaker: Speaker, didFinishSpeechString: String) {
        isSpeaking = false
        isPaused = false
        playButton.image = UIImage(named: "Play.png")
    }
    
    @IBAction func changeVoiceClicked(_ sender: AnyObject) {
        // create action sheet & picker view dynamically
        let alertController = UIAlertController(title: "Select Launguage", message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: UIAlertControllerStyle.actionSheet);
        let alertFrame = alertController.view.frame
        let languagePicker = UIPickerView(frame: CGRect(x: alertFrame.minX, y: alertFrame.minY + 20, width: alertFrame.width - 50, height: 250))
        languagePicker.center.x = self.view.center.x
        languagePicker.autoresizingMask = [UIViewAutoresizing.flexibleLeftMargin, UIViewAutoresizing.flexibleRightMargin]
        languagePicker.delegate = self
        languagePicker.dataSource = self
        languagePicker.showsSelectionIndicator = true
        alertController.view.addSubview(languagePicker)
        
        let action = UIAlertAction(title: "DONE", style: .default) { (action) in
            let value = languagePicker.selectedRow(inComponent: 0)
            self.speaker.changeLanguage(language: self.speaker.voices[value].language)
        }
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func rateChanged(_ sender: UISlider) {
        let value = roundf(100 * sender.value) / 100
        speaker.rate = value
        rateLabel.text = String(value)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        speaker.delegate = self
        
        //init language names
        let voices = self.speaker.voices
        for voice in voices {
            languageNames.append(voice.name)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.speaker.voices.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let name = self.languageNames[row]
        let languageCode = self.speaker.voices[row].language
        return "\(name)(\(languageCode))"
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
