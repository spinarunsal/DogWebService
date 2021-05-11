//
//  DogAPI.swift
//  RandomDog_WebService
//
//  Created by Pinar Unsal on 2021-04-11.
//

import Foundation
import UIKit

class DogAPI {
    enum EndPoint {
        case randomImageFromAllDogsCollection
        case randomImageForBreed(String)
        case listAllBreeds
        
        var url: URL {
            return URL(string: self.stringValue)!
        }
        
        var stringValue: String {
            switch self {
            case .randomImageFromAllDogsCollection: return "https://dog.ceo/api/breeds/image/random"
            case .randomImageForBreed(let breed): return "https://dog.ceo/api/breed/\(breed)/images/random"
            case .listAllBreeds: return "https://dog.ceo/api/breeds/list/all"
            }
        }
    }
    
    class func requestBreedsList (completionHandler: @escaping ([String], Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: EndPoint.listAllBreeds.url) {
            (data, response, error) in
            guard let data = data else {
                completionHandler([], error)
                return
            }
            let decoder = JSONDecoder()
            let breedsResponse = try! decoder.decode(BreedListResponse.self, from: data)
            let breeds = breedsResponse.message.keys.map({$0})
            completionHandler(breeds,nil)
        }
        task.resume()
    
    }
    
    // helper method
    class func requestImageFile(url: URL, completionHandler: @escaping (UIImage?, Error?) -> Void){
        
        // create URLSessionDataTask to download the image
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            // convert downloaded image into a UIImage.
            let downloadedImage = UIImage(data: data)
            completionHandler(downloadedImage, nil)
        }
        task.resume()
    }
    
    class func requestRandomImage(breed: String, completionHandler: @escaping (DogImage?, Error?) -> Void){
        
        //MARK: Step1: URL for fetching a random image
        //EndPoint
        let randomImageEndPoint = DogAPI.EndPoint.randomImageForBreed(breed).url
        
        //MARK: Step2: Fetched a JSON response containing image's URL
        let task = URLSession.shared.dataTask(with: randomImageEndPoint) { (data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            
            //MARK: Step3: Parse the JSON using JSON DECODER
            //Codable protocol
            let decoder = JSONDecoder()
            let imageData = try! decoder.decode(DogImage.self, from: data)
            print(imageData)
            completionHandler(imageData, nil)
            //MARK: Step4: Loaded the image into imageView
            //create a constant that stores the message property of imageData. You'll need to convert it into a UR to make the request
            guard let imageURL = URL(string: imageData.message) else {
                print("Cannot create URL")
                return
            }
        }
        task.resume()
    }
}
