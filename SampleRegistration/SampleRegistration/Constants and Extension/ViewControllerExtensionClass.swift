//
//  ViewControllerExtensionClass.swift
//  SampleRegistration
//
//  Created by hassan on 28/07/19.
//  Copyright © 2019 hassan. All rights reserved.
//

import UIKit
import NotificationBannerSwift
import SVProgressHUD

extension UIViewController
{
    
    //    MARK: Showing Message Popup
    func showMessageFailurePopups(message:String)
    {
        let banner = NotificationBanner(title:"", subtitle: message, style: .danger)
        banner.duration = 0.5
        banner.show()
        
    }
    
    func showMessageSuccessPopups(message:String)  {
        let bannerSuccess = NotificationBanner(title:"", subtitle: message, style: .success)
        bannerSuccess.show()
    }
    
    func isValidEmail(emailString:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailString)
    }
    
    func showLoadingIndicator()  {
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.show()
    }
    
    func hideLoadingIndicator() {
        SVProgressHUD.dismiss()
    }
    
}
