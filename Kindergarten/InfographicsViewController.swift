//
//  InfographicsViewController.swift
//  Kindergarten
//
//  Created by Sergey Teteryatnik on 31/08/2017.
//  Copyright © 2017 Informika. All rights reserved.
//

import UIKit

class InfographicsViewController: UIViewController {

    var selectedInfographicsType: InfographicsType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        navigationController!.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController!.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UI Actions
    
    @IBAction func showInfographicsDetail(_ sender: UIButton) {
        selectedInfographicsType = InfographicsType(rawValue: sender.tag)
        self.performSegue(withIdentifier: "Infographics Detail Segue", sender: self)
    }
     
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "Infographics Detail Segue" {
            if let viewController = segue.destination as? InfographicsDetailViewController {
                viewController.infographicsType = selectedInfographicsType
            }
        }
    }

}
