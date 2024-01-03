//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 30/05/2023.
//

import Alamofire
import Foundation
import SmilesLanguageManager
import SmilesStorage

public class NetworkManager {
    var manager: Session!
    
    var serviceConfig: ServiceConfiguration?
    
    public init(requestTimeout: Double = 60) {
        NetworkConnectivity.shared.startNetworkReachabilityObserver()
        self.manager = self.getAlamofireManager(timeout: requestTimeout)
    }
    
    private func getAlamofireManager(timeout: Double) -> Session {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = timeout
        configuration.timeoutIntervalForRequest = timeout
       
        var alamofireManager = Alamofire.Session(configuration: configuration)
        
        if let isSSLEnabled: Bool = SmilesStorageHandler(storageType: .keychain).getValue(forKey: .SSLEnabled), isSSLEnabled {
            alamofireManager = Alamofire.Session(configuration: configuration, delegate: NetworkManagerSessionHandler())
        }
        
        return alamofireManager
    }
    
    
    public final func executeRequest<T: Codable>(for: T.Type = T.self, _ requestIdentifier: URLRequestConvertible?, successBlock: @escaping (AFResult<T>) -> (), failureBlock: @escaping (_ error: ErrorCodeConfiguration?) -> ()) {
        
        NetworkConnectivity.shared.startNetworkReachabilityObserver()
        if NetworkConnectivity.shared.currentStatus == .notReachable {
            let errorModel = ErrorCodeConfiguration()
            
            errorModel.errorDescriptionEn = SmilesLanguageManager.shared.getLocalizedString(for: "NoNet_Desc")
            errorModel.errorDescriptionAr = SmilesLanguageManager.shared.getLocalizedString(for: "NoNet_Desc")
            errorModel.errorCode = 503
            
            failureBlock(errorModel)
            return
        }else if NetworkConnectivity.shared.currentStatus == .unknown {
            let errorModel = ErrorCodeConfiguration()
            errorModel.errorDescriptionEn = SmilesLanguageManager.shared.getLocalizedString(for: "ServiceFail")
            errorModel.errorDescriptionAr = SmilesLanguageManager.shared.getLocalizedString(for: "ServiceFail")
            
            failureBlock(errorModel)
            return
        }else {
            self.manager.request(requestIdentifier!).debugLog().responseData { response in
                print("URL Request ====\n\(response.request?.url?.absoluteString ?? "")")
                
                print("Headers ====\n\(response.request?.headers ?? [])")
                
                print("Request ====\n\(String(data: response.request?.httpBody ?? Data.init(), encoding: .utf8) ?? "")")
                
                print("Response ====\n\(String(data: response.data ?? Data.init(), encoding: .utf8) ?? "")")
                
                print("play Service Response in networkManager,\(Date())")
                
                
                if let responseObject = response.response, responseObject.statusCode != 200 {
                    if let data = response.data {
                        if let errorResponse = try? JSONDecoder().decode(BaseMainResponse.self, from: data) {
                            let errorModel = ErrorCodeConfiguration()
                            errorModel.errorDescriptionEn = errorResponse.responseMsg ?? errorResponse.errorMsg
                            errorModel.errorDescriptionAr = errorResponse.responseMsg ?? errorResponse.errorMsg
                            if let errorNum = errorResponse.errorCode {
                                errorModel.errorCode = Int(errorNum) ?? 0
                            }
                            
                            failureBlock(errorModel)
                            
                            return
                        }
                    } else {
                        print("Data not found")
                    }
                    
                }
                
                // Automatic parsing mechanisim
                switch response.result {
                case .success:
                    
                    let decoder = JSONDecoder()
                    if let data = response.data {
                        if let baseResponse = try? decoder.decode(BaseMainResponse.self, from: data){
                            if let errorMsg = baseResponse.errorMsg, !errorMsg.isEmpty, let errorCode = baseResponse.errorCode, !errorCode.isEmpty {
                                let errorModel = ErrorCodeConfiguration()
                                errorModel.errorCode = Int(errorCode) ?? 0
                                errorModel.errorDescriptionEn = errorMsg
                                errorModel.errorDescriptionAr = errorMsg
                                failureBlock(errorModel)
                                
                            }
                            else{
                                do {
                                    try successBlock(.success(decoder.decode(T.self, from: data)))
                                }catch{
                                    print(error)
                                }
                                
                            }
                        }
                        else {
                            do{
                                try successBlock(.success(decoder.decode(T.self, from: data)))
                            }catch{
                                print(error)
                            }
                        }
                    }
                    
                case .failure(let error):
                    let errorModel = ErrorCodeConfiguration()
                    errorModel.errorCode = (error as NSError).code
                    errorModel.errorDescriptionEn = error.localizedDescription
                    errorModel.errorDescriptionAr = error.localizedDescription
                    
                    failureBlock(errorModel)
                }
            }
            
        }
    }
    
    public final func cancelRequest() {
        self.manager.cancelAllRequests()
    }
}

class NetworkManagerSessionHandler: SessionDelegate {
    
    override func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        guard let urlString = task.currentRequest?.url?.absoluteString, !urlString.contains("https://maps.googleapis.com/maps/api") else {
            completionHandler(.useCredential, nil)
            return
        }

        guard let trust = challenge.protectionSpace.serverTrust else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        let pinner = PublicKeyPinner.shared
        if pinner.validate(serverTrust: trust) {
            completionHandler(.useCredential, nil)
        } else {
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
        
    }
    
}
