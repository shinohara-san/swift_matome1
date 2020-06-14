//
//  EditViewController.swift
//  TenshokuApp
//
//  Created by Yuki Shinohara on 2020/06/14.
//  Copyright © 2020 Yuki Shinohara. All rights reserved.
//

import UIKit
import RealmSwift

class EditViewController: UIViewController {
    
    var company: Company!
    
    @IBOutlet var companyNane: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var detailTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailTextField.layer.borderWidth = 1.0
        detailTextField.layer.borderColor = UIColor.gray.cgColor
        detailTextField.layer.cornerRadius = 8.0
        companyNane.text = company.name
        detailTextField.text = company.detail
        
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.locale = Locale(identifier: "ja_JP")
        datePicker.date = formatter.date(from: company.date)!
        
        Common.downloadPicture(company: company, imageView: imageView)
        datePicker.datePickerMode = .date
        
    }
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        let ac = UIAlertController(title: "上書きしますか？", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "上書きする", style: .default, handler: { (_) in
            
            let formatter = DateFormatter()
            formatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale
            formatter.dateStyle = DateFormatter.Style.full
            let updatedDate =  formatter.string(from: self.datePicker.date)
            
            let realm = try! Realm()
            guard let updatedDetail = self.detailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            // 以前に保存したものと同じプライマリキーを持つBookオブジェクトを作成する
            let updatedCompany = Company()
            updatedCompany.name = self.company.name
            updatedCompany.date = updatedDate
            updatedCompany.detail = updatedDetail
            updatedCompany.urlString = self.company.urlString
            updatedCompany.id = self.company.id
            
            // id = 1のBookオブジェクトの値を更新する
            try! realm.write {
                realm.add(updatedCompany, update: .all)
            }
            
            self.navigationController?.popViewController(animated: true)
        }))
        ac.addAction(UIAlertAction(title: "キャンセルする", style: .cancel, handler: nil))
        present(ac, animated: true)
        
        
    }
}
