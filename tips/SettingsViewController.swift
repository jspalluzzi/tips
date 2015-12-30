//
//  SettingsViewController.swift
//  tips
//
//  Created by John Spalluzzi on 12/28/15.
//  Copyright © 2015 johns. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let sectionTitles = ["Tip Percentages", "Split Bill", "Dark Theme"];
    let tipPercentagesSettings = ["tip_percent_default", "tip_percent_min", "tip_percent_max"];
    let splitBillSettings = ["split_bill_max"]
    let themeSettings = ["dark_theme"]
    
    let settingsValueMaps = ["tip_percent_default":"Default", "tip_percent_min":"Minimum", "tip_percent_max":"Maximum", "split_bill_max":"Max Splits", "dark_theme":"Dark Theme"]
    
    var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var percentDefault: Int = Int()
    var percentMin: Int = Int()
    var percentMax: Int = Int()
    var revertValue: String = String()
    
    @IBOutlet weak var settingsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        percentDefault = defaults.integerForKey("tip_percent_default")
        percentMin = defaults.integerForKey("tip_percent_min")
        percentMax = defaults.integerForKey("tip_percent_max")
        
        settingsTableView.tableFooterView = UIView.init(frame: CGRectZero)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.checkAndChangeColors()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        
        return 3
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        
        return sectionTitles[section]
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if(section == 0){ return tipPercentagesSettings.count }
        else if(section == 1){ return splitBillSettings.count }
        else{ return themeSettings.count }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        if(indexPath.section == 2){
            let cell = settingsTableView.dequeueReusableCellWithIdentifier("switchCell", forIndexPath:  indexPath) as! SwitchCellTableViewCell
            cell.switchLabel.text = settingsValueMaps[themeSettings[indexPath.row]]
            cell.settingsSwitch.on = defaults.boolForKey("dark_theme")
            
            return cell
        }
        else{
            let cell = settingsTableView.dequeueReusableCellWithIdentifier("settingsCell", forIndexPath:  indexPath) as! SettingsTableViewCell
            let titleArray = indexPath.section == 0 ? tipPercentagesSettings : splitBillSettings
            
            cell.settingsTitleLabel.text = settingsValueMaps[titleArray[indexPath.row]]
            cell.valueTextField.text = String(defaults.integerForKey(titleArray[indexPath.row]))
            cell.valueTextField.restorationIdentifier = titleArray[indexPath.row]
            
            if(defaults.boolForKey("dark_theme")){
                cell.valueTextField.backgroundColor = UIColor.grayColor()
            }
            else{
                cell.valueTextField.backgroundColor = UIColor.whiteColor()
            }
            
            return cell
        }
        
    }
    
    // MARK: - IBActions
    
    @IBAction func valueEditingDidEnd(sender: UITextField) {
        
        let value = Int(sender.text!)
        if(value < 1){
            let alert = UIAlertController(title: "Invalid Value", message: "Value must be greater than 1", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated:true, completion:nil)
            sender.text = revertValue
            return
        }
        
        switch (sender.restorationIdentifier!) {
        case "tip_percent_default":
            
            if(value < percentMin){
                let alert = UIAlertController(title: "Invalid Value", message: "Default percent must be greater than minimum", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated:true, completion:nil)
                sender.text = String(percentDefault)
                return
            }
            if(value > percentMax){
                let alert = UIAlertController(title: "Invalid Value", message: "Default percent must be less than maximum", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated:true, completion:nil)
                return
            }
            
            percentDefault = value!
            
            break;
            
        case "tip_percent_min":
            
            if(value > percentDefault || value > percentMax){
                let alert = UIAlertController(title: "Invalid Value", message: "Minimum must be least value", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated:true, completion:nil)
                sender.text = String(percentMin)
                return
            }
            
            percentMin = value!
            
            break;
            
        case "tip_percent_max":
            
            if(value < percentMin || value < percentMin){
                let alert = UIAlertController(title: "Invalid Value", message: "Maximum must be greatest value", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated:true, completion:nil)
                sender.text = String(percentMax)
                return
            }
            
            percentMax = value!
            
            break;
            
        default:
            break;
        }
        
        defaults.setInteger(value!, forKey: sender.restorationIdentifier!)
        defaults.synchronize()
    }
    
    @IBAction func valueEditingDidBegin(sender: UITextField) {
        
        revertValue = sender.text!
        print(revertValue)
        
    }
    
    @IBAction func switchValueChanged(sender: UISwitch) {
        
        defaults.setBool(sender.on, forKey: "dark_theme")
        defaults.synchronize()
        
        self.checkAndChangeColors()
    }
    
    @IBAction func onTap(sender: AnyObject) {
        
        self.view.endEditing(true)
        
    }
    
    // Mark: - Theme Change
    
    func checkAndChangeColors(){
        
        if(defaults.boolForKey("dark_theme")){
            UIView.animateWithDuration(0.5, animations: {
                self.view.backgroundColor = UIColor.darkGrayColor()
            })
        }
        else{
            UIView.animateWithDuration(0.5, animations: {
                self.view.backgroundColor = UIColor.groupTableViewBackgroundColor()
            })
        }
        
        settingsTableView.reloadData()
        
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
