//
//  ServiceConfigurationErrorCodeConfiguration.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on January 15, 2019

import Foundation

class ErrorCodeConfiguration : Codable {
    
    var errorCode : Int
    var errorDescriptionAr : String?
    var errorDescriptionEn : String?
    
    enum CodingKeys: String, CodingKey {
        case errorCode = "errorCode"
        case errorDescriptionAr = "errorDescriptionAr"
        case errorDescriptionEn = "errorDescriptionEn"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        errorCode = try values.decodeIfPresent(Int.self, forKey: .errorCode) ?? 0
        errorDescriptionAr = try values.decodeIfPresent(String.self, forKey: .errorDescriptionAr)
        errorDescriptionEn = try values.decodeIfPresent(String.self, forKey: .errorDescriptionEn)
    }
    
    required init()
    {
        self.errorCode = 0
        self.errorDescriptionAr = ""
        self.errorDescriptionEn = ""
    }
    
}
