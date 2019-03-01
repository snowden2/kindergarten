//
//  HintViewController.swift
//  Kindergarten
//
//  Created by Sergey Teteryatnik on 16/10/2017.
//  Copyright © 2017 Informika. All rights reserved.
//

import UIKit

class HintViewController: UIViewController {

    @IBOutlet weak var transparentView: UIView!
    @IBOutlet weak var modalView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var hintTitle = ""
    var hintDescr = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.05) {
            self.transparentView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        titleLabel.text = hintTitle
        descriptionLabel.text = hintDescr
        descriptionLabel.sizeToFit()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func closeAction(_ sender: Any) {
        UIView.animate(withDuration: 0.05, animations: {
            self.transparentView.backgroundColor = UIColor.clear
        }) { (finished) in
            if finished {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}
