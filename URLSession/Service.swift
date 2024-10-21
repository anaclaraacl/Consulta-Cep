import Foundation
import Alamofire

enum ServiceError: Error {
    case invalidURL
    case decodableFailure(Error)
    case networkError(Error?)
}

class Service {
    private let baseURL = "https://viacep.com.br/ws/"
    
    func searchZipCode(cep: String, callback: @escaping (Result<ZipCodeModel, ServiceError>) -> Void) {
        
        guard let url = URL(string: "\(baseURL)\(cep)/json/") else {
            callback(.failure(.invalidURL))
            return
        }
        
        AF.request(url).responseDecodable(of: ZipCodeModel.self) { response in
            if let error = response.error {
                callback(.failure(.networkError(error)))
                return
            }
            
            guard let zipCode = response.value else {
                if let data = response.data {
                    do {
                        let _ = try JSONDecoder().decode([String: String].self, from: data)
                    } catch {
                        callback(.failure(.decodableFailure(error)))
                        return
                    }
                }
                callback(.failure(.networkError(nil)))
                return
            }
            callback(.success(zipCode))
        }
    }
}
