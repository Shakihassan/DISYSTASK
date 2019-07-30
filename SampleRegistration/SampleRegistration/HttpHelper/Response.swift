//
//  Response.swift
//  SampleRegistration
//
//  Created by hassan on 28/07/19.
//  Copyright © 2019 hassan. All rights reserved.
//

import UIKit

class Response: NSObject {

    public override init (){}
    
    public var paramsDictionaryValues = Dictionary<String, Any>()
    public var returnDictionaryValues = Dictionary<String, Any>()
    public var SRResponseString = String()
     public var returnArrayValues = NSArray()
    public var status  = ResponseStatus.Failure
}
