//
//  InfographicsDetailViewController.swift
//  Kindergarten
//
//  Created by Sergey Teteryatnik on 31/08/2017.
//  Copyright © 2017 Informika. All rights reserved.
//

import UIKit

class InfographicsDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    private var infographics = Array<UIImage>()
    private var headerString = ""
    private var footerString = ""
    
    public var infographicsType: InfographicsType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareInfographics()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private methods
    
    func makeHeaderFooterView(forHeader: Bool) -> UIView {
        let viewHeight = forHeader ? 60.0 : 100.0
        
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: Double(self.tableView.frame.size.width), height: viewHeight))
        
        let title = UILabel(frame: view.frame)
        title.numberOfLines = forHeader ? 2 : 4
        title.text = forHeader ? headerString : footerString
        title.font = UIFont(name: "Helvetica-Light", size: 18)
        title.textAlignment = .center
        
        view.addSubview(title)
        
        return view
    }
    
    private func prepareInfographics() {
        if infographicsType == InfographicsType.enrollKindergarten {
            infographics.append(UIImage(named: "enroll1")!)
            infographics.append(UIImage(named: "enroll2")!)
            infographics.append(UIImage(named: "enroll3")!)
            infographics.append(UIImage(named: "enroll4")!)
            infographics.append(UIImage(named: "enrollFooter")!)
            headerString = "Как подать заявление\nв детский сад?".uppercased();
            footerString = "ПОЗДРАВЛЯЕМ!\nВы зарегистрированы\nв электронной\nочереди";
        } else if (infographicsType == InfographicsType.changeKindergarten) {
            infographics.append(UIImage(named: "change1")!)
            infographics.append(UIImage(named: "change2")!)
            infographics.append(UIImage(named: "change3")!)
            infographics.append(UIImage(named: "change4")!)
            headerString = "Как сменить детский сад".uppercased();
        } else {
            infographics.append(UIImage(named: "notListed1")!)
            infographics.append(UIImage(named: "notListed2")!)
            infographics.append(UIImage(named: "notListed3")!)
            infographics.append(UIImage(named: "notListed4")!)
            headerString = "Почему мы не попали\nв детский сад?".uppercased();
            footerString = "чтобы увеличить шансы\nпопадания в детский сад,\nвыбирайте несколько\nдетских садов, а не один".uppercased();
        }
        
        tableView.tableHeaderView = makeHeaderFooterView(forHeader: true)
        tableView.tableFooterView = makeHeaderFooterView(forHeader: false)
        
        tableView.reloadData()
    }

    // MARK: - UITableViewDelegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infographics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "InfographicsDetailTableViewCell", for: indexPath as IndexPath) as? InfographicsDetailTableViewCell else {
            return UITableViewCell()
        }
        
        let subViews = cell.contentView.subviews
        for subview in subViews{
            if subview.tag == 100 {
                subview.removeFromSuperview()
            }
        }
        
        let infographicsImageView = UIImageView(image: infographics[indexPath.row])
        infographicsImageView.frame.size.width = cell.contentView.frame.width * 0.8
        infographicsImageView.center = cell.contentView.center
        infographicsImageView.contentMode = .scaleAspectFit
        infographicsImageView.tag = 100
        
        cell.contentView.addSubview(infographicsImageView)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return infographics[indexPath.row].size.height + 10;
    }
    
}
