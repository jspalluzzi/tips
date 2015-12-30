//
//  ViewController.swift
//  tips
//
//  Created by John Spalluzzi on 12/28/15.
//  Copyright © 2015 johns. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    var numOfSplits: Int = Int()
    var currentTotal: Double = Double()
    let formatter = NSNumberFormatter()
    
    @IBOutlet weak var billField: UITextField!
    
    @IBOutlet weak var tipPercentLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var tipPercentSlider: UISlider!

    @IBOutlet weak var splitTotalSwitch: UISwitch!
    
    @IBOutlet weak var dividerView: UIView!
    
    @IBOutlet weak var splitTotalTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        formatter.numberStyle = .CurrencyStyle
        
        tipLabel.text = formatter.stringFromNumber(0)
        totalLabel.text = formatter.stringFromNumber(0)
        tipPercentLabel.text = "20%"
        
        numOfSplits = defaults.integerForKey("split_bill_max")
        
        splitTotalTableView.contentInset = UIEdgeInsets(top: self.view.bounds.height, left: 0, bottom: 0, right: 0)
        splitTotalTableView.hidden = true
        splitTotalTableView.tableFooterView = UIView.init(frame: CGRectZero)
        
        if(defaults.doubleForKey("last_saved_value") != 0.0){
            billField.text = String(format: "%.2f", defaults.doubleForKey("last_saved_value"))
        }
        billField.becomeFirstResponder()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        numOfSplits = defaults.integerForKey("split_bill_max")
        tipPercentSlider.minimumValue = Float(defaults.integerForKey("tip_percent_min"))
        tipPercentSlider.maximumValue = Float(defaults.integerForKey("tip_percent_max"))
        tipPercentSlider.value = Float(defaults.integerForKey("tip_percent_default"))
        tipPercentLabel.text = String(Int(tipPercentSlider.value)) + "%"
        tipPercentSlider.reloadInputViews()
        
        //check if dark theme enabled
        if(defaults.boolForKey("dark_theme")){
            self.changeThemeColorDark()
        }
        else{
            self.changeThemeColorLight()
        }
        
        self.onEditingChanged(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: IBActions

    @IBAction func onEditingChanged(sender: AnyObject) {
        
        let tipPercentage = Double(tipPercentSlider.value) / 100.0
        
        var billAmount = Double(billField.text!)
        if(billAmount == nil) {billAmount = 0.0}
        
        let tip = billAmount! * tipPercentage
        let total = billAmount! + tip;
        
        tipLabel.text = formatter.stringFromNumber(tip)
        totalLabel.text = formatter.stringFromNumber(total)
        
        defaults.setDouble(billAmount!, forKey: "last_saved_value")
        currentTotal = total
        splitTotalTableView.reloadData()
    }
    
    @IBAction func onSliderChanged(sender: AnyObject) {
        
        //modify tip percentage lable
        tipPercentLabel.text = String(Int(tipPercentSlider.value)) + "%"
        
        //update values
        self.onEditingChanged(tipPercentSlider)
    }
    
    
    @IBAction func switchValueChanged(sender: AnyObject) {
        
        view.endEditing(true)
        
        if(splitTotalSwitch.on){
            UIView.animateWithDuration(0.5, animations: {
                self.dividerView.alpha = 1
                self.splitTotalTableView.hidden = false
                self.splitTotalTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            })
        }
        else{
            UIView.animateWithDuration(1, animations: {
                self.splitTotalTableView.contentInset = UIEdgeInsets(top: self.view.bounds.height, left: 0, bottom: 0, right: 0)
                self.splitTotalTableView.hidden = true
                self.dividerView.alpha = 0.1
            })
        }
        
    }
    
    
    @IBAction func onTap(sender: AnyObject) {
        
        view.endEditing(true)
        
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if(numOfSplits == 1){
            return 1
        }
        else{
            return numOfSplits - 1
        }
        
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
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
            self.view.backgroundColor = UIColor.darkGrayColor()
            self.dividerView.backgroundColor = UIColor.init(red: 55/225, green: 55/225, blue: 55/225, alpha: 1)
        })
        
    }
    
    func changeThemeColorLight(){
        
        UIView.animateWithDuration(0.5, animations: {
            self.view.backgroundColor = UIColor.init(red: 179/225, green: 179/225, blue: 179/225, alpha: 1)
            self.dividerView.backgroundColor = UIColor.init(red: 127/225, green: 127/225, blue: 127/225, alpha: 1)
        })
        
    }
    
    

}

