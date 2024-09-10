import Foundation

enum APIs {
    static let base = "https://api.sampleapis.com/"
    static let country = "https://api.sampleapis.com/countries/countries"
}

protocol NetworkServiceProtocol {
    func fetchData(from url: URL, completion: @escaping (Result<[Country], Error>) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    func fetchData(from url: URL, completion: @escaping (Result<[Country], Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completion(.failure(error!))
                return
            }

            let decoder = JSONDecoder()
            do {
              let countries = try decoder.decode([Country].self, from: data)
                completion(.success(countries))
            } catch {
              print("Error decoding JSON:", error)
                completion(.failure(error))
            }
            
        }.resume()
    }
}
