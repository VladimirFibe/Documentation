import SwiftUI
import Security

func fetchDomains() async throws -> [Domain] {
    guard let url = URL(string: "https://api.raywenderlich.com/api/domains") else { return [] }
    let (data, _) = try await URLSession.shared.data(from: url)
    
    return try JSONDecoder().decode(Domains.self, from: data).data
}

// Asynchronous sequences.
func findTitle(url: URL) async throws -> String? {
    for try await line in url.lines {
        if line.contains("<title>") {
            return line.trimmingCharacters(in: .whitespaces)
        }
    }
    
    return nil
 }

//Task {
//    if let title = try await findTitle(url: URL(string: "https://www.raywenderlich.com")!) {
//        print(title)
//    } else {
//        print("что то не так")
//    }
//}
// Asynchronous properties.
extension Domains {
    static var domains: [Domain] {
        get async throws {
            try await fetchDomains()
        }
    }
}

//Task {
//    dump(try await Domains.domains)
//}

// Asynchronous subscripts.
extension Domains {
    enum Error: Swift.Error { case outOfRange }
    
    static subscript(_ index: Int) -> String {
        get async throws {
            let domains = try await Self.domains
            guard domains.indices.contains(index) else {
                throw Error.outOfRange
            }
            return domains[index].attributes.name
        }
    }
}

//Task {
//    dump(try await Domains[4])
//}

let favoritesPlayList = Playlist(title: "Favorite sonds", author: "Felipe", songs: ["In And Out Of Love"])
let partyPlayList = Playlist(title: "Party playlist", author: "Ray", songs: ["Hello"])
//
//Task {
//    await favoritesPlayList.move(song: "Hello", from: partyPlayList)
//    await favoritesPlayList.move(song: "In And Out Of Love", to: partyPlayList)
//    await print(favoritesPlayList.songs)
//    await print(partyPlayList.songs)
//}

let url = URL(string: "https://api.raywenderlich.com/api/domains")!
let session = URLSession.shared.dataTask(with: url) { data, _, _ in
    guard let data, let domain = try? JSONDecoder().decode(Domains.self, from: data).data.first
    else {
        print("Request failed")
        return
    }
    
    Task { @MainActor in
            print(domain)
            print(Thread.isMainThread)
    }
}

session.resume()

extension Domains {
    @MainActor func domainNames() -> [String] {
        print("Getting domain names in the main thread? \(Thread.isMainThread)")
        
        return data.map { $0.attributes.name}
    }
}

let session2 = URLSession.shared.dataTask(with: url) { data, _, _ in
    guard let data, let domains = try? JSONDecoder().decode(Domains.self, from: data)
    else {
        print("Request failed")
        return
    }
    Task {
        await print(domains.domainNames())
    }
}

session2.resume()
