//
//  ToneCurveEditor.swift
//  ToneCurveEditor
//
//  Created by Simon Gladman on 12/09/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//

import UIKit

class ToneCurveEditor: UIControl
{
    var sliders = [UISlider]()
    let curveLayer = ToneCurveEditorCurveLayer()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        curveLayer.toneCurveEditor = self
        curveLayer.contentsScale = UIScreen.mainScreen().scale
        layer.addSublayer(curveLayer)
  
        createSliders()
    }

    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    var curveValues : [Double] = [Double](count: 5, repeatedValue: 0.0)
    {
        didSet
        {
            for (i, value): (Int, Double) in curveValues.enumerate()
            {
                sliders[i].value = Float(value)
            }
            
            drawCurve()
        }
    }
	
	/* Create 5 sliders which can change the curve by users */
    func createSliders()
    {
        let rotateTransform = CGAffineTransformIdentity
        
        for i in 0..<5
        {
            let slider = UISlider(frame: CGRectZero)
  
            slider.transform = CGAffineTransformRotate(rotateTransform, CGFloat(-90.0 * M_PI / 180.0));
            slider.addTarget(self, action: "sliderChangeHandler:", forControlEvents: .ValueChanged)
			
			slider.minimumTrackTintColor = UIColor.clearColor()
			slider.maximumTrackTintColor = UIColor.clearColor()
			
			slider.setThumbImage(UIImage(named: "transparent"), forState: UIControlState.Normal)
			
            sliders.append(slider)
            
            addSubview(slider)
        }
    }
	
	/* Draw curve acrroding to current sliders' values */
    func drawCurve()
    {
        curveLayer.frame = bounds.insetBy(dx: 0, dy: 0)
        curveLayer.setNeedsDisplay()
    }
	
    func sliderChangeHandler(slider : UISlider)
    {
        curveValues = [Double]()
        
        for slider in sliders
        {
            curveValues.append(Double(slider.value))
        }
        
        sendActionsForControlEvents(.ValueChanged)
    }
	
	/* Draw curve, sliders, separeted lines and labels */
    override func layoutSubviews()
    {
		let margin:CGFloat = 20.0 - sliders[0].thumbImageForState(.Normal)!.size.height * 0.5
		let lrMargin:CGFloat = 10.0
        let targetHeight = CGFloat(frame.height) - margin - margin
        let targetWidth = CGFloat(frame.width) / CGFloat(sliders.count)
		let sliderWidth = lrMargin * 2
		
		let context = UIGraphicsGetCurrentContext()
		let space = (CGFloat(frame.width) - lrMargin * 2) / CGFloat(4)
		
        for (i, slider): (Int, UISlider) in sliders.enumerate()
        {
			let targetX = space * CGFloat(i)
			
            slider.frame = CGRect(x: targetX, y: margin, width: sliderWidth, height: targetHeight)
			
			/* Draw separated lines */
			let view = UIView(frame: CGRectMake(targetX + lrMargin - 0.5, 0, 1.0, frame.height))
			view.backgroundColor = UIColor(white: 0.2, alpha: 0.9)
			self.addSubview(view)
			
			/* Create label between sliders */
			if i < 4 {
				let label = UILabel(frame: CGRectMake(lrMargin + targetX + space * 0.5 - 15.0, 0.0, 30.0, 20.0))
				label.textColor = UIColor(white: 0.0, alpha: 1.0)
				label.textAlignment = .Center
				label.font = UIFont.systemFontOfSize(10.0)
				self.addSubview(label)
				if i == 0 {
					label.text = "黑色"
				}
				if i == 1 {
					label.text = "阴影"
				}
				if i == 2 {
					label.text = "高亮"
				}
				if i == 3 {
					label.text = "白色"
				}
			}
		}
		
        drawCurve()
    }

}
