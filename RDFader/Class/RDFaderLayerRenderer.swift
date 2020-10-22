//
//  RDFaderLayerRenderer.swift
//  RDFader
//
//  Created by Romin Dhameliya on 9/8/20.
//  Copyright © 2020 Romin Dhameliya. All rights reserved.
//

import UIKit

internal class RDFaderLayerRenderer {
	
	weak var RDFader: RDFader?
	
	var trackBackground: UIColor = .darkGray {
		didSet {
			trackLayer.backgroundColor = trackBackground.cgColor
		}
	}
	
	var thumbTint: UIColor = .white {
		didSet {
			thumbLayer.fillColor = thumbTint.cgColor
		}
	}
	
	var cornerRadius: CGFloat = 10 {
		didSet {
			updateMaskLayerPath()
		}
	}
	
	var grayedOut: Bool = false {
		didSet {
			updateGrayedOut()
		}
	}
	
	var popUp: Bool = false {
		didSet(oldValue) {
			if oldValue != popUp {
				updatePopUp()
			}
		}
	}
	
	let trackLayer = CALayer()
	let thumbLayer = CAShapeLayer()
	let maskLayer = CAShapeLayer()
	
	init() {
		trackLayer.backgroundColor = trackBackground.cgColor
		thumbLayer.fillColor = thumbTint.cgColor
		maskLayer.fillColor = UIColor.white.cgColor
		maskLayer.backgroundColor = UIColor.clear.cgColor
		trackLayer.mask = maskLayer
		trackLayer.masksToBounds = true
	}
	
	private func updateThumbLayerPath() {
		CATransaction.begin()
		CATransaction.setDisableActions(true)
		
		thumbLayer.path = CGPath(rect: CGRect(x: 0, y: 0, width: thumbLayer.bounds.width, height: thumbLayer.bounds.height), transform: nil)
		
		CATransaction.commit()
	}
	
	private func updateMaskLayerPath() {
		CATransaction.begin()
		CATransaction.setDisableActions(true)
		
		let maskRect = CGRect(x: 0, y: 0, width: maskLayer.bounds.width, height: maskLayer.bounds.height)
		let maskPath = UIBezierPath(roundedRect: maskRect, cornerRadius: cornerRadius)
		maskLayer.path = maskPath.cgPath
		
		CATransaction.commit()
	}
	
	private func updateGrayedOut() {
		let alpha: Float = grayedOut ? 0.25 : 1
		trackLayer.opacity = alpha
	}
	
	private func updatePopUp() {
		CATransaction.begin()
		CATransaction.setDisableActions(true)
		
		let zPosition: CGFloat = popUp ? 1.025 : 1
		trackLayer.transform = CATransform3DScale(CATransform3DIdentity, zPosition, zPosition, zPosition)
		
		let animation = CABasicAnimation(keyPath: "transform.scale")
		animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
		animation.duration = 0.1
		trackLayer.add(animation, forKey: nil)
		
		CATransaction.commit()
	}
	
	internal func updateBounds(_ bounds: CGRect) {
		CATransaction.begin()
		CATransaction.setDisableActions(true)
		
		trackLayer.bounds = bounds
		trackLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
		
		maskLayer.bounds = trackLayer.bounds
		maskLayer.position = trackLayer.position
		updateMaskLayerPath()
		
		thumbLayer.bounds = trackLayer.bounds
		thumbLayer.position = trackLayer.position
		updateThumbLayerPath()
		
		CATransaction.commit()
		
		if let value = RDFader?.value {
			setValue(value)
		}
	}
	
	internal func setValue(_ value: Float, animated: Bool = false) {
		CATransaction.begin()
		CATransaction.setDisableActions(true)
		
		let valueAxisOffset = RDFader!.valueAxisFrom(CGPoint(x: thumbLayer.bounds.width, y: thumbLayer.bounds.height), accountForDirection: true)
		let valueAxisAmount = RDFader!.positionForValue(value)
		let reverseOffset = (RDFader!.reverseValueAxis && !RDFader!.vertical) || (!RDFader!.reverseValueAxis && RDFader!.vertical)
		let position = RDFader!.pointOnSlider(valueAxisPosition: valueAxisAmount - (reverseOffset ? 0 : valueAxisOffset), offAxisPosition: 0)
		
		thumbLayer.transform = CATransform3DTranslate(CATransform3DIdentity, position.x, position.y, 0)
		
		if animated {
			let animationAxis = RDFader!.vertical ? "y" : "x"
			let animation = CABasicAnimation(keyPath: "transform.translation.\(animationAxis)")
			animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
			thumbLayer.add(animation, forKey: nil)
		}
		
		CATransaction.commit()
	}
}
