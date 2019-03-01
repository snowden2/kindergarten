//
//  CustomSearchController.swift
//  Kindergarten
//
//  Created by Sergey Teteryatnik on 21/09/2017.
//  Copyright © 2017 Informika. All rights reserved.
//

import UIKit

class CustomSearchController: UISearchController, UISearchBarDelegate {

    lazy var _searchBar: CustomSearchBar = {
        let width = UIScreen.main.bounds.size.width*0.9
        let result = CustomSearchBar(frame: CGRect(x: 0, y: 0, width: width, height: 45))
        result.delegate = self
        
        return result
    }()
    
    override var searchBar: UISearchBar {
        get {
            return _searchBar
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.searchBar.barStyle = .default;
        self.searchBar.searchBarStyle = .default;
        self.searchBar.placeholder = "Поиск детского сада по адресу"
        self.searchBar.isTranslucent = true
        let image = UIImage()
        self.searchBar.setBackgroundImage(image, for: .any, barMetrics: .default)
        self.searchBar.scopeBarBackgroundImage = image
        self.searchBar.showsCancelButton = false
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
