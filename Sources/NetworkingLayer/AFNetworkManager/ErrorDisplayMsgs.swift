//
//  ErrorDisplayMsgs.swift
//  House
//
//  Created by Faraz Haider on 19/11/2019.
//  Copyright © 2019 Ahmed samir ali. All rights reserved.
//

import Foundation
import SmilesLanguageManager

class ErrorDisplayMsgs{
    
    static func returnServiceFailureMessage(response : BaseMainResponse) -> String{
        if let responseMSG = response.responseMsg, !responseMSG.isEmpty{
            return responseMSG
        }
        else if let errorMSG = response.errorMsg, !errorMSG.isEmpty{
            return errorMSG
        }
        else{
            return SmilesLanguageManager.shared.getLocalizedString(for: "NoContent")
        }
    }
    
    static func returnNetworkErrorMessage(error : ErrorCodeConfiguration?) -> String{
        
        if let error = error{
            if let errorEn = error.errorDescriptionEn, !errorEn.isEmpty{
                return errorEn
            }
            else if let errorAr = error.errorDescriptionAr, !errorAr.isEmpty{
                return errorAr
            }
            else{
                return SmilesLanguageManager.shared.getLocalizedString(for: "ServiceFail")
            }
        }
        else{
            return SmilesLanguageManager.shared.getLocalizedString(for: "ServiceFail")
            
        }
    }
    
    
    static func isResponseFaild(response : BaseMainResponse) -> Bool{
        if let responseMSG = response.responseMsg, !responseMSG.isEmpty{
            return true
        }
        else if let errorMSG = response.errorMsg, !errorMSG.isEmpty{
            return true
        }
        return false
    }
    
}