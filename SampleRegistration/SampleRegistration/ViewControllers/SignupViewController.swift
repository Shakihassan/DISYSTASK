//
//  ViewController.swift
//  SampleRegistration
//
//  Created by hassan on 28/07/19.
//  Copyright © 2019 hassan. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import NotificationBannerSwift


class SignupViewController: UIViewController,UITextFieldDelegate {
    
    //    MARK: Variables and Iboutlets
    
    @IBOutlet weak var eidTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var nameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var idbarahnoTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var emailAddress: SkyFloatingLabelTextField!
    @IBOutlet weak var mobileNumberTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var unifiednumberTextfield: SkyFloatingLabelTextField!
    @IBOutlet weak var signupButton: UIButton!
    
    //    MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
         
    }
    

    
    //    MARK: Textfield Delegates methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == eidTextField  || textField == idbarahnoTextField || textField == mobileNumberTextField || textField == unifiednumberTextfield{
            
            let allowedCharacters = "0123456789"
            let allowedCharactersSets = CharacterSet(charactersIn: allowedCharacters)
            let typedCharactersSets = CharacterSet(charactersIn: string)
            
            var isAllowed = Bool()
            
            isAllowed = allowedCharactersSets.isSuperset(of: typedCharactersSets)
            
            if isAllowed == true
            {
                return true;
            }else
            {
                self.showMessageFailurePopups(message: "Please enter a valid number.")
                return false;
            }
            
        }
        else if textField == nameTextField
        {
            let allowedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
            let allowedCharactersSets = CharacterSet(charactersIn: allowedCharacters)
            let typedCharactersSets = CharacterSet(charactersIn: string)
            
            var isAllowed = Bool()
            
            isAllowed = allowedCharactersSets.isSuperset(of: typedCharactersSets)
            
            if isAllowed == true
            {
                return true;
            }else
            {
                self.showMessageFailurePopups(message: "Please enter a valid characters.")
                return false;
            }
        }
        
        
        return true;
    }
    //    MARK: Sign up Actions
    
    @IBAction func signUpActionButton(_ sender: Any) {
        
        let isValidInput:Bool = self.validateTheInputParameters()
        
        if isValidInput == false {
            return
        }

        let eidInt = Int(eidTextField.text!)
        let idbarahnoInt = Int(idbarahnoTextField.text!)
        let unifiednumberInt = Int(unifiednumberTextfield.text!)
        let mobilenoInt = Int(mobileNumberTextField.text!)
        
        var urlString = NSString()
        urlString = Constants.constantsVariables.baseURL + Constants.webApiURLString.certificatesApiString as NSString
        
        self.showLoadingIndicator()
        
        var params = NSDictionary()
        params = ["eid":eidInt as Any,"name":nameTextField.text as Any,"idbarahNo":123456,"emailaddress":emailAddress.text as Any,"unifiednumber":unifiednumberInt as Any,"mobileno":mobilenoInt as Any]  as NSDictionary
        
  
        
        HttpHelper.postAPICallHandleJson(anyDict:params, urlString: urlString as String) { (responses) in
            if responses?.status == ResponseStatus.Success
            {
                var successBoolValue = Bool()
                successBoolValue = responses?.returnDictionaryValues["success"]as! Bool
                if successBoolValue == true
                {
                     DispatchQueue.main.async {
                        self.hideLoadingIndicator()
                        UserDefaults.standard.set(params, forKey: "UserDetails")
                        self.showMessageSuccessPopups(message: responses?.returnDictionaryValues["message"] as! String)
                        let listingNewsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ListingNewsViewController") as! ListingNewsViewController
                        self.navigationController?.pushViewController(listingNewsViewController, animated: true)

                    }
                }else{

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
    
    //    MARK: Validate the Input parameters
    
    func validateTheInputParameters() -> Bool {
        
        var isValidInput:Bool = true
        let isValidEmailId = self.isValidEmail(emailString: emailAddress.text!)
        
        if eidTextField.text!.isEmpty {
            self.showMessageFailurePopups(message: "Please enter your eid.")
            isValidInput = false
        }else if nameTextField.text!.isEmpty
        {
            self.showMessageFailurePopups(message: "Please enter your name.")
            isValidInput = false
        }else if idbarahnoTextField.text!.isEmpty
        {
            self.showMessageFailurePopups(message: "Please enter your idbarahno.")
            isValidInput = false
        }
        else if emailAddress.text!.isEmpty
        {
            self.showMessageFailurePopups(message: "Please enter your email.")
            isValidInput = false
        }else if (isValidEmailId == false)
        {
            self.showMessageFailurePopups(message: "Please enter valid  email address.")
            isValidInput = false
        }else if unifiednumberTextfield.text!.isEmpty
        {
            self.showMessageFailurePopups(message: "Please enter your unified number.")
            isValidInput = false
        }
        else if mobileNumberTextField.text!.isEmpty
        {
            self.showMessageFailurePopups(message: "Please enter your mobile number.")
            isValidInput = false
        }
        
        return isValidInput
    }
}

