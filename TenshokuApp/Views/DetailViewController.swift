//
//  DetailViewController.swift
//  TenshokuApp
//
//  Created by Yuki Shinohara on 2020/06/11.
//  Copyright © 2020 Yuki Shinohara. All rights reserved.
//

import UIKit
import RealmSwift
import FirebaseStorage

class DetailViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var deleteButton: UIButton!
    
    @IBOutlet var name: UILabel!
    
    @IBOutlet var date: UILabel!
    @IBOutlet var detail: UILabel!
    
    var company: Company!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.Extension.gray
        deleteButton.layer.cornerRadius = 8.0
        
        name.text = company.name
        date.text = company.date
        detail.text = company.detail
        
        Common.downloadPicture(company: company, imageView: imageView)
        
        let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
        navigationItem.rightBarButtonItem = addBarButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) { //画面が戻ってきたときのアプデ
        name.text = company.name
        date.text = company.date
        detail.text = company.detail
    }
    
    @objc func editButtonTapped(){
//        print("edit")
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "edit") as? EditViewController else { return }
        vc.company = company
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        let ac = UIAlertController(title: "確認", message: "本当に削除しますか", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "削除する", style: .destructive, handler: { (_) in
            let realm = try! Realm()
            // Create a reference to the file to delete
            let desertRef = Storage.storage().reference().child("images/\(self.company.name).png")
            // Delete the file
            desertRef.delete { error in
              if let error = error {
                print(error.localizedDescription)
              } else {
                print("Deleted!")
              }
            }
            
            try! realm.write({
                realm.delete(self.company)
            })
            self.navigationController?.popViewController(animated: true) //メイン画面へ戻る
        }))
        
        ac.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        
        present(ac, animated: true)

    }
    
}
