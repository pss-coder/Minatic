//
//  EmailService.swift
//  Minatic
//
//  Created by Pawandeep Singh on 20/8/22.
//

import Foundation

class EmailService {
    
   
    
    static func sendEmail(email: String, completion: @escaping (Result<Data, Error>)->Void) async {
        
        //1. Encode data
        let body: [String: Any] = ["data": ["to": email, "message": "Hello from Minatic App"]]
        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        
        // create post request
        let url = URL(string: "https://inlaid-fx-359020.as.r.appspot.com/")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = jsonData
        
        // call request
        URLSession.shared.dataTask(with: request) { data, response, error in
            print("---- data: \(data!)" )
            print("---- reponse: \(response!)" )
            print("---- error: \(error)" )
            
            guard let data = data, error == nil else {
                            print(error?.localizedDescription ?? "No data")
                            return
                        }

                        let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                        print("-----1> responseJSON: \(responseJSON)")
                        if let responseJSON = responseJSON as? [String: Any] {
                            print("-----2> responseJSON: \(responseJSON)")
                        }
        }.resume()
        
        
//        do {
//
//
//
//            let (data, _ ) = try await URLSession.shared.upload(for: request, from: jsonData)
//
//            DispatchQueue.main.async {
//                completion(.success(data))
//            }
//
//            // handle result
//        } catch {
//            //print("email failed to sent")
//            DispatchQueue.main.async {
//                completion(.failure(error))
//            }
//        } // end catch
    }
}


