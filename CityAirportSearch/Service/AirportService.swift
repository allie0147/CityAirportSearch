//
//  AirportService.swift
//  CityAirportSearch
//
//  Created by Allie Kim on 2021/09/18.
//

import RxSwift
import Alamofire

class AirportService {
    private lazy var httpService = AirportHttpService()
    static let shared: AirportService = AirportService()
}

extension AirportService: AirportAPI {
    func fetchAirports() -> Single<AirportsResponse> {

        return Single.create { single -> Disposable in
            do {
                try AirportHttpRouter.getAirports
                    .request(usingHttpService: self.httpService)
                    .responseJSON { result in

                    do {
                        let airports = try AirportService.parseAirports(result: result)
                        single(.success(airports))
                    }
                    catch {
                        single(.failure(error))
                    }
                }
            }
            catch {
                single(.failure(CustomError.error(message: "Airport Fetch Failed")))
            }
            return Disposables.create()
        }
    }
}
extension AirportService {
    static func parseAirports(result: AFDataResponse<Any>) throws -> AirportsResponse {
        guard let data = result.data,
            let airportResponse = try? JSONDecoder().decode(AirportsResponse.self, from: data) else { throw CustomError.error(message: "Invalid Airport JSON") }
        return airportResponse
    }
}
