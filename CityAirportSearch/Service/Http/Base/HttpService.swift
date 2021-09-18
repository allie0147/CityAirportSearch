//
//  HttpService.swift
//  CityAirportSearch
//
//  Created by Allie Kim on 2021/09/18.
//

import Alamofire

/// Session and Request
protocol HttpService {
    var sessionManager: Session { get set }
    func request(_ urlReqeust: URLRequestConvertible) -> DataRequest
}
