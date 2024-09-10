import Foundation

protocol DataRepositoryProtocol {
    func fetchData(from urlString: String, completion: @escaping (Result<[Country], Error>) -> Void)
}

class DataRepository: DataRepositoryProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    func fetchData(from urlString: String, completion: @escaping (Result<[Country], Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }

        networkService.fetchData(from: url) { result in
            completion(result)
        }
    }
}
