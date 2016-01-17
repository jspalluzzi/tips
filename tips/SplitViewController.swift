//
//  SplitViewController.swift
//  tips
//
//  Created by John Spalluzzi on 1/14/16.
//  Copyright © 2016 johns. All rights reserved.
//

import UIKit

class SplitViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var splitTotalTableView: UITableView!
    @IBOutlet weak var totalLabel: UILabel!
    
    var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var numOfSplits: Int = Int()
    var currentTotal:Double = Double()
    
    var defalutRed = 102.0/255.0
    var defaultGreen = 255.0/255.0
    var defaultBlue = 255.0/255.0
    
    let formatter = NSNumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        formatter.numberStyle = .CurrencyStyle
        
        splitTotalTableView.tableFooterView = UIView.init(frame: CGRectZero)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        currentTotal = defaults.doubleForKey("current_total_value")
        totalLabel.text = formatter.stringFromNumber(currentTotal)!
        numOfSplits = defaults.integerForKey("split_bill_max")
        splitTotalTableView.reloadData()
        
        //check if dark theme enabled
        if(defaults.boolForKey("dark_theme")){
            self.changeThemeColorDark()
        }
        else{
            self.changeThemeColorLight()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(numOfSplits == 1){
            return 1
        }
        else{
            return numOfSplits - 1
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = splitTotalTableView.dequeueReusableCellWithIdentifier("splitCell", forIndexPath:  indexPath) as! SplitTotalTableViewCell
        
        let numOfPeopleAtIndex = indexPath.row + 2
        let pricePerPerson = currentTotal/Double(numOfPeopleAtIndex)
        cell.personCountLabel.text = String(numOfPeopleAtIndex)
        cell.pricePerLabel.text = formatter.stringFromNumber(pricePerPerson)! + "/person"
        
        return cell
        
    }

    // MARK: - Theme Functions
    
    func changeThemeColorDark(){
        
        UIView.animateWithDuration(0.5, animations: {
            
            let red = CGFloat(self.defalutRed * 0.25)
            let green = CGFloat(self.defaultGreen * 0.25)
            let blue = CGFloat(self.defaultBlue * 0.25)
            
            self.view.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
        })
        
    }
    
    func changeThemeColorLight(){
        
        UIView.animateWithDuration(0.5, animations: {
            
            let red = CGFloat(self.defalutRed)
            let green = CGFloat(self.defaultGreen)
            let blue = CGFloat(self.defaultBlue)
            
            self.view.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
        })
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
