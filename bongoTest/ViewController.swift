//
//  ViewController.swift
//  bongoTest
//
//  Created by Meadown on 29/10/21.
//

import UIKit
import SwiftSoup

class ViewController: UIViewController {
    
    //MARK: declaring outlets and variables
    @IBOutlet weak var resultTextView: UITextView!
    
    var htmlResponse = " "
    var dataString = " "
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: action for get result button
    @IBAction func getDatAction(_ sender: Any) {
        callAPI()
    }
    
    //MARK: getting and showing the data
    func callAPI(){
        var lastChar : Character?
        var charArray = [Character] ()
        var words = 0
        print ("API calling....")
        var request = URLRequest(url: URL(string: "https://www.bioscopelive.com/en/tos")!,timeoutInterval: Double.infinity)
        request.addValue("PHPSESSID=656eb7b0a4b630b324453ebe266fb7e4; device_view=full", forHTTPHeaderField: "Cookie")
        
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { [self] data, response, error in
            guard let data = data else {
                print(String(describing: error))
                
                return
            }
            let stringData = String(data: data, encoding: .utf8)!
            do {
                let doc: Document = try SwiftSoup.parse(stringData)
                let sectionTag : Element = try doc.select("section").first()!
                
                print("Here is ta data:\n\(try sectionTag.text())")
                
                lastChar = self.returnLastChar(data: try sectionTag.text())
                print("Last Character: \(lastChar!)")
                
                charArray = self.returnEveryTen(data: try sectionTag.text())
                print("Every 10th Character :\n \(charArray)")
                
                words = self.returnNumberOfWords(data:try sectionTag.text())
                print("Number of words in string: \(words)")
                
            } catch Exception.Error(type: let type, Message: let message)  {
                print( type , message )
            } catch {
                print ("error")
            }
            
            //MARK: SHOW in view
            DispatchQueue.main.async{
                self.resultTextView.text = "Last Character of the data\n \(lastChar!)\n\nEvery 10th Character \n(please scroll to see all data)\n\n \(String(charArray))\n\nNumber of words in string\n \(words)"
            }
            
        }
        
        task.resume()
        
    }
    
    //MARK: computing the last character
    func returnLastChar( data: String) -> Character{
        let result = data.last!
        return result
    }
    
    //MARK: computing every 10 character in string
    func returnEveryTen( data: String) -> [Character]{
        var result = [Character] ()
        let char = Array(data)
        for i in 0..<data.count{
            if i % 9 == 0 && i > 0 {
                // print (i)
                result.append("\t")
                result.append(char[i])
            }
        }
        return result
    }
    
    //MARK: computing the numbers of word
    func returnNumberOfWords( data: String) -> Int{
        var result = 0
        let components = data.components(separatedBy: .whitespacesAndNewlines)
        let words = components.filter { !$0.isEmpty }
        result = words.count
        return result
    }
    
}

