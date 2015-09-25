//
//  ToneCurveEditorCurveLayer.swift
//  ToneCurveEditor
//
//  Created by Simon Gladman on 13/09/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//

import UIKit
import CoreGraphics

class ToneCurveEditorCurveLayer: CALayer
{
    weak var toneCurveEditor : ToneCurveEditor?
	
	/* draw curve using 2 width line */
    override func drawInContext(ctx: CGContext)
    {
        if let curveValues = toneCurveEditor?.curveValues
        {
            let path = UIBezierPath()
    
            let margin = 0
			let lrMargin = 10.0
            let thumbRadius = 10
            _ = Int(frame.width)
            let widgetHeight = Int(frame.height) - margin - margin - thumbRadius - thumbRadius

            var interpolationPoints : [CGPoint] = [CGPoint]()
            
            for (i, value): (Int, Double) in curveValues.enumerate()
            {
				let pathPointX = (Double(frame.width) - lrMargin * 2) / Double(4) * Double(i) + lrMargin
                let pathPointY = Double(thumbRadius + margin + widgetHeight - Int(Double(widgetHeight) * value))
				
                interpolationPoints.append(CGPoint(x: pathPointX,y: pathPointY))
            }
			
            path.interpolatePointsWithHermite(interpolationPoints)
       
            CGContextSetLineJoin(ctx, CGLineJoin.Round)
            CGContextAddPath(ctx, path.CGPath)
            CGContextSetStrokeColorWithColor(ctx, UIColor.blackColor().CGColor)
            CGContextSetLineWidth(ctx, 2)
            CGContextStrokePath(ctx)
        }
    }


    
}
