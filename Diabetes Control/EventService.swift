import UIKit
import Alamofire

class EventService {
    
    var url = "http://localhost:8080/"
    
    func getAllEvents(completion: @escaping (Result<[Event], Error>) -> ()) {
        var request = URLRequest(url: URL(string: "http://localhost:8080/events")!)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        AF.request(request).validate(statusCode: 200..<300).responseJSON { response in
            if let err = response.error {
                completion(.failure(err))
                return
            }
            
            do {
                let events = try JSONDecoder().decode([Event].self, from: response.data!)
                completion(.success(events))
                } catch let jsonError {
                completion(.failure(jsonError))
            }
        }.resume()
    }
    
    func createEvent(event: Event, completion: @escaping (Result<Int, Error>) -> ()) {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(event)
        var request = URLRequest(url: URL(string: "http://localhost:8080/addEvent")!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        AF.request(request).validate(statusCode: 200..<300).responseJSON { response in
            if let err = response.error {
                completion(.failure(err))
                return
            }
            completion(.success(1))
        }.resume()
    }
    
    
    func createEvents(event: [EventItem], completion: @escaping (Result<Int, Error>) -> ()) {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(event)
        var request = URLRequest(url: URL(string: "http://localhost:8080/addEvents")!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        AF.request(request).validate(statusCode: 200..<300).responseJSON { response in
            if let err = response.error {
                completion(.failure(err))
                return
            }
            completion(.success(1))
        }.resume()
    }
    
    
    
    func updateEvent(id: Int, event: Event, completion: @escaping (Result<Int, Error>) -> ()) {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(event)
        var request = URLRequest(url: URL(string: "http://localhost:8080/update/" + String(id))!)
        request.httpMethod = HTTPMethod.put.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        AF.request(request).validate(statusCode: 200..<300).responseJSON { response in
            if let err = response.error {
                completion(.failure(err))
                return
            }
            completion(.success(1))
        }.resume()
    }
    
    func deleteEvent(id: Int, completion: @escaping (Result<Int, Error>) -> ()) {
        var request = URLRequest(url: URL(string: "http://localhost:8080/delete/" + String(id))!)
        request.httpMethod = HTTPMethod.delete.rawValue
        AF.request(request).validate(statusCode: 200..<300).responseJSON { response in
            if let err = response.error {
                completion(.failure(err))
                print("chegou aqui")
                return
            }
            completion(.success(1))
        }.resume()
    }
    
    func deleteAllEvents(completion: @escaping (Result<Int, Error>) -> ()) {
        var request = URLRequest(url: URL(string: "http://localhost:8080/deleteAll/")!)
        request.httpMethod = HTTPMethod.delete.rawValue
        AF.request(request).validate(statusCode: 200..<300).responseJSON { response in
            if let err = response.error {
                completion(.failure(err))
                print("chegou aqui")
                return
            }
            completion(.success(1))
        }.resume()
    }
}

