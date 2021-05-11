//
//  CodeBeforeRefractor.swift
//  RandomDog_WebService
//
//  Created by Pinar Unsal on 2021-04-11.
//

import Foundation
import UIKit

class CodeBeforeRefractor: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: Step1: URL for fetching a random image
        //EndPoint
        let randomImageEndPoint = DogAPI.EndPoint.randomImageFromAllDogsCollection.url
        //MARK: Step2: Fetched a JSON response containing image's URL
        let task = URLSession.shared.dataTask(with: randomImageEndPoint) { (data, response, error) in
            guard let data = data else {
                return
            }
            //print(data)
            //MARK: Step3: Parse the JSON using JSON DECODER
            //Codable protocol
            let decoder = JSONDecoder()
            let imageData = try! decoder.decode(DogImage.self, from: data)
            print(imageData)

            //MARK: Step4: Loaded the image into imageView
            //create a constant that stores the message property of imageData. You'll need to convert it into a UR to make the request
            guard let imageURL = URL(string: imageData.message) else {
                print("Cannot create URL")
                return
            }
            // create URLSessionDataTask to download the image
            let task = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
                guard let data = data else {
                    print("location is nil")
                    return
                }
               // convert downloaded image into a UIImage.
                let image = UIImage(data: data)
                // set the image view to display this image. Be sure to use main thread
                DispatchQueue.main.sync {
                    self.imageView.image = image
                }
            }
            //Populate the data
            task.resume()

//            //Parsing with JSONSerialization
//            do {
//                let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
//                let url = json["message"] as! String
//                print(url)
//            } catch {
//                print(error)
//            }
        }
        //MARK: Step5: Populate the imageview
        task.resume()
    }


}
