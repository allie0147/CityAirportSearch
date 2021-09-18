//
//  AirportHttpService.swift
//  CityAirportSearch
//
//  Created by Allie Kim on 2021/09/18.
//

import Alamofire

class AirportHttpService: HttpService {
    var sessionManager: Session = Session.default

    func request(_ urlReqeust: URLRequestConvertible) -> DataRequest {
        return sessionManager.request(urlReqeust)
            .validate(statusCode: 200..<400)
    }
}
