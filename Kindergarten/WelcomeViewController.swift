//
//  WelcomeViewController.swift
//  Kindergarten
//
//  Created by Sergey Teteryatnik on 05/09/2017.
//  Copyright © 2017 Informika. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var transparentView: UIView!
    @IBOutlet weak var welcomeView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.welcomeView.layer.masksToBounds = false;
        self.welcomeView.layer.shadowOffset = CGSize(width: 2.0, height: 4.0)
        self.welcomeView.layer.shadowRadius = 4;
        self.welcomeView.layer.shadowOpacity = 0.5;
        
        let when = DispatchTime.now() + 0.1
        DispatchQueue.main.asyncAfter(deadline: when) { [unowned self] in
            self.transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.transparentView.backgroundColor = UIColor.clear
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
