//
//  TouchIDAuthentication.swift
//  TouchMeIn
//
//  Created by akhil mantha on 12/06/17.
//  Copyright © 2017 iT Guy Technologies. All rights reserved.
//

import Foundation
import LocalAuthentication


class TouchIDAuth{
    
    let context = LAContext()
    func canEvaluatePolicy() -> Bool{
        
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        
        
        
    }
    
    func authenticateUser(completion: @escaping(String?) -> Void){
        
        guard canEvaluatePolicy() else {
            return
        }
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Logging In with touch ID") {(success , evaluateError) in
        
        if success {
            DispatchQueue.main.async {
                completion(nil)
            }
            
        }else{
            
            let message : String
            
            
            switch evaluateError {
                
            case LAError.authenticationFailed?:
                message = "There was a problem verifying your identity"
                break
            case LAError.userCancel?:
                message = "you pressed cancel"
                break
            case LAError.userFallback?:
                message = "you pressed the password"
                break
            default:
                message = "touch id was not configured"
                break
                
                }
            
            completion(message)
            }
        }
    }
    
    
    
}
