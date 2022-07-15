//
//  ContentView.swift
//  InfoVkApp
//
//  Created by Кирилл Санников on 15.07.2022.
//

import SwiftUI

struct Welcome: Codable {
    let body: Body
    let status: Int
    
    static let data: Welcome = Bundle.main.decode(file: "result.json")
}

struct Body: Codable {
    let services: [Service]
}

struct Service: Codable {
    let name, serviceDescription: String
    let link: String
    let iconURL: String

    enum CodingKeys: String, CodingKey {
        case name
        case serviceDescription = "description"
        case link
        case iconURL = "icon_url"
    }
}

extension Bundle {
    func decode(file: String) -> Welcome {
        guard let url = Bundle.main.url(forResource: file, withExtension: nil) else {
            fatalError("Could not find \(file) in bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Could not load \(file) from bundle.")
        }
        
        let decoder = JSONDecoder()
        
        guard let loadedData = try? decoder.decode(Welcome.self, from: data) else {
            fatalError("Could not decode \(file) from bundle.")
        }
        
        return loadedData
    }
}

extension String {
    func load() -> UIImage {
        
        do {
            guard let url = URL(string: self) else {
                return UIImage()
            }
            let data: Data = try Data(contentsOf: url)
            return UIImage(data: data) ?? UIImage()
        } catch {
            
        }
        
        return UIImage()
    }
}

struct ContentView: View {
    let services: [Service] = Welcome.data.body.services
    
    var body: some View {
        NavigationView {
            List {
                ForEach(services, id: \.name) { service in
                    NavigationLink(destination: Link("\(service.name)", destination: URL(string: service.link)!)) {
                        VStack(alignment: .leading) {
                            Image(uiImage: service.iconURL.load()).resizable().aspectRatio(contentMode: .fit).frame(width: 50.0, height: 50.0)
                            Text("\(service.name)").bold()
                            Text("\(service.serviceDescription)").foregroundColor(.gray)
                            
                        }
                    }.padding()
                }
            }.navigationTitle("Apps")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
