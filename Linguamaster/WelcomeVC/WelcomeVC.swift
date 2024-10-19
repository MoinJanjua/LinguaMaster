//
//  ViewController.swift
//  LinguaLens
//
//  Created by Unique Consulting Firm on 28/06/2024.
//

import UIKit

class WelcomeVC: UIViewController {

    @IBOutlet weak var strtbtn:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roundCorner(button: strtbtn)
    
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
        { (granted, error) in
            if granted {
                print("Notification permission granted")
            } else {
                print("Notification permission denied")
            }
        }
        

        // Do any additional setup after loading the view.
    }


    @IBAction func startbtnPressed(_ sender:UIButton)
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        newViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        newViewController.modalTransitionStyle = .crossDissolve
        self.present(newViewController, animated: true, completion: nil)

    }
    

}

