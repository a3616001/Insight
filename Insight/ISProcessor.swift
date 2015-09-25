//
//  ISProcessor.swift
//  Insight
//
//  Created by Definiter on 15/7/5.
//  Copyright (c) 2015年 Definiter. All rights reserved.
//

import Foundation
import UIKit

class ISProcessor {
    var inputImage: CIImage?
    var argumentNames: [String]!
    var arguments: [String: Double]!
    var argumentDefaultValues = [String: Double]()
    var argumentRanges = [String: (Double, Double)]()
    
    init() {
        argumentNames = ["裁剪矩形", "角度", "水平变形", "垂直变形", "曲线点0", "曲线点1", "曲线点2", "曲线点3", "曲线点4", "饱和度", "色相", "色温", "锐化", "模糊", "降噪", "暗角"]
		
        // set default arguments
        for var i = 1; i < argumentNames.count; i++ {
            argumentDefaultValues[argumentNames[i]] = 0.0
        }
        
        for var i = 0; i < 5; i++ {
            argumentDefaultValues["曲线点" + String(i)] = Double(i) * 0.25
            argumentRanges["曲线点" + String(i)] = (0, 1)
        }
		
		/* Set arguments defalut values and ranges */
        argumentDefaultValues["角度"] = 0
        argumentRanges["角度"] = (-180, 180)
        argumentDefaultValues["水平变形"] = 0
        argumentRanges["水平变形"] = (-100, 100)
        argumentDefaultValues["垂直变形"] = 0
        argumentRanges["垂直变形"] = (-100, 100)
        argumentDefaultValues["饱和度"] = 1
        argumentRanges["饱和度"] = (0, 2)
        argumentDefaultValues["色相"] = 0
        argumentRanges["色相"] = (-M_PI, M_PI)
        argumentDefaultValues["色温"] = 6500
        argumentRanges["色温"] = (2000, 11000)
        argumentDefaultValues["锐化"] = 0
        argumentRanges["锐化"] = (0, 2)
        argumentDefaultValues["模糊"] = 0
        argumentRanges["模糊"] = (0, 10)
        argumentDefaultValues["降噪"] = 0
        argumentRanges["降噪"] = (0, 2)
        argumentDefaultValues["暗角"] = 0
        argumentRanges["暗角"] = (0, 1)
    
        self.arguments = self.argumentDefaultValues
    }

    /* Get outputImage according to current arugements */
    var outputImage: CIImage! {
        get {
            if inputImage == nil {
                return CIImage.emptyImage()
            }
            
            var resultImage = inputImage!
            
            // below is filter chain
            
            // only apply filter if its argument value is not equal 
            // to default argument value
            
            // CIStraightenFilter
            if arguments["角度"] != argumentDefaultValues["角度"] {
                let straightenFilter = CIFilter(name: "CIStraightenFilter")
                straightenFilter!.setValue(resultImage, forKey: "inputImage")
                straightenFilter!.setValue(NSNumber(double: arguments["角度"]! / 180.0 * M_PI), forKey: "inputAngle")
                resultImage = straightenFilter!.outputImage!
            }
            
            // CIPerspectiveTransform
            let currentImage = resultImage
            let currentWidth = currentImage.extent.width
            let currentHeight = currentImage.extent.height
            if arguments["水平变形"] != argumentDefaultValues["水平变形"] || arguments["垂直变形"] != argumentDefaultValues["垂直变形"] {
                var heightOffL = CGFloat(arguments["水平变形"]!) * currentHeight * 0.003
                var heightOffR = -heightOffL
                var widthOffD = CGFloat(arguments["垂直变形"]!) * currentWidth * 0.003
                var widthOffU = -widthOffD
                
                if (heightOffL < 0) {
                    heightOffL = 0
                }
                else {
                    heightOffR = 0
                }
                
                if (widthOffD < 0) {
                    widthOffD = 0
                }
                else {
                    widthOffU = 0
                }
                
                let persperctiveTransform = CIFilter(name: "CIPerspectiveTransform")
                persperctiveTransform!.setValue(currentImage, forKey: "inputImage")
                persperctiveTransform!.setValue(CIVector(x: -widthOffD, y: -heightOffL), forKey: "inputBottomLeft")
                persperctiveTransform!.setValue(CIVector(x: currentWidth + widthOffD, y: -heightOffR), forKey: "inputBottomRight")
                persperctiveTransform!.setValue(CIVector(x: -widthOffU, y: currentHeight + heightOffL), forKey: "inputTopLeft")
                persperctiveTransform!.setValue(CIVector(x: currentWidth + widthOffU, y: currentHeight + heightOffR), forKey: "inputTopRight")
                resultImage = persperctiveTransform!.outputImage!.imageByCroppingToRect(CGRectMake(0.0, 0.0, currentWidth, currentHeight))
            }
            
            // CIToneCurve
            var toneCurveChanged = false
            for var i = 0; i < 5; i++ {
                if arguments["曲线点" + String(i)] != argumentDefaultValues["曲线点" + String(i)] {
                    toneCurveChanged = true
                    break
                }
            }
            if toneCurveChanged {
                let toneCurveFilter = CIFilter(name: "CIToneCurve")
                toneCurveFilter!.setValue(resultImage, forKey: "inputImage")
                for var i = 0; i < 5; i++ {
                    toneCurveFilter!.setValue(CIVector(x: CGFloat(i) * 0.25, y: CGFloat((arguments["曲线点" + String(i)]! - argumentDefaultValues["曲线点" + String(i)]!) * 0.2 + argumentDefaultValues["曲线点" + String(i)]!)), forKey: "inputPoint" + String(i))
                }
                resultImage = toneCurveFilter!.outputImage!
            }
        
            // CIColorControls
            if arguments["饱和度"] != argumentDefaultValues["饱和度"] {
                let colorControlsFilter = CIFilter(name: "CIColorControls")
                colorControlsFilter!.setValue(resultImage, forKey: "inputImage")
                colorControlsFilter!.setValue(arguments["饱和度"], forKey: "inputSaturation")
                resultImage = colorControlsFilter!.outputImage!
            }
            
            // CIHueAdjust
            if arguments["色相"] != argumentDefaultValues["色相"] {
                let hueAdjustFilter = CIFilter(name: "CIHueAdjust")
                hueAdjustFilter!.setValue(resultImage, forKey: "inputImage")
                hueAdjustFilter!.setValue(arguments["色相"], forKey: "inputAngle")
                resultImage = hueAdjustFilter!.outputImage!
            }
            
            // CITemperatureAndTint
            if arguments["色温"] != argumentDefaultValues["色温"] {
                let temperatureAndTintFilter = CIFilter(name: "CITemperatureAndTint")
                temperatureAndTintFilter!.setValue(resultImage, forKey: "inputImage")
                temperatureAndTintFilter!.setValue(CIVector(x: CGFloat(arguments["色温"]!), y: 0), forKey: "inputTargetNeutral")
                resultImage = temperatureAndTintFilter!.outputImage!
            }
            
            // CISharpenLuminance
            if arguments["锐化"] != argumentDefaultValues["锐化"] {
                let sharpenLuminanceFilter = CIFilter(name: "CISharpenLuminance")
                sharpenLuminanceFilter!.setValue(resultImage, forKey: "inputImage")
                sharpenLuminanceFilter!.setValue(arguments["锐化"], forKey: "inputSharpness")
                resultImage = sharpenLuminanceFilter!.outputImage!
            }
            
            // CIGaussianBlur
            if arguments["模糊"] != argumentDefaultValues["模糊"] {
                let gaussianBlurFilter = CIFilter(name: "CIGaussianBlur")
                gaussianBlurFilter!.setValue(resultImage, forKey: "inputImage")
                gaussianBlurFilter!.setValue(arguments["模糊"], forKey: "inputRadius")
                resultImage = gaussianBlurFilter!.outputImage!
            }
            
            // CIVignetteEffect
            if arguments["暗角"] != argumentDefaultValues["暗角"] {
                let vignetteEffectFilter = CIFilter(name: "CIVignetteEffect")
                let height = resultImage.extent.height
                let width = resultImage.extent.width
                vignetteEffectFilter!.setValue(resultImage, forKey: "inputImage")
                vignetteEffectFilter!.setValue(CIVector(x: width / 2, y: height / 2), forKey: "inputCenter")
                vignetteEffectFilter!.setValue(max(height, width) / 2.1, forKey: "inputRadius")
                vignetteEffectFilter!.setValue(0.05, forKey: "inputFalloff")
                vignetteEffectFilter!.setValue(arguments["暗角"], forKey: "inputIntensity")
                resultImage = vignetteEffectFilter!.outputImage!
            }

            return resultImage
        }
    }
}


