import Foundation

enum ServiceError: Error {
    case InvalidURL
    case DecodableFailure(Error)
    case networkError(Error?)
}

class Service {
    private let baseURL = "https://viacep.com.br/ws/"
    
    func searchZipCode(with zipCode: String, callback: @escaping (Result<ZipCodeModel, ServiceError>) -> Void){
        
        let path = "\(zipCode)/json"
        
        guard let url = URL(string: baseURL + path) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                callback(.failure(.networkError(error)))
                return
            }
            
            do {
                let adress = try JSONDecoder().decode(ZipCodeModel.self, from: data)
                callback(.success(adress))
            } catch {
                callback(.failure(.DecodableFailure(error)))
            }
        }
        task.resume()
    }
}
