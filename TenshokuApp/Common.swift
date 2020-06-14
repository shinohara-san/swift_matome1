//
//  Common.swift
//  TenshokuApp
//
//  Created by Yuki Shinohara on 2020/06/14.
//  Copyright © 2020 Yuki Shinohara. All rights reserved.
//

import Foundation
import UIKit

class Common: NSObject {

    class func downloadPicture(company: Company, imageView: UIImageView){
        if let pictureURL = URL(string: company.urlString) {
            let session = URLSession(configuration: .default)
            let downloadPicTask = session.dataTask(with: pictureURL) { (data, _, error) in
                
                if let error = error {
                    print("Error downloading cat picture: \(error)")
                } else {
                    
                    if let imageData = data {
                        DispatchQueue.main.async {
                            let image = UIImage(data: imageData)
                            imageView.image = image
                        }
                        
                    } else {
                        print("Couldn't get image: Image is nil")
                    }
                    
                }
            }
            downloadPicTask.resume()
        } else { return }
        
    }
}
