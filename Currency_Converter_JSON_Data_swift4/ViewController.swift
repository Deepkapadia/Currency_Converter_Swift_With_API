//
//  ViewController.swift
//  Currency_Converter_JSON_Data_swift4
//
//  Created by DeEp KapaDia on 25/05/18.
//  Copyright © 2018 DeEp KapaDia. All rights reserved.
//

import UIKit


struct Currency : Decodable{
    
    let base : String
    let date : String
    let rates : [String:Double]
    
}

class ViewController: UIViewController ,UITableViewDataSource{

    @IBOutlet weak var ConversionTableView: UITableView!
    @IBOutlet weak var RAteField: UITextField!
    
    var USD:Currency?
    
    var baserate = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ConversionTableView.dataSource = self
        
        ConversionTableView.allowsSelection = false
        
        ConversionTableView.showsVerticalScrollIndicator = false
        
        RAteField.textAlignment = .center
        
        fatchdata()
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let currencyfetch = USD{
            
            return currencyfetch.rates.count
            
        }
        return 0
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
       return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        
        if let currenctfatched = USD {
            
            cell.textLabel?.text = Array(currenctfatched.rates.keys)[indexPath.row]
        
            let selectedrates = baserate *  Array(currenctfatched.rates.values)[indexPath.row]
            
            cell.detailTextLabel?.text = "\(selectedrates)"
            return cell
            
        }
        
        return UITableViewCell()
    }
    
    

    @IBAction func ConvertBTN(_ sender: UIButton) {
        
        if let getString = RAteField.text{
            
            if let sDouble = Double(getString){
                
                baserate = sDouble
                
                fatchdata()
                
            }
            
        }
        
        
        
    }
    
    
    func fatchdata(){
        
        let url = URL(string: "https://api.fixer.io/latest?base=USD")
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error == nil
            {
                do {
                
                    self.USD = try JSONDecoder().decode(Currency.self, from: data!)
                
                }catch{
                    print("Parse Error")
                }
                
                DispatchQueue.main.async {
                    
                    self.ConversionTableView.reloadData()
                }
                
                
            }else{
                
                print("error")
            }
            
        }.resume()
        
    }

}

