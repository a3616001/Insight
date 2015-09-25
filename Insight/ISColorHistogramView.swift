//
//  ISColorHistogramView.swift
//  Insight
//
//  Created by 钟泽轩 on 15/7/5.
//  Copyright (c) 2015年 Definiter. All rights reserved.
//

import UIKit

/* the number of the histogram segments */
let SegmentNum = 256

class ISColorHistogramView: UIView {
	var data: [Int]!
	var maxNum: Int!
    var context = CIContext(options: nil)
	
    func CIImageToCGImage(image: CIImage)->CGImage {
        let cgImage = context.createCGImage(image, fromRect: image.extent)
        return cgImage
    }
	
	/* Draw the histogram acrroding to current data */
	override func drawRect(rect: CGRect) {
		let segWidth = rect.width / CGFloat(SegmentNum)
		let context = UIGraphicsGetCurrentContext()
		
		/* For each segment draw a line using cgcontext */
		for var i = 0; i < SegmentNum; ++i {
			let nowH = (1.0 - CGFloat(data[i]) / CGFloat(maxNum)) * bounds.maxY
			let nowX = segWidth * CGFloat(i) + segWidth * 0.5
			
			CGContextSetLineWidth(context, segWidth)
			CGContextMoveToPoint(context, nowX, nowH)
			CGContextAddLineToPoint(context, nowX, bounds.maxY)
			CGContextSetStrokeColorWithColor(context, UIColor.grayColor().CGColor)
			CGContextStrokePath(context)
		}
	}
	
	/* Update the data to "newImage" data */
	func update(newImage: CIImage) {
        
		let currentImage = CIImageToCGImage(newImage)
		_ = 255.0 / Double(SegmentNum)
		
		data = [Int]()
		for var i = 0; i < SegmentNum; ++i {
			data.append(0)
		}
		maxNum = 0
		
		let width = CGImageGetWidth(currentImage)
		let height = CGImageGetHeight(currentImage)
		
		let pixelData = CGDataProviderCopyData(CGImageGetDataProvider(currentImage))
		let RGBData: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
		
		for var x = 0; x < width; ++x {
			for var y = 0; y < height; ++y {
				let pixelInfo: Int = ((width * y) + x) * 4
				let red = Int(RGBData[pixelInfo])
				let green = Int(RGBData[pixelInfo + 1])
				let blue = Int(RGBData[pixelInfo + 2])
				let avg = (red + green + blue) / 3
				let index = avg
				data[index] = data[index] + 1
			}
		}
		
		for var i = 0; i < SegmentNum; ++i {
			if data[i] > maxNum {
				maxNum = data[i]
			}
		}
		
	}
}
