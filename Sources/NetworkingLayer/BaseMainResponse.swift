//
//  BaseMainResponse.swift
//  SmilesNetworkLayerTest
//
//  Created by Hanan Ahmed on 9/27/22.
//

import Foundation
//import SmilesBaseMainRequestManager

//open class BaseMainResponse : Codable {
//
//    public var additionalInfo : [BaseMainResponseAdditionalInfo]?
//    public var responseCode : String?
//    public var responseMsg : String?
//    public var errorCode : String?
//    public var errorMsg : String?
//    public var errorTitle: String?
//    public var extTransactionId: String?
//
//
//    private enum CodingKeys: String, CodingKey {
//        case additionalInfo = "additionalInfo"
//        case responseCode = "responseCode"
//        case responseMsg = "responseMsg"
//        case errorCode = "errorCode"
//        case errorMsg = "errorMsg"
//        case errorTitle = "errorTitle"
//        case extTransactionId
//    }
//
//    public required init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        additionalInfo = try values.decodeIfPresent([BaseMainResponseAdditionalInfo].self, forKey: .additionalInfo)
//        responseCode = try values.decodeIfPresent(String.self, forKey: .responseCode)
//        responseMsg = try values.decodeIfPresent(String.self, forKey: .responseMsg)
//        errorCode = try values.decodeIfPresent(String.self, forKey: .errorCode)
//        errorMsg = try values.decodeIfPresent(String.self, forKey: .errorMsg)
//        errorTitle = try values.decodeIfPresent(String.self, forKey: .errorTitle)
//        extTransactionId = try values.decodeIfPresent(String.self, forKey: .extTransactionId)
//    }
//
//    public init() {}
//
//}

public protocol BaseMainResponse: Codable {
     var additionalInfo : [BaseMainResponseAdditionalInfo]?  { get set }
     var responseCode : String? { get set }
     var responseMsg : String?  { get set }
     var errorCode : String?  { get set }
     var errorMsg : String?  { get set }
     var errorTitle: String?  { get set }
     var extTransactionId: String?  { get set }
}


public protocol BaseMainResponseAdditionalInfo: Codable {
    var name : String? { get set }
    var value : String? { get set }
}
