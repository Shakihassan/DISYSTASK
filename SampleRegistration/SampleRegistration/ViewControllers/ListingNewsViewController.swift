//
//  ListingNewsViewController.swift
//  SampleRegistration
//
//  Created by hassan on 29/07/19.
//  Copyright © 2019 hassan. All rights reserved.
//

import UIKit

class ListingNewsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    //  MARK: Variables and Iboutlets
    var payLoadArray = NSMutableArray()
    var imageCacheForTitle = NSCache<AnyObject, AnyObject>()
    @IBOutlet weak var tableViewForListing: UITableView!
    
    //    MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        
        self.tableViewForListing.register(UINib.init(nibName: "ListingNewsTableViewCell", bundle: nil), forCellReuseIdentifier: "cellIdentifier")
        
        self.tableViewForListing.tableFooterView = UIView()
        self.tableViewForListing.rowHeight = UITableView.automaticDimension
        self.tableViewForListing.estimatedRowHeight = UITableView.automaticDimension
        getAllTheList()
        
    }
    
    //    MARK: Get All the News List
    
    func getAllTheList()  {
        
        self .showLoadingIndicator()
        var urlString  = NSString()
        urlString = Constants.constantsVariables.baseURL + Constants.webApiURLString.listedApiString as NSString
        HttpHelper.handleGetAPICall(urlString: urlString as String) { (responses) in
            if responses?.status == ResponseStatus.Success
            {
                var successBoolValue = Bool()
                successBoolValue = responses?.returnDictionaryValues["success"]as! Bool
                if successBoolValue == true
                {
                    
                    DispatchQueue.main.async {
                        self.hideLoadingIndicator()
                        var payLoadArrays = NSArray()
                        payLoadArrays = responses?.returnDictionaryValues["payload"] as! NSArray
                        print(payLoadArrays)
                        
                        self.payLoadArray = payLoadArrays.mutableCopy() as! NSMutableArray
                        self.tableViewForListing .reloadData()
                    }
                    
                    
                }else
                {
                    DispatchQueue.main.async {
                        self.hideLoadingIndicator()
                        self.showMessageFailurePopups(message:responses!.returnDictionaryValues["message"] as! String)

                    }
                }
                
                
            }else
            {
                DispatchQueue.main.async {
                    self.hideLoadingIndicator()
                    self.showMessageFailurePopups(message:responses!.SRResponseString)
                }
            }
            
        }
    }
    
    //    MARK: TableView Delegates and Datasources
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return payLoadArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
          let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as! ListingNewsTableViewCell
    
        var payLoadDictionary = NSDictionary()
        payLoadDictionary = self.payLoadArray[indexPath.row] as! NSDictionary;
        cell.imageForListing.tag = indexPath.row
        
        cell.titleLabel.text = (payLoadDictionary["title"] as! String)
        
        var imageURLString = NSString ()
        imageURLString   = payLoadDictionary["image"] as! NSString
        
        
        if !imageURLString.isEqual(to: "") {
            
            if let imageFromCache = imageCacheForTitle.object(forKey: imageURLString) as? UIImage
            {
                if cell.imageForListing.tag == indexPath.row{
                    cell.imageForListing.image = imageFromCache
                }

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
                        
                        if cell.imageForListing.tag == indexPath.row{
                            if imageToCache != nil{
                                self.imageCacheForTitle.setObject(imageToCache!, forKey: imageURLString)
                                cell.imageForListing.image = imageToCache
                            }
                        }
                    }
                }
                
                task.resume()
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var payLoadDictionary = NSDictionary()
        payLoadDictionary = self.payLoadArray[indexPath.row] as! NSDictionary;
        
        let newsDetailsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewsDetailsViewController") as! NewsDetailsViewController
        newsDetailsViewController.detailsDictionary = payLoadDictionary
        self.navigationController?.pushViewController(newsDetailsViewController, animated: true)
        
    }
    
}
