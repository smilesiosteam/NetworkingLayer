//
//  File.swift
//  
//
//  Created by Hanan Ahmed on 9/6/22.
//

import Foundation
import Combine

public protocol Requestable {
    var requestTimeOut: Float { get }
    func request<T: BaseMainResponse>(_ req: NetworkRequest) -> AnyPublisher<T, NetworkError>
}
