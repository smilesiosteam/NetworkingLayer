//
//  BaseMainResponse.swift
//  SmilesNetworkLayerTest
//
//  Created by Hanan Ahmed on 9/27/22.
//

import Foundation

struct BaseMainResponse : Codable {

    let additionalInfo : [BaseMainResponseAdditionalInfo]?
    let responseCode : String?
    let responseMsg : String?
    let errorCode : String?
    let errorMsg : String?
    let errorTitle: String?
    let extTransactionId: String?
    
    enum CodingKeys: String, CodingKey {
        case additionalInfo
        case responseCode
        case responseMsg
        case errorCode
        case errorMsg
        case errorTitle
        case extTransactionId
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        additionalInfo = try values.decodeIfPresent([BaseMainResponseAdditionalInfo].self, forKey: .additionalInfo)
        responseCode = try values.decodeIfPresent(String.self, forKey: .responseCode)
        responseMsg = try values.decodeIfPresent(String.self, forKey: .responseMsg)
        errorCode = try values.decodeIfPresent(String.self, forKey: .errorCode)
        errorMsg = try values.decodeIfPresent(String.self, forKey: .errorMsg)
        errorTitle = try values.decodeIfPresent(String.self, forKey: .errorTitle)
        extTransactionId = try values.decodeIfPresent(String.self, forKey: .extTransactionId)
    }
    
}




struct BaseMainResponseAdditionalInfo : Codable {
    
    let name : String?
    let value : String?

}
