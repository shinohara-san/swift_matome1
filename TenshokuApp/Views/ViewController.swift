//
//  ViewController.swift
//  TenshokuApp
//
//  Created by Yuki Shinohara on 2020/06/11.
//  Copyright © 2020 Yuki Shinohara. All rights reserved.
//

import UIKit
import RealmSwift
import FirebaseStorage

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.Extension.gray
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    @IBAction func addButtunTapped(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "add") as? AddViewController else { return }
        vc.title = "新規登録"
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}


extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let config = Realm.Configuration(schemaVersion: 2)
        Realm.Configuration.defaultConfiguration = config
//        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        let realm = try! Realm()
        let companies = realm.objects(Company.self)
        
        return companies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let cell = Bundle.main.loadNibNamed("CompanyTableViewCell", owner: self, options: nil)?.first as! CompanyTableViewCell
        
        cell.backgroundColor = UIColor.Extension.gray
        
        let realm = try! Realm()
        let companies = realm.objects(Company.self)
        let company = companies[indexPath.row]
        
        cell.nameLabel.text = company.name
        cell.dateLabel.text = company.date
        
        Common.downloadPicture(company: company, imageView: cell.imgView)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let realm = try! Realm()
        let companies = realm.objects(Company.self)
        let company = companies[indexPath.row]
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "detail") as? DetailViewController {
            vc.title = "詳細"
            vc.company = company
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let realm = try! Realm()
            let companies = realm.objects(Company.self)
            let company = companies[indexPath.row]
            
            // Create a reference to the file to delete
            let desertRef = Storage.storage().reference().child("images/\(company.name).png")
            // Delete the file
            desertRef.delete { error in
              if let error = error {
                print(error.localizedDescription)
              } else {
                print("Deleted!")
              }
            }
            
            try! realm.write({
                realm.delete(company)
            })
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
    }
    
}

