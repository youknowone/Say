//
//  ViewController.swift
//  iOS
//
//  Created by Jeong YunWon on 2016. 9. 24..
//  Copyright © 2016년 youknowone.org. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SpeakerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var textview: UITextView!
    var languagePicker: UIPickerView = UIPickerView()
    let speaker = Speaker.defaultSpeaker
    var languageNames = [String]()
    
    @IBAction func playClicked(_ sender: AnyObject) {
        if let text = self.textview.text {
            self.speaker.speakText(text: text)
        }
    }
    @IBAction func changeVoiceClicked(_ sender: AnyObject) {
        // create action sheet dynamically
        let alertController = UIAlertController(title: "Select Launguage", message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: UIAlertControllerStyle.actionSheet);
        self.languagePicker.center.x = self.view.center.x
        let action = UIAlertAction(title: "DONE", style: .default) { (action) in
            let value = self.languagePicker.selectedRow(inComponent: 0)
            self.speaker.changeLanguage(language: self.speaker.voices[value].language)
        }
        alertController.addAction(action)
        alertController.view.addSubview(languagePicker)
        present(alertController, animated: true, completion: nil)
        self.languagePicker.autoresizingMask = [UIViewAutoresizing.flexibleLeftMargin, UIViewAutoresizing.flexibleRightMargin]
    }
    
    func speaker(speaker: Speaker, didFinishSpeechString: String) {
        print("didFinishSpeechString : ", didFinishSpeechString)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create popup picker view
        languagePicker = UIPickerView(frame: CGRect(x: 0, y: 20, width: 300, height: 250))
        languagePicker.delegate = self
        languagePicker.dataSource = self
        languagePicker.showsSelectionIndicator = true
        languagePicker.tintColor = UIColor.red
        languagePicker.reloadAllComponents()
        
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
