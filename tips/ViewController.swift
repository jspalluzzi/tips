//
//  ViewController.swift
//  tips
//
//  Created by John Spalluzzi on 12/28/15.
//  Copyright © 2015 johns. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    var numOfSplits: Int = Int()
    var currentTotal: Double = Double()
    let formatter = NSNumberFormatter()
    
    @IBOutlet weak var billField: UITextField!
    
    @IBOutlet weak var tipPercentLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var btnOne: UIButton!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        formatter.numberStyle = .CurrencyStyle
        
        totalLabel.text = formatter.stringFromNumber(0)
        tipPercentLabel.text = "20"
        
        numOfSplits = defaults.integerForKey("split_bill_max")
        
        if(defaults.doubleForKey("last_saved_value") != 0.0){
            billField.text = String(format: "%.2f", defaults.doubleForKey("last_saved_value"))
        }
        //billField.becomeFirstResponder()
        
        btnOne.layer.borderWidth = 1
        btnOne.layer.borderColor = UIColor.redColor().CGColor
        btnOne.layer.cornerRadius = btnOne.frame.size.width/4
        btnOne.clipsToBounds = true
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        numOfSplits = defaults.integerForKey("split_bill_max")
//        tipPercentSlider.minimumValue = Float(defaults.integerForKey("tip_percent_min"))
//        tipPercentSlider.maximumValue = Float(defaults.integerForKey("tip_percent_max"))
//        tipPercentSlider.value = Float(defaults.integerForKey("tip_percent_default"))
//        tipPercentLabel.text = String(Int(tipPercentSlider.value)) + "%"
//        tipPercentSlider.reloadInputViews()
        
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
        
        let tipPercentage = 20.0 //Double(tipPercentSlider.value) / 100.0
        
        var billAmount = Double(billField.text!)
        if(billAmount == nil) {billAmount = 0.0}
        
        let tip = billAmount! * tipPercentage
        let total = billAmount! + tip;
        
        //tipLabel.text = formatter.stringFromNumber(tip)
        totalLabel.text = formatter.stringFromNumber(total)
        
        defaults.setDouble(billAmount!, forKey: "last_saved_value")
        currentTotal = total
    }
    
    @IBAction func onSliderChanged(sender: AnyObject) {
        
        //modify tip percentage lable
        //tipPercentLabel.text = String(Int(tipPercentSlider.value)) + "%"
        
        //update values
        //self.onEditingChanged(tipPercentSlider)
    }
    
    
    
    @IBAction func onTap(sender: AnyObject) {
        
        view.endEditing(true)
        
    }
    
    
    
    // MARK: - Theme Functions
    
    func changeThemeColorDark(){
        
        UIView.animateWithDuration(0.5, animations: {
            //self.view.backgroundColor = UIColor.darkGrayColor()
        })
        
    }
    
    func changeThemeColorLight(){
        
        UIView.animateWithDuration(0.5, animations: {
            //self.view.backgroundColor = UIColor.init(red: 179/225, green: 179/225, blue: 179/225, alpha: 1)
        })
        
    }
    
    

}

