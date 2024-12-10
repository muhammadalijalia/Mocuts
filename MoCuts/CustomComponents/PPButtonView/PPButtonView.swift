//
//  ViewForAppButton.swift
//  InventoryMeApp
//
//  Copyright © 2018 Appiskey. All rights reserved.
//

import UIKit

class PPButtonView: CustomNibView, CAAnimationDelegate {
    
    enum ButtonStyle{
        case light
        case normal
    }
    
    var view: UIView!
    @IBOutlet weak var button: AppButton!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    
    let gradient = CAGradientLayer()
    var gradientSet = [[CGColor]]()
    var currentGradient: Int = 0
    
    private var action : (() -> Void)? = nil
    
    var buttonStyle: ButtonStyle = .normal{
        didSet{
            self.button.backgroundColor = Theme.getAppOrangeButton(withAlpha: (buttonStyle == .normal) ? 1.0 : 0.4)
        }
    }
    override func setupView() {
        self.backgroundColor = .clear
        //        self.bgView.frame = self.bounds
        //        self.bgView.translatesAutoresizingMaskIntoConstraints = true
        //        self.bgView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.makeEdgesCircular()
        self.addGradient()
        //self.addAnimatingGradient()
    }
    
    func makeEdgesCircular(){
        self.bgView.layer.cornerRadius = 5
        self.bgView.clipsToBounds = true
    }
    
    func setAction(actionP: @escaping (() -> Void)){
        self.action = actionP
    }
    
    func setTextColor(color: UIColor){
        self.button.setTextColor(color: color)
    }
    
    func setImage(string: String){
        self.imgView.image = UIImage(named: string)
        // self.button.setImage(string: string)
    }
    
    func setUIImage(image: UIImage){
        self.button.setUIImage(image: image)
    }
    
    func setTitleLbl(string : String, color: UIColor=Theme.appOrangeColor){
        self.button.setTitleLbl(string: string, color: color)
        self.button.titleLabel?.textAlignment = .left
    }
    
    func setBackgroudColor(color: UIColor=Theme.appOrangeColor.withAlphaComponent(0.8)) {
        //  self.button.setBackgroudColor(color: color)
        self.bgView.backgroundColor = color
    }
    
    //    private func addGradient(){
    //        self.bgView.backgroundColor = UIColor.clear
    //        let gradient: CAGradientLayer = CAGradientLayer()
    //
    //        let colorLeft = UIColor(red: 30.0 / 255.0, green: 161.0 / 255.0, blue: 171.0 / 255.0, alpha: 1.0).cgColor
    //        let colorRight = UIColor(red: 39.0 / 255.0, green: 193.0 / 255.0, blue: 206.0 / 255.0, alpha: 1.0).cgColor
    //
    //        gradient.colors = [colorLeft, colorRight]
    //
    //        gradient.startPoint = CGPoint(x: 0, y: 0.5) // Left side.
    //        gradient.endPoint = CGPoint(x: 1, y: 0.5) // Right side.
    //        gradient.frame = CGRect(x: 0.0, y: 0.0, width: bgView.frame.width , height: bgView.frame.height)
    //        self.bgView.layer.insertSublayer(gradient, at: 0)
    //    }
    
    private func addAnimatingGradient() {
        
        self.bgView.backgroundColor = UIColor.clear
        let gradientTwo = UIColor(red: 30.0/255, green: 140.0/255, blue: 150.0/255, alpha: 1).cgColor
        let gradientOne = UIColor(red: 16.0/255, green: 200.0/255, blue: 215.0/255, alpha: 1).cgColor
        
        //        let gradientOne = UIColor(red: 255.0/255, green: 255.0/255, blue: 255.0/255, alpha: 1).cgColor
        //        let gradientTwo = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 1).cgColor
        gradientSet.append([gradientOne, gradientTwo])
        gradientSet.append([gradientTwo, gradientOne])
        gradient.frame = self.bgView.bounds
        gradient.colors = gradientSet[currentGradient]
        gradient.startPoint = CGPoint(x:0, y:0.5)
        gradient.endPoint = CGPoint(x:1, y:0.5)
        gradient.drawsAsynchronously = true
        self.bgView.layer.insertSublayer(gradient, at :0)
        animateGradient()
    }
      private func addGradient(){
          self.bgView.backgroundColor = UIColor.clear
          let gradient: CAGradientLayer = CAGradientLayer()
          
          let colorLeft = UIColor(red: 30.0 / 255.0, green: 161.0 / 255.0, blue: 171.0 / 255.0, alpha: 1.0).cgColor
          let colorRight = UIColor(red: 39.0 / 255.0, green: 193.0 / 255.0, blue: 206.0 / 255.0, alpha: 1.0).cgColor

          gradient.colors = [colorLeft, colorRight]
          
          gradient.startPoint = CGPoint(x: 0, y: 0.5) // Left side.
          gradient.endPoint = CGPoint(x: 1, y: 0.5) // Right side.
          gradient.frame = CGRect(x: 0.0, y: 0.0, width: bgView.frame.width , height: bgView.frame.height)
          self.bgView.layer.insertSublayer(gradient, at: 0)
      }
    
    func animateGradient() {
        if currentGradient < gradientSet.count - 1 {
            currentGradient += 1
        } else {
            currentGradient = 1
        }
        let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
        gradientChangeAnimation.duration = 5
        gradientChangeAnimation.toValue = gradientSet[currentGradient]
        gradientChangeAnimation.fillMode = CAMediaTimingFillMode.forwards
        gradientChangeAnimation.isRemovedOnCompletion = false
        gradient.add(gradientChangeAnimation, forKey: "colorChange")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            gradient.colors = gradientSet[currentGradient]
            animateGradient()
        }
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        if self.action != nil{
            self.action!()
        }
    }
}
