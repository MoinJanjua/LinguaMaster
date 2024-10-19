//
//  HomeViewController.swift
//  LinguaLens
//
//  Created by Unique Consulting Firm on 01/07/2024.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var languagebtn:UIButton!
    @IBOutlet weak var ocrbtn:UIButton!
    @IBOutlet weak var voiceToTextbtn:UIButton!
    @IBOutlet weak var settingsbtn:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roundCorner(button: languagebtn)
        roundCorner(button: ocrbtn)
        roundCorner(button: settingsbtn)
        roundCorner(button: voiceToTextbtn)
        // Do any additional setup after loading the view.
    }
    

    @IBAction func languagebtnPressed(_ sender:UIButton)
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "TranslationViewController") as! TranslationViewController
        newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)

    }
    
    @IBAction func ocrtbtnPressed(_ sender:UIButton)
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
        newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)

    }
    
    @IBAction func settingsbtnPressed(_ sender:UIButton)
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)

    }
    
    @IBAction func VoiceToText(_ sender: UIButton) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "VoiceToTextViewController") as! VoiceToTextViewController
        newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)

    }
    

}
