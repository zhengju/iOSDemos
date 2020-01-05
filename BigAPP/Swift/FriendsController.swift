//
//  FrendsController.swift
//  BigAPP
//
//  Created by zhengju on 2019/12/30.
//  Copyright © 2019 zhengju. All rights reserved.
//

import UIKit

class FriendsController: UIViewController {

    var tableView:UITableView? = nil
    var datas:[FriendModel] = []
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.red;
        
        tableView = UITableView.init(frame: self.view.bounds, style: .plain);
        tableView?.dataSource = self
        tableView?.delegate = self
        
        tableView?.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cellID");
        
        self.view.addSubview(tableView!);
        
        var names:[String] = ["1小名","2小红"];
        
        names = names.sorted(by: {$0>$1})
        
        
        for name in names {
            let model = FriendModel();
            model.name = name;
            datas.append(model);
        }
        tableView?.reloadData();
        
        
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self .dismiss(animated: true) {
            
        }
    }

}

extension FriendsController:UITableViewDelegate{
    
}

extension FriendsController:UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let  cell =  tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath);
        
        let model = datas[indexPath.row]
        
        cell.textLabel?.text = model.name;
        
        return cell;
        
    }
    
}
