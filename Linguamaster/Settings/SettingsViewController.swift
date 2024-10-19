//
//  SettingsViewController.swift
//  LinguaLens
//
//  Created by Unique Consulting Firm on 01/07/2024.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var versionLb:UILabel!
    
    let NotificationIdentifier = "WeeklyReminder"
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"]!
        let build = Bundle.main.infoDictionary!["CFBundleVersion"]!
        versionLb.text = "Version \(version) (\(build))"
        // Do any additional setup after loading the view.
    }
    
     

    @IBAction func homebtnPressed(_ sender:UIButton)
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true)
    }
    
    @IBAction func OCRbtnPressed(_ sender:UIButton)
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
        newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true)
    }
    
    @IBAction func voicebtnPressed(_ sender:UIButton)
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "VoiceToTextViewController") as! VoiceToTextViewController
        newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true)
    }
    
    @IBAction func learnMorebtnPressed(_ sender:UIButton)
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "AboutusViewController") as! AboutusViewController
        newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true)
    }
    
    @IBAction func feedbackbtnPressed(_ sender:UIButton)
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "FeedbackViewController") as! FeedbackViewController
        newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true)
    }

    
    
    @IBAction func sharebtnPressed(_ sender:UIButton)
    {
        let appID = "LinguaMaster"
           let appStoreURL = URL(string: "https://apps.apple.com/app/id\(appID)")!
           
           let activityViewController = UIActivityViewController(activityItems: [appStoreURL], applicationActivities: nil)
           
           // For iPads
           if let popoverController = activityViewController.popoverPresentationController {
               popoverController.barButtonItem = sender as? UIBarButtonItem
           }
           
           present(activityViewController, animated: true, completion: nil)
    }

    @IBAction func backbtnPressed(_ sender:UIButton)
    {
        self.dismiss(animated: true)
    }
    

}
