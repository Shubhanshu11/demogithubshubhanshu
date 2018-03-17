//
//  WebService.swift
//  EWH
//
//  Created by LMD on 20/02/17.
//  Copyright © 2017 LMD. All rights reserved.
//
import Foundation
import Alamofire
struct WebService {
    
    
    typealias jsonStandard = [String:AnyObject]
    typealias getRequestMethodHandler = (_ response : AnyObject) -> Void
    
    static func checkError (_ val : [String:AnyObject]?) -> (String?) {
        
        if let data = val {
            if let error = data["error"] {
                
                if let message = error["message"] {
                    
                    return message as? String
                }
            }
        }
        
        return nil
    }
    

    
    static func performRequest(_ method: HTTPMethod, entity: String, params: [String: AnyObject], comletion: @escaping (_ json: Any?, _ error:String?, _ statusCode:Int) -> Void) {
        
        var Auth_header    = [ "X-Access-Token" : "" ]
        /*if let data = UserDefaults.standard.data(forKey: "ME") {
         
         if let ME = NSKeyedUnarchiver.unarchiveObject(with: data) as? MemberModel {
         if let token_ = ME.token {
         Auth_header.updateValue(token_, forKey: "X-Access-Token")
         }
         }
         }*/
        let url = "https://api.github.com/users/"+entity+"/followers?per_page=100"
        Alamofire.request(url, method: method, parameters: params, headers: Auth_header).responseJSON { (response:DataResponse<Any>) in
            var statusCode = 555
            switch(response.result) {
            case .success(_):
                var output:Any? = nil
                if let data = response.data{
                    output = WebService.parseData(JSONData:data)
                }
                if let _statusCode = response.response?.statusCode {
                    statusCode = _statusCode
                }
                comletion(output, WebService.checkError(output as? [String:AnyObject]), statusCode)
                break
                
            case .failure(_):
                comletion(nil, "Something went wrong", statusCode)
                break
                
            }
        }
        
    }
    
    
    static func parseData(JSONData: Data)  -> Any? {
        
        do {
            let readableJSON = try JSONSerialization.jsonObject(with: JSONData, options:.mutableContainers)
            return readableJSON
            
        }
        catch {
            //print(error)
        }
        return nil
    }
    
}

