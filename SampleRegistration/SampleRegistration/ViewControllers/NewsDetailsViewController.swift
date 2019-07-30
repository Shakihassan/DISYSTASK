//
//  NewsDetailsViewController.swift
//  SampleRegistration
//
//  Created by hassan on 29/07/19.
//  Copyright © 2019 hassan. All rights reserved.
//

import UIKit

class NewsDetailsViewController: UIViewController {
    
    var imageCacheForDetails = NSCache<AnyObject, AnyObject>()
    var detailsDictionary = NSDictionary()
     @IBOutlet weak var dateLabel: UILabel!
     @IBOutlet weak var titleLabel: UILabel!
     @IBOutlet weak var imageForNews: UIImageView!
     @IBOutlet weak var descriptionTextView: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "News details"
        loadValuesFromTheDictionary()
    }
    
    func loadValuesFromTheDictionary()  {
        
        var dateString = NSString()
        var imageURLString = NSString()
        var descriptionString = NSString()
        var titleString = NSString()
        
        dateString = detailsDictionary["date"] as! NSString
        descriptionString = detailsDictionary["description"] as! NSString
        titleString = detailsDictionary["title"] as! NSString
        imageURLString = detailsDictionary["image"] as! NSString
        
        titleLabel.text = titleString as String
        dateLabel.text = dateString as String
        descriptionTextView.text = descriptionString as String
        
        if !imageURLString.isEqual(to: "") {
            
            if let imageFromCache = imageCacheForDetails.object(forKey: imageURLString) as? UIImage
            {
              
                    self.imageForNews.image = imageFromCache
               
            }else
            {
                let imageUrl = URL(string:imageURLString as String)
                
                let task = URLSession.shared.dataTask(with: imageUrl!){(data, response, error ) in
                    
                    if error != nil
                    {
                        print(error as Any)
                        return
                    }
                    
                    DispatchQueue.main.async {
                        let imageToCache = UIImage(data: data!)
                
                        if imageToCache != nil{
                                self.imageCacheForDetails.setObject(imageToCache!, forKey: imageURLString)
                                self.imageForNews.image = imageToCache
                            }
                        
                    }
                }
                
                task.resume()
            }
        }
        
        
    }


}
