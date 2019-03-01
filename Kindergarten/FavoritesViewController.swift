//
//  FavoritesViewController.swift
//  Kindergarten
//
//  Created by Sergey Teteryatnik on 22/09/2017.
//  Copyright © 2017 Informika. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableview: UITableView!
    
    var favorites: Array<String>?
    var kindergartenId = ""
    var favoriteId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let nc = NotificationCenter.default
        nc.addObserver(forName:Notification.Name(rawValue:"UPDATE_FAVORITES"), object:nil, queue:nil) { [weak self] notification in
            guard let strongSelf = self else {
                return
            }
            strongSelf.favorites = DataManager.sharedInstance.getFavorites()
            if strongSelf.favorites != nil {
                strongSelf.tableview.reloadData()
            }
        }
        nc.addObserver(forName:Notification.Name(rawValue:"REMOVE_FAVORITE"), object:nil, queue:nil) { [weak self] notification in
            guard let strongSelf = self else {
                return
            }
            DataManager.sharedInstance.updateFavorites(kindergartenId: strongSelf.favoriteId, remove: true)
        }
        nc.addObserver(forName:Notification.Name(rawValue:"REMOVE_FAVORITE_REQUEST"),
                       object:nil, queue:nil) { [weak self] notification in
                        guard let strongSelf = self else {
                            return
                        }
                        strongSelf.favoriteId = notification.userInfo?["id"] as! String
                        strongSelf.performSegue(withIdentifier: "Remove Favorite Request Segue", sender: strongSelf)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        favorites = DataManager.sharedInstance.getFavorites()
        if favorites != nil {
            tableview.reloadData()
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Kindergarten Segue" {
            if let viewController = segue.destination as? KindergartenTableViewController {
                viewController.viewmodel = KindergartenViewModel(kindergarten: DataManager.sharedInstance.kindergartenById(id: kindergartenId)!)
            }
        }
    }

    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites != nil ? favorites!.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesTableCell", for: indexPath as IndexPath) as? FavoritesTableViewCell else {
            return UITableViewCell()
        }
        
        let kindergarten = DataManager.sharedInstance.kindergartenById(id: (favorites?[indexPath.row])!)
        
        cell.id = kindergarten?.id
        cell.title.text = kindergarten?.name
        cell.address.text = kindergarten?.legalAddress
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        kindergartenId = (favorites?[indexPath.row])!
        self.performSegue(withIdentifier: "Kindergarten Segue", sender: self)
    }
    
}
