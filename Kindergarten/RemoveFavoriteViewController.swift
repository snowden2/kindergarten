//
//  RemoveFavoriteViewController.swift
//  Kindergarten
//
//  Created by Sergey Teteryatnik on 10/10/2017.
//  Copyright © 2017 Informika. All rights reserved.
//

import UIKit

class RemoveFavoriteViewController: UIViewController {

    @IBOutlet weak var transparentView: UIView!
    @IBOutlet weak var modalView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.modalView.layer.masksToBounds = false;
        self.modalView.layer.shadowOffset = CGSize(width: 2.0, height: 4.0)
        self.modalView.layer.shadowRadius = 4;
        self.modalView.layer.shadowOpacity = 0.5;
        
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
    
    @IBAction func removeFavoriteAction(_ sender: Any) {
        NotificationCenter.default.post(name:Notification.Name(rawValue:"REMOVE_FAVORITE"),
                                        object: nil,
                                        userInfo: nil)
        self.transparentView.backgroundColor = UIColor.clear
        self.dismiss(animated: true, completion: nil)
    }
    
}
