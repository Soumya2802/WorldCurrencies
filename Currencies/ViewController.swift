//
//  ViewController.swift
//  Currencies
//
//  Created by Soumya Ammu on 12/1/21.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate {
    @IBOutlet weak var searchCurrencies: UISearchBar!
    
    @IBOutlet weak var currenciesTable: UITableView!
    
    //Network call response is assigned to table data
    var tableData:APICallResult?
    
    //Filtered data is used for showing the filtered data
    //Network call data is not altered as the main data should remain same.
    //All the alteration is been done in filtered data.
    var filteredData = APICallResult.init(data: [])
    
    
    
    //Table View Implementation
    
    //numberOfSections
    
    func numberOfSections(in tableView: UITableView) -> Int {
        filteredData.data.count
    }
    
    //numberOfRowsInSection
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    //cellForRowAt
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = filteredData.data[indexPath.section].name
        return cell
    }
    
    //titleForHeaderInSection
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return filteredData.data[section].id
    }
    
    //heightForHeaderInSection
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    //heightForRowAt
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    
    // search bar implementation
    
    //textDidChange
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredData.data.removeAll()
        
        //Filter data from "tabledata" which has "searchText".
        for i in 0..<(tableData?.data.count ?? -1){
            if tableData?.data[i] != nil &&  tableData!.data[i].name.lowercased().contains(searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)){
                filteredData.data.insert(tableData?.data[i] ?? APICallData.init(), at: filteredData.data.count)
                    
                    //.append(contentsOf: tableData?.data[i] ?? [APICallData.init()])
            }
        
        }
        
        // if text is cleared filtered data is assigned with "tabledata" . the original data we got from network call
        if searchText == ""{
            filteredData = tableData ?? APICallResult.init(data: [])
        }
        
        //reloading the currency table to update filtered data
        currenciesTable.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        //function to call API and retrieve the data
        setUpHomePage()
    }
    
    func setUpHomePage(){
        //Network Call From APICall Class
        let networkCalls = APICall()
        tableData = networkCalls.HTTP_Request(url: "https://api.coinbase.com/v2/currencies")
        
        // assigning the network data to filtered data for display
        filteredData = tableData ?? APICallResult.init(data: [])
       
        //reload the currency table
        currenciesTable.reloadData()
    }

}

