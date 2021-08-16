//
//  Neumorphic.swift
//  Agora-VideoCall app
//
//  Created by Shankar K on 16/08/21.
//

import UIKit

class Neumorphic: UIView {
    
    public var bevel = 2 // 'pop-out' effect amount
    public var bG_Color: UIColor!
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
//         Drawing code
        self.layer.masksToBounds = false
        self.cornerRadius = 15
        
    }
    
    public func addShadow(color: UIColor){
        let topLayer = createShadowLayer(fillcolor: color, color:.init(hexString: "#ffffff") , offset: CGSize(width: -14, height: -14))
        let bottomLayer = createShadowLayer(fillcolor: color, color: .init(hexString: "#d9d9d9"), offset: CGSize(width: 14, height: 14))

        // Modified
        layer.insertSublayer(topLayer, at: 0)
        layer.insertSublayer(bottomLayer, at: 0)

    }

    private func createShadowLayer(fillcolor: UIColor, color: UIColor, offset: CGSize) -> CAShapeLayer {
            // Modified
        let shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.cornerRadius).cgPath
        shadowLayer.fillColor = fillcolor.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.frame = self.bounds
        shadowLayer.masksToBounds = false
        shadowLayer.shadowColor = color.cgColor
        shadowLayer.shadowOpacity = 1
//        shadowLayer.shadowOffset = offset
        shadowLayer.shadowRadius = 10
//        shadowLayer.shouldRasterize = true

        return shadowLayer
    }


}

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }

    public func blurViewEffect(){
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
    }
}
