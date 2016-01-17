//
//  ViewController.swift
//  tips
//
//  Created by John Spalluzzi on 12/28/15.
//  Copyright © 2015 johns. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITabBarDelegate {
    
    var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var currentTotal: Double = Double()
    var panThreshhold: CGFloat = CGFloat()
    var oldTranslation: CGPoint = CGPoint()
    
    var defalutRed = 102.0/255.0
    var defaultGreen = 255.0/255.0
    var defaultBlue = 255.0/255.0
    
    let formatter = NSNumberFormatter()
    
    @IBOutlet weak var billField: UILabel!
    @IBOutlet weak var tipPercentLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var topDiv: UIView!
    @IBOutlet weak var dividerDiv: UIView!
    
    //number pad buttons
    @IBOutlet weak var btnOne: UIButton!
    @IBOutlet weak var btnTwo: UIButton!
    @IBOutlet weak var btnThree: UIButton!
    @IBOutlet weak var btnFour: UIButton!
    @IBOutlet weak var btnFive: UIButton!
    @IBOutlet weak var btnSix: UIButton!
    @IBOutlet weak var btnSeven: UIButton!
    @IBOutlet weak var btnEight: UIButton!
    @IBOutlet weak var btnNine: UIButton!
    @IBOutlet weak var btnZero: UIButton!
    @IBOutlet weak var btnClear: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        panThreshhold = self.view.frame.size.width * 0.05
        print("panThreshold: " + String(panThreshhold))
        
        formatter.numberStyle = .CurrencyStyle
        
        totalLabel.text = formatter.stringFromNumber(0)
        tipPercentLabel.text = String(defaults.integerForKey("tip_percent_default"))
        
        if(defaults.doubleForKey("last_saved_value") != 0.0){
            print("last_saved_value: " + String(defaults.doubleForKey("last_saved_value")))
            billField.text = String(format: "$%.2f", defaults.doubleForKey("last_saved_value"))
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //check if dark theme enabled
        if(defaults.boolForKey("dark_theme")){
            self.changeThemeColorDark()
        }
        else{
            self.changeThemeColorLight()
        }
        
        self.configureButtonBoarders()
        
        self.onEditingChanged()
    }
    
    func configureButtonBoarders (){
        
        let borderWidth = CGFloat(1)
        let borderColor = UIColor.whiteColor().CGColor
        let cornerRadius = btnOne.frame.size.width/4
        let clipsToBounds = true
        
        btnOne.layer.borderWidth = borderWidth
        btnOne.layer.borderColor = borderColor
        btnOne.layer.cornerRadius = cornerRadius
        btnOne.clipsToBounds = clipsToBounds
        
        btnTwo.layer.borderWidth = borderWidth
        btnTwo.layer.borderColor = borderColor
        btnTwo.layer.cornerRadius = cornerRadius
        btnTwo.clipsToBounds = clipsToBounds
        
        btnThree.layer.borderWidth = borderWidth
        btnThree.layer.borderColor = borderColor
        btnThree.layer.cornerRadius = cornerRadius
        btnThree.clipsToBounds = clipsToBounds
        
        btnFour.layer.borderWidth = borderWidth
        btnFour.layer.borderColor = borderColor
        btnFour.layer.cornerRadius = cornerRadius
        btnFour.clipsToBounds = clipsToBounds
        
        btnFive.layer.borderWidth = borderWidth
        btnFive.layer.borderColor = borderColor
        btnFive.layer.cornerRadius = cornerRadius
        btnFive.clipsToBounds = clipsToBounds
        
        btnSix.layer.borderWidth = borderWidth
        btnSix.layer.borderColor = borderColor
        btnSix.layer.cornerRadius = cornerRadius
        btnSix.clipsToBounds = clipsToBounds
        
        btnSeven.layer.borderWidth = borderWidth
        btnSeven.layer.borderColor = borderColor
        btnSeven.layer.cornerRadius = cornerRadius
        btnSeven.clipsToBounds = clipsToBounds
        
        btnEight.layer.borderWidth = borderWidth
        btnEight.layer.borderColor = borderColor
        btnEight.layer.cornerRadius = cornerRadius
        btnEight.clipsToBounds = clipsToBounds
        
        btnNine.layer.borderWidth = borderWidth
        btnNine.layer.borderColor = borderColor
        btnNine.layer.cornerRadius = cornerRadius
        btnNine.clipsToBounds = clipsToBounds
        
        btnZero.layer.borderWidth = borderWidth
        btnZero.layer.borderColor = borderColor
        btnZero.layer.cornerRadius = cornerRadius
        btnZero.clipsToBounds = clipsToBounds
        
        btnClear.layer.borderWidth = borderWidth
        btnClear.layer.borderColor = borderColor
        btnClear.layer.cornerRadius = cornerRadius
        btnClear.clipsToBounds = clipsToBounds
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    // MARK: IBActions (non-numeral buttons)

    func onEditingChanged() {
        
        let tipPercentage = Double(tipPercentLabel.text!)!/100.0
        
        // add decimal point
        billField.text = billField.text?.stringByReplacingOccurrencesOfString(".", withString: "")
        if(billField.text?.characters.count == 2){
            let index = billField.text?.endIndex.advancedBy(-1)
            var newString = billField.text
            newString?.insert(".", atIndex: index!)
            billField.text = newString
        }else if(billField.text?.characters.count > 2){
            let index = billField.text?.endIndex.advancedBy(-2)
            var newString = billField.text
            newString?.insert(".", atIndex: index!)
            billField.text = newString
        }
        
        let billString = String(billField.text!.characters.dropFirst())
        var billAmount = Double(billString)
        
        if(billAmount == nil) {
            billAmount = 0.0
            billField.text = "$"
        }
        
        let tip = billAmount! * tipPercentage
        let total = billAmount! + tip;
        
        totalLabel.text = formatter.stringFromNumber(total)
        
        defaults.setDouble(billAmount!, forKey: "last_saved_value")
        defaults.setDouble(total, forKey: "current_total_value")
        currentTotal = total
    }
    
    
    // MARK: - UIGestures
    
    @IBAction func onTap(sender: AnyObject) {
        
        view.endEditing(true)
        
    }
    
    @IBAction func onPanGesture(recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translationInView(self.view)
        var increasing: Bool = Bool()
        
        let percentMax = defaults.integerForKey("tip_percent_max")
        let percentMin = defaults.integerForKey("tip_percent_min")
        let currentTip = Int(tipPercentLabel.text!)
        
        if(recognizer.state == UIGestureRecognizerState.Began){
            oldTranslation = translation
        }
        
        if(recognizer.state == UIGestureRecognizerState.Changed){
            
            if(translation.x < oldTranslation.x){
                increasing = false
            }else{
                increasing = true
            }
            
            let difference = abs(translation.x - oldTranslation.x)
            let tippercent = Int(tipPercentLabel.text!)
            if(difference > panThreshhold){
                if(increasing && currentTip < percentMax){
                    tipPercentLabel.text = String(tippercent!+1)
                }else if(currentTip > percentMin){
                    tipPercentLabel.text = String(tippercent!-1)
                }
                oldTranslation = translation
                
                self.onEditingChanged()
                //self.changeTopDivBgColor()
            }
        }
    }
    
    func changeTopDivBgColor(){
        
        let currentTip = Int(tipPercentLabel.text!)
        let defaultTip = defaults.integerForKey("tip_percent_default")
        
        if(currentTip == defaultTip){
            UIView.animateWithDuration(0.5, animations: {
                self.topDiv.backgroundColor = UIColor.whiteColor()
            })
        }else{
            UIView.animateWithDuration(0.5, animations: {
                let currentTip = Int(self.tipPercentLabel.text!)
                let defaultTip = self.defaults.integerForKey("tip_percent_default")
                let mag = Double(abs(defaultTip - currentTip!))
                
                //let red = CGFloat(((255 * mag) / 100) + 175)
                //let green = CGFloat(((255 * (100 - mag)) / 100) + 175)
                //let blue = CGFloat(0);
                
                //self.topDiv.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
                self.topDiv.backgroundColor = UIColor(hue: CGFloat(0.4 * mag), saturation: 0.9, brightness: 0.9, alpha: 1.0)
            })
        }
        
    }
    
    @IBAction func onSwipe(sender: UISwipeGestureRecognizer) {
        
        billField.text = String(billField.text!.characters.dropLast())
        self.onEditingChanged()
        
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        
        if motion == .MotionShake {
            print("Shaken, not stirred")
            
            let percentMax = defaults.integerForKey("tip_percent_max")
            let percentMin = defaults.integerForKey("tip_percent_min")
            
            tipPercentLabel.text = String(percentMin + Int(arc4random_uniform(UInt32(percentMax - percentMin + 1))))
            
            self.onEditingChanged()
        }
        
    }
    
    // MARK: - Theme Functions
    
    func changeThemeColorDark(){
        
        UIView.animateWithDuration(0.5, animations: {
            
            let red = CGFloat(self.defalutRed * 0.25)
            let green = CGFloat(self.defaultGreen * 0.25)
            let blue = CGFloat(self.defaultBlue * 0.25)
            
            self.view.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
            self.topDiv.backgroundColor = UIColor.lightGrayColor()
            self.dividerDiv.backgroundColor = UIColor.lightGrayColor()
        })
        
    }
    
    func changeThemeColorLight(){
        
        UIView.animateWithDuration(0.5, animations: {
            
            let red = CGFloat(self.defalutRed)
            let green = CGFloat(self.defaultGreen)
            let blue = CGFloat(self.defaultBlue)
            
            self.view.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
            self.topDiv.backgroundColor = UIColor.whiteColor()
            self.dividerDiv.backgroundColor = UIColor.whiteColor()
        })
        
    }
    
    
    // MARK: - IBActions (numeral buttons)
    
    @IBAction func onPressBtnOne(sender: AnyObject) {
        billField.text = billField.text! + "1"
        self.onEditingChanged()
    }
    
    @IBAction func onPressBtnTwo(sender: AnyObject) {
        billField.text = billField.text! + "2"
        self.onEditingChanged()
    }
    
    @IBAction func onPressBtnThree(sender: AnyObject) {
        billField.text = billField.text! + "3"
        self.onEditingChanged()
    }
    
    @IBAction func onPressBtnFour(sender: AnyObject) {
        billField.text = billField.text! + "4"
        self.onEditingChanged()
    }
    
    @IBAction func onPressBtnFive(sender: AnyObject) {
        billField.text = billField.text! + "5"
        self.onEditingChanged()
    }
    
    @IBAction func onPressBtnSix(sender: AnyObject) {
        billField.text = billField.text! + "6"
        self.onEditingChanged()
    }
    
    @IBAction func onPressBtnSeven(sender: AnyObject) {
        billField.text = billField.text! + "7"
        self.onEditingChanged()
    }
    
    @IBAction func onPressBtnEight(sender: AnyObject) {
        billField.text = billField.text! + "8"
        self.onEditingChanged()
    }
    
    @IBAction func onPressBtnNine(sender: AnyObject) {
        billField.text = billField.text! + "9"
        self.onEditingChanged()
    }
    
    @IBAction func onPressBtnZero(sender: AnyObject) {
        billField.text = billField.text! + "0"
        self.onEditingChanged()
    }
    
    @IBAction func onPressBtnClear(sender: AnyObject) {
        billField.text = "$"
        self.onEditingChanged()
    }
    

}

