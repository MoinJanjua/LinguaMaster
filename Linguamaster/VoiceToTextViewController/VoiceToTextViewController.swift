//
//  VoiceToTextViewController.swift
//  Linguamaster
//
//  Created by Developer UCF on 31/07/2024.
//

import UIKit
import Speech
import AVKit

class VoiceToTextViewController: UIViewController,UITextViewDelegate, UITextFieldDelegate ,UIGestureRecognizerDelegate ,AVSpeechSynthesizerDelegate{
    
    
    @IBOutlet weak var Micbtn: UIButton!
    @IBOutlet weak var Titlelbl: UILabel!
    @IBOutlet weak var TranslateTolbl: UILabel!
    @IBOutlet weak var Tolbl: UILabel!
    @IBOutlet weak var FromTV: UITextView!
    @IBOutlet weak var ToTV: UITextView!
    @IBOutlet weak var ToCountryTF: DropDown!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var ToCountryCode = String()
    let placeholderText = "Enter text to translate..."
   //let placeholderTextto = "Enter text to translate..."
    let speechRecognizer        = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    var recognitionRequest      : SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask         : SFSpeechRecognitionTask?
    let audioEngine             = AVAudioEngine()
    var speechSynthesizer = AVSpeechSynthesizer()
    
    let countries: [Country] = [
        Country(name: "United States", flag: "🇺🇸", code: "en"),
        Country(name: "Spain", flag: "🇪🇸", code: "es"),
        Country(name: "France", flag: "🇫🇷", code: "fr"),
        Country(name: "Germany", flag: "🇩🇪", code: "de"),
        Country(name: "Italy", flag: "🇮🇹", code: "it"),
        Country(name: "Japan", flag: "🇯🇵", code: "ja"),
        Country(name: "China", flag: "🇨🇳", code: "zh"),
        Country(name: "Russia", flag: "🇷🇺", code: "ru"),
        Country(name: "India", flag: "🇮🇳", code: "hi"),
        Country(name: "Brazil", flag: "🇧🇷", code: "pt"),
        Country(name: "Canada", flag: "🇨🇦", code: "en"),
        Country(name: "Mexico", flag: "🇲🇽", code: "es"),
        Country(name: "South Korea", flag: "🇰🇷", code: "ko"),
        Country(name: "Turkey", flag: "🇹🇷", code: "tr"),
        Country(name: "Saudi Arabia", flag: "🇸🇦", code: "ar"),
        Country(name: "Sweden", flag: "🇸🇪", code: "sv"),
        Country(name: "Norway", flag: "🇳🇴", code: "no"),
        Country(name: "Denmark", flag: "🇩🇰", code: "da"),
        Country(name: "Finland", flag: "🇫🇮", code: "fi"),
        Country(name: "Netherlands", flag: "🇳🇱", code: "nl"),
        Country(name: "Switzerland", flag: "🇨🇭", code: "de"),
        Country(name: "Australia", flag: "🇦🇺", code: "en"),
        Country(name: "New Zealand", flag: "🇳🇿", code: "en"),
        Country(name: "South Africa", flag: "🇿🇦", code: "af"),
        Country(name: "Argentina", flag: "🇦🇷", code: "es")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSpeech()
        activityIndicator.isHidden = true
        ToCountryTF.isSearchEnable = false
        speechSynthesizer.delegate = self
        let countryNamesAndFlags = countries.map { "\($0.flag) \($0.name)" }
        
        ToCountryTF.optionArray = countryNamesAndFlags
       
        ToCountryTF.didSelect { [weak self] (selectedText, index, id) in
            guard let self = self else { return }
            let selectedCountryCode = self.countries[index].code
            self.ToCountryCode = selectedCountryCode
            let name = self.countries[index].name
                
            self.ToCountryTF.text = "(\(name))"
            print("Selected to Country Code: \(selectedCountryCode)")
        }
        
        
        FromTV.delegate = self
        ToCountryTF.delegate = self
        
        FromTV.delegate = self
        FromTV.text = placeholderText
        FromTV.textColor = UIColor.lightGray
        
        
        //ToTV.delegate = self
        //ToTV.text = placeholderText
        //ToTV.textColor = UIColor.lightGray
        
        
        // Do any additional setup after loading the view.
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        FromTV.resignFirstResponder()
        ToTV.resignFirstResponder()
    }
 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          textField.resignFirstResponder()
          return true
      }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        FromTV.textColor = .white
            if textView.text == placeholderText {
                textView.text = ""
                textView.textColor = UIColor.white
            }
        }

        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text.isEmpty {
                textView.text = placeholderText
                textView.textColor = UIColor.lightGray
            }
        }
    
    
    
    
    func setupSpeech() {
        
        self.Micbtn.isEnabled = false
        self.speechRecognizer?.delegate = self
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            
            var isButtonEnabled = false
            
            switch authStatus {
            case .authorized:
                isButtonEnabled = true
                
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
                
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            }
            
            OperationQueue.main.addOperation() {
                self.Micbtn.isEnabled = isButtonEnabled
            }
        }
    }
    
    
    func startRecording() {
        
        // Clear all previous session data and cancel task
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        // Create instance of audio session to record voice
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.record, mode: AVAudioSession.Mode.measurement, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        self.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        self.recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                
                self.FromTV.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.Micbtn.isEnabled = true
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        self.audioEngine.prepare()
        
        do {
            try self.audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        self.FromTV.text = "Say something, I'm listening!"
    }
    
    func speak(text: String, languageCode: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: languageCode)
        speechSynthesizer.speak(utterance)
    }
    

    @IBAction func Micbtn(_ sender: UIButton) {
        if audioEngine.isRunning {
                    self.audioEngine.stop()
                    self.recognitionRequest?.endAudio()
                    self.Micbtn.isEnabled = false
                    self.Micbtn.setTitle("Start Recording", for: .normal)
                } else {
                    self.startRecording()
                    self.Micbtn.setTitle("Stop Recording", for: .normal)
                }

    }

    @IBAction func translatebtn(_ sender: UIButton) {
        let fromText = FromTV.text
        if (fromText?.isEmpty) ?? false {
            showAlert(title: "Error!", message: "Please Enter text to translate")
            return
        }
        
        if !FromTV.text.isEmpty  {
            activityIndicator.startAnimating()
            activityIndicator.isHidden = false
            SwiftyTranslate.translate(text: fromText ?? "", from: "en", to: ToCountryCode) { result in
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    switch result {
                    case .success(let translation):
                        print("Translated: \(translation.translated)")
                        self.ToTV.text = translation.translated
                    case .failure(let error):
                        print("Error: \(error)")
                        self.showAlert(title: "Error!", message: "Translation failed. Please try again.")
                    }
                }
            }
        } else {
            showAlert(title: "Error!", message: "Please Select the Country First")
        }
    }
    
    @IBAction func Backbtn(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func FromspeakbtnPressed(_ sender: UIButton) {
        speak(text: FromTV.text, languageCode:"en")
    }
    
    @IBAction func TospeakbtnPressed(_ sender: UIButton) {
        speak(text: ToTV.text, languageCode: ToCountryCode)
    }
    
  
    @IBAction func FromcopybtnPressed(_ sender: UIButton) {
        UIPasteboard.general.string = FromTV.text
        self.showToast(message: "Text Copied", font: .systemFont(ofSize: 14.0))
    }
    
    @IBAction func TocopybtnPressed(_ sender: UIButton) {
        UIPasteboard.general.string = ToTV.text
        self.showToast(message: "Text Copied", font: .systemFont(ofSize: 14.0))
    }

}

extension VoiceToTextViewController: SFSpeechRecognizerDelegate {

    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            self.Micbtn.isEnabled = true
        } else {
            self.Micbtn.isEnabled = false
        }
    }
}
