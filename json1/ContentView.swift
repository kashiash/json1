//
//  ContentView.swift
//  json1
//
//  Created by Jacek Placek on 19/06/2022.
//
import Combine
import SwiftUI

struct User: Decodable {
    var id: UUID
    var name: String

    static let `default` = User(id: UUID(), name: "Anonymous")
}
struct ContentView: View {
    @State private var requests = Set<AnyCancellable>()
    
    var body: some View {
        Button("Fetch Data") {
            let url = URL(string: "https://www.hackingwithswift.com/samples/user-24601.json")!
            self.fetch(url, defaultValue: User.default) {
                print($0.name)
                
                
                
                
            }
        }
    }
    
//    func fetch(_ url: URL) {
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error = error {
//                print(User.default.name)
//            } else if let data = data {
//                let decoder = JSONDecoder()
//
//                do {
//                    let user = try decoder.decode(User.self, from: data)
//                    print(user.name)
//                } catch {
//                    print(User.default.name)
//                }
//            }
//        }.resume()
//    }
    
    
//    func fetch(_ url: URL) {
//        let decoder = JSONDecoder()
//
//
//        URLSession.shared.dataTaskPublisher(for: url)
//            .map(\.data)
//            .decode(type: User.self, decoder: decoder)
//            .replaceError(with: User.default)
//            .sink(receiveValue: { print($0.name) })
//            .store(in: &requests)
//    }
    
    func fetch<T: Decodable>(_ url: URL, defaultValue: T, completion: @escaping (T) -> Void) {
        let decoder = JSONDecoder()

        URLSession.shared.dataTaskPublisher(for: url)
            .retry(1)
            .map(\.data)
            .decode(type: T.self, decoder: decoder)
            .replaceError(with: defaultValue)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: completion)
            .store(in: &requests)
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
