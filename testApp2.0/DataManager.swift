//
//  DataManager.swift
//  testApp2.0
//
//  Created by Alexander Kravchenko on 12.04.17.
//  Copyright © 2017 Anastasia. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class DataManager {
    
    private let loginUrl = "https://api.vid.me/auth/create"
    private let logoutUrl = "https://api.vid.me/auth/delete"

    
    private init() {}
    static let instance = DataManager()
    
    
    private(set) var currentUser: User?
    
    
    func login(login: String, password: String) {
        
        let params: [String : Any] = ["username" : login, "password" : password]
        
        Alamofire.request(loginUrl, method: .post, parameters: params).responseJSON { response in
            let result = JSON(response.result.value)
            
            if let user = User(json: result) {
                self.currentUser = user

                NotificationCenter.default.post(name: .GotUser, object: nil)
            } else {
                NotificationCenter.default.post(name: .DidFailGetUser, object: nil)
            }
            
        }
        
    }
    
    func logout () {
        
        let token: [String : Any] = ["token" : currentUser?.token]
        
        Alamofire.request(logoutUrl, method: .post, parameters: token).responseJSON { response in
            let result = JSON(response.result.value)
            
            if let statusField = result["status"].bool, statusField == true {
                self.currentUser = nil
                NotificationCenter.default.post(name: .CompleteLogout, object: nil)
            } else {
                NotificationCenter.default.post(name: .DidFailCompleteLogout, object: nil)
            }
            
        }
    }
    
}
