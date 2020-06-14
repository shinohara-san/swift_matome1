//
//  AddViewController.swift
//  TenshokuApp
//
//  Created by Yuki Shinohara on 2020/06/11.
//  Copyright © 2020 Yuki Shinohara. All rights reserved.
//

import UIKit
import RealmSwift
import FirebaseStorage

class AddViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet var companyName: UITextField!
    @IBOutlet var date: UIDatePicker!
    @IBOutlet var detail: UITextView!
    @IBOutlet var saveButton: UIButton!
    var urlString: String!
    
    var storage = Storage.storage().reference()
    
    var addBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.Extension.gray
        
        detail.layer.borderWidth = 1.0
        detail.layer.borderColor = UIColor.gray.cgColor
        detail.layer.cornerRadius = 8.0
        
        saveButton.layer.cornerRadius = 8.0
        
        date.datePickerMode = .date
    }
    @IBAction func picAddButtonTapped(_ sender: Any) {
        let filteredCompanyName = companyName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if filteredCompanyName == "" {
           showAlert(message: "会社名を入れてください")
            return
        } else {
            let picker = UIImagePickerController() //画像を取得する
            picker.sourceType = .photoLibrary //取得先
            picker.delegate = self
            picker.allowsEditing = true //取得した画像を編集するかどうか
            present(picker, animated: true)
        }
        
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        let newCompany = Company()
        
        guard let name = companyName.text else {
            showAlert(message: "会社名を入れてください")
            return
        }
        
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale
        formatter.dateStyle = DateFormatter.Style.full
        let dateInfo =  formatter.string(from: date.date)
//        print(dateInfo)
        
        guard let detail = detail.text else {
            showAlert(message: "メモを入れてください")
            return
        }
        
        guard let checkedUrl = urlString else {
            showAlert(message: "画像を選択してください")
            return
        }
        
        newCompany.id = UUID().uuidString //Primary key for update
        newCompany.name = name
        newCompany.date = dateInfo
        newCompany.detail = detail
        newCompany.urlString = checkedUrl
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(newCompany)
        }
//        print(newCompany.id)
        self.navigationController?.popViewController(animated: true) //メイン画面へ戻る
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {return}
        
        guard let imageData = image.pngData() else {return}
        
        let ref = storage.child("images/\(companyName.text!).png")
//         UUID().uuidString をcompanyクラスにつける
        ref.putData(imageData, metadata: nil) { (_, error) in
            guard error == nil else {
                return
            }
            ref.downloadURL { (url, error) in
                guard let url = url, error == nil else {return}
                self.urlString = url.absoluteString
                
            }
        }
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
    
    func showAlert(message:String){
        let ac = UIAlertController(title: "エラー", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(ac, animated: true)
    }
    
}
