//
//  ViewController.swift
//  GitAPI
//
//  Created by Apple on 17/03/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var users = [String]()
    @IBOutlet weak var userName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        users.append("Hello")
    }

    @IBOutlet weak var tableView: UITableView!
    
   
    
    @IBAction func filterUsers(_ sender: Any) {
        let params = ["token":"N/A"]
        WebService.performRequest(.get, entity: userName.text!, params: params as! [String : AnyObject], comletion: {
            (_ val :Any?, _ error:String?, _ statusCode: Int) -> (Void) in
            
            if  val != nil {
                print(val)
                
                self.users = [String]()
                if let jsonResult = val as? [[String:AnyObject]] {
                    for (_, activity) in jsonResult.enumerated() {
                        
                        if let title = activity["login"] as? String {
                            self.users.append(title)
                        }
                        
                    }
                }
                self.tableView.reloadData()
                
                
            }
            
        })
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GenericCell", for: indexPath) as? TableViewCell {
           
            cell.userNameLabel.text = users[indexPath.row]
            cell.selectionStyle = .none
            
            return cell
            
        } else {
            return UITableViewCell()
        }
        
        
    }

}

