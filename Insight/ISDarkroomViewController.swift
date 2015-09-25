//
//  ISDarkroomViewController.swift
//  Insight
//
//  Created by Definiter on 15/6/13.
//  Copyright (c) 2015年 Definiter. All rights reserved.
//

import UIKit
import Photos


let AdjustmentFormatIdentifier = "Insight"
let AdjustmentFormatVersionIdentifier = "1.0"

class ISDarkroomViewController: UIViewController, UIGestureRecognizerDelegate, PHPhotoLibraryChangeObserver {
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var mainFunctionView: UIVisualEffectView!
    @IBOutlet weak var subFunctionView: UIVisualEffectView!
    @IBOutlet weak var adjustBarView: UIVisualEffectView!
    
    @IBOutlet weak var functionContainerViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mainFunctionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var subFunctionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var adjustBarViewHeightConstraint: NSLayoutConstraint!
    
    var collectionViewController: ISCollectionViewController!
    
    var adjustBarLabelView: UILabel!
    var adjustBarSliderView: UISlider!
    
    var mainFunctionButtons = [UIButton]()
    var subFunctionButtons = [[UIButton]]()
    var subFunctionButtonTitles: [[String]]!
    
    var nowFunction: String!
    var processor = ISProcessor()
    
    var asset: PHAsset!
    var originalImage: CIImage!
    var originalThumbnail: CIImage!
    var thumbnail: CIImage!
    var context: CIContext!
    var colorHistogramView: ISColorHistogramView!
    var toneCurveView: ToneCurveEditor!
    
    var constHeight: CGFloat!
	
	////////////////////
	/* Initialization */
	////////////////////
	
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let eaglContext = EAGLContext(API: EAGLRenderingAPI.OpenGLES2)
        self.context = CIContext(EAGLContext: eaglContext)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //----------- UI -----------
		
        // set constrains
        constHeight = UIScreen.mainScreen().bounds.height / 4 / 3;
        mainFunctionViewHeightConstraint.constant = constHeight
        subFunctionViewHeightConstraint.constant = constHeight
        adjustBarViewHeightConstraint.constant = constHeight
        functionContainerViewConstraint.constant = constHeight * 3
        
        // set UINavigationBar
        navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        // set slider and label
        adjustBarLabelView = UILabel(frame: CGRectMake(10, 0, 60, constHeight))
        adjustBarLabelView.text = "0"
        adjustBarSliderView = UISlider(frame: CGRectMake(80, 0, UIScreen.mainScreen().bounds.width - 100, constHeight))
        adjustBarSliderView.minimumValue = -100
        adjustBarSliderView.maximumValue = 100
        adjustBarSliderView.value = 0
        adjustBarSliderView.addTarget(self, action: "adjustBarSliderChanged:", forControlEvents: UIControlEvents.ValueChanged)
        adjustBarSliderView.minimumTrackTintColor = UIColor.blackColor()
        adjustBarSliderView.maximumTrackTintColor = UIColor.blackColor()
        adjustBarSliderView.setThumbImage(imageWithSize(UIImage(named: "slider")!, size: CGSize(width: constHeight / 2.5, height: constHeight / 2.5)), forState: UIControlState.Normal)
        adjustBarView.addSubview(adjustBarLabelView)
        adjustBarView.addSubview(adjustBarSliderView)

        
        // set main funciton button
        for var i = 0; i < 4; ++i {
            let buttonWidth = UIScreen.mainScreen().bounds.width / 4
            let button = UIButton(frame: CGRectMake(buttonWidth * CGFloat(i), 0, buttonWidth, constHeight))
            let normalImage = imageWithSize(UIImage(named: "normal_main" + String(i))!, size: CGSize(width: constHeight / 2, height: constHeight / 2))
            let greyImage = imageWithSize(UIImage(named: "selected_main" + String(i))!, size: CGSize(width: constHeight / 2, height: constHeight / 2))
            button.imageView?.contentMode = UIViewContentMode.Center
            button.setImage(normalImage, forState: UIControlState.Normal)
            button.setImage(greyImage, forState: UIControlState.Selected)
            button.setImage(greyImage, forState: UIControlState.Highlighted)
            button.titleLabel?.text = String(i)
            button.addTarget(self, action: "mainFunctionButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
            mainFunctionView.addSubview(button)
            mainFunctionButtons.append(button)
        }
        
        // add sub fuction button
        subFunctionButtonTitles = [["角度", "水平变形", "垂直变形"], ["饱和度", "色相",  "色温"], ["锐化", "模糊", "暗角"]]
        for var i = 0; i < 3; ++i {
            subFunctionButtons.append([UIButton]())
            let buttonCount = subFunctionButtonTitles[i].count
            let buttonWidth = UIScreen.mainScreen().bounds.width / CGFloat(buttonCount)
            for var j = 0; j < buttonCount; ++j {
                let button = UIButton(frame: CGRectMake(buttonWidth * CGFloat(j), 0, buttonWidth, constHeight))
                button.backgroundColor = UIColor(white: 0, alpha: 0)
                button.setTitle(subFunctionButtonTitles[i][j], forState: UIControlState.Normal)
                button.setTitleColor(UIColor.grayColor(), forState: UIControlState.Highlighted)
                button.setTitleColor(UIColor.grayColor(), forState: UIControlState.Selected)
                button.addTarget(self, action: "subFunctionButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
                subFunctionButtons[i].append(button)
            }
        }
        mainFunctionButtonPressed(mainFunctionButtons[0])
        
        // set gesture
        imageView.userInteractionEnabled = true
        
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: "pinchGestureDetected:")
        pinchGestureRecognizer.delegate = self
        imageView.addGestureRecognizer(pinchGestureRecognizer)
        
        let rotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: "rotationGestureDetected:")
        rotationGestureRecognizer.delegate = self
        imageView.addGestureRecognizer(rotationGestureRecognizer)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "panGestureDetected:")
        panGestureRecognizer.delegate = self
        imageView.addGestureRecognizer(panGestureRecognizer)
        
        let doubleTabGestureRecognizer = UITapGestureRecognizer(target: self, action: "doubleTabGestureDetected:")
        doubleTabGestureRecognizer.numberOfTapsRequired = 2
        doubleTabGestureRecognizer.delegate = self
        imageView.addGestureRecognizer(doubleTabGestureRecognizer)
        
        let sliderDoubleTabGestureRecognizer = UITapGestureRecognizer(target: self, action: "sliderDoubleTabGestureDetected:")
        sliderDoubleTabGestureRecognizer.numberOfTapsRequired = 2
        adjustBarSliderView.addGestureRecognizer(sliderDoubleTabGestureRecognizer)
        
        // set view order
        view.sendSubviewToBack(imageView)
		
        // creat colorhistogramview
        colorHistogramView = ISColorHistogramView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, constHeight * 2))
        colorHistogramView.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        
        // set ToneCurveView
        toneCurveView = ToneCurveEditor(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, constHeight * 2))
        toneCurveView.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        toneCurveView.curveValues = [0.0, 0.25, 0.5, 0.75, 1.0]
        toneCurveView.addTarget(self, action: "toneCurveViewSliderChanged:", forControlEvents: .ValueChanged)
        for var i = 0; i < 5; ++i {
            toneCurveView.sliders[i].addTarget(self, action: "toneCurveViewSlidesDidChange:", forControlEvents: UIControlEvents.TouchUpInside)
            toneCurveView.sliders[i].addTarget(self, action: "toneCurveViewSlidesDidChange:", forControlEvents: UIControlEvents.TouchUpOutside)
        }
        
        //----------- image -----------
        initializeContent()
    }
    
    func initializeContent() {
        let options = PHImageRequestOptions()
        options.synchronous = true
        PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: PHImageManagerMaximumSize, contentMode: .AspectFit, options: options, resultHandler: {(result: UIImage?, info) in
            self.originalImage = CIImage(image: UIImage(CGImage: result!.CGImage!, scale: 1.0, orientation: UIImageOrientation.Up))
        })
        originalThumbnail = resizeImage(originalImage, ratio: 0.5)
        thumbnail = originalThumbnail
        refreshImage()
    }
	
	//////////////////
	/*   Gesture    */
	//////////////////
	
    func adjustAnchorPointForGestureRecognizer(recognizer: UIGestureRecognizer) {
        if recognizer.state == UIGestureRecognizerState.Began || recognizer.state == UIGestureRecognizerState.Ended {
            let piece = recognizer.view!
            let locationInView = recognizer.locationInView(piece)
            let locationInSuperView = recognizer.locationInView(piece.superview)
            piece.layer.anchorPoint = CGPointMake(locationInView.x / piece.bounds.size.width, locationInView.y / piece.bounds.size.height)
            piece.center = locationInSuperView
        }
    }

    func pinchGestureDetected(recognizer: UIPinchGestureRecognizer) {
        let piece = recognizer.view!
        let state = recognizer.state
        var scale = recognizer.scale
        adjustAnchorPointForGestureRecognizer(recognizer)
        if state == UIGestureRecognizerState.Began || state == UIGestureRecognizerState.Changed {
            piece.transform = CGAffineTransformScale(piece.transform, scale, scale)
            recognizer.scale = 1.0
        }
        if state == UIGestureRecognizerState.Ended {
            let minScale = CGFloat(1.0)
            let maxScale = CGFloat(3.0)
            scale = imageView.transform.a
            if scale < minScale {
                scale = minScale
            }
            if scale > maxScale {
                scale = maxScale
            }
            // set frame to superview.bounds, if scale is too big or too small
            UIView.animateWithDuration(0.3, animations: {
                piece.transform = CGAffineTransformMakeScale(scale, scale)
                if scale == minScale {
                    piece.frame = piece.superview!.bounds
                }
            })
        }
    }
    
    func rotationGestureDetected(recognizer: UIRotationGestureRecognizer) {
        let piece = recognizer.view!
        let state = recognizer.state
        adjustAnchorPointForGestureRecognizer(recognizer)
        if state == UIGestureRecognizerState.Began || state == UIGestureRecognizerState.Changed {
            piece.transform = CGAffineTransformRotate(piece.transform, recognizer.rotation)
            recognizer.rotation = 0
        }
    }
	
    func panGestureDetected(recognizer: UIPanGestureRecognizer) {
        let piece = recognizer.view!
        let state = recognizer.state
        adjustAnchorPointForGestureRecognizer(recognizer)
        if state == UIGestureRecognizerState.Began || state == UIGestureRecognizerState.Changed {
            let translation = recognizer.translationInView(piece.superview!)
            piece.center = CGPointMake(piece.center.x + translation.x, piece.center.y + translation.y)
            recognizer.setTranslation(CGPointZero, inView: piece.superview)
        }
        // adjust edge if imageView leaves imageContainerView's edge
        if state == UIGestureRecognizerState.Ended {
            var frame = piece.frame
            if frame.origin.x > 0 {
                frame.origin.x = 0
            }
            if frame.origin.y > 0 {
                frame.origin.y = 0
            }
            if frame.origin.x + frame.size.width < piece.superview?.bounds.width {
                frame.origin.x = piece.superview!.bounds.width - frame.size.width
            }
            if frame.origin.y + frame.size.height < piece.superview?.bounds.height {
                frame.origin.y = piece.superview!.bounds.height - frame.size.height
            }
            UIView.animateWithDuration(0.3, animations: {
                piece.frame = frame
            })
        }
    }
    
    func doubleTabGestureDetected(recognizer: UITapGestureRecognizer) {
        let piece = recognizer.view!
        let state = recognizer.state
        adjustAnchorPointForGestureRecognizer(recognizer)
        if state == UIGestureRecognizerState.Ended {
            if piece.transform.a == 1.0 {
                UIView.animateWithDuration(0.3, animations: {
                    piece.transform = CGAffineTransformMakeScale(3, 3)
                })
            } else {
                UIView.animateWithDuration(0.3, animations: {
                    // back to original transform matrix
                    piece.transform = CGAffineTransformMakeScale(1, 1)
                    piece.transform = CGAffineTransformMakeRotation(0)
                    piece.frame = piece.superview!.bounds
                })
            }
        }
    }
    
    /// double tap slider to set default argument
    func sliderDoubleTabGestureDetected(recognizer: UITapGestureRecognizer) {
        processor.arguments[nowFunction] = processor.argumentDefaultValues[nowFunction]
        refreshAdjustBar()
        refreshImage()
    }
    
    // allow recognizing simulataneously gestrue
    func gestureRecognizer(recongizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
	
	///////////////
	/*  Button   */
	///////////////
	
	func mainFunctionButtonPressed(sender: UIButton) {
		for var i = 0; i < mainFunctionButtons.count; i++ {
			mainFunctionButtons[i].selected = false
		}
		sender.selected = true
		var index = Int(sender.titleLabel!.text!)!
		switchToSubFunction(index)
		if index != 1 {
			if index > 1 {
				index = index - 1
			}
			subFunctionButtonPressed(subFunctionButtons[index][0])
		}
	}
	
	func subFunctionButtonPressed(sender: UIButton) {
		nowFunction = sender.titleLabel?.text!
		for var i = 0; i < subFunctionButtons.count; i++ {
			for var j = 0; j < subFunctionButtons[i].count; j++ {
				subFunctionButtons[i][j].selected = false
			}
		}
		sender.selected = true
		refreshAdjustBar()
	}
	
	@IBAction func recoverButtonPressed(sender: UIBarButtonItem) {
		processor.arguments = processor.argumentDefaultValues
		refreshAdjustBar()
		refreshImage()
		refreshHistogram()
		refreshToneCurveView()
	}
	
	@IBAction func saveButtonPressed(sender: UIBarButtonItem) {
		processor.inputImage = originalImage
		let processedImage = CIImageToUIImage(processor.outputImage)
		var changed = false
		for (key, value) in processor.arguments {
			if value != processor.argumentDefaultValues[key]{
				changed = true
				break
			}
		}
		if changed {
			let options = PHContentEditingInputRequestOptions()
			options.canHandleAdjustmentData = {adjustmentData in
				return true
			}
			asset?.requestContentEditingInputWithOptions(options, completionHandler: {
				(contentEditingInput: PHContentEditingInput?, n: [NSObject : AnyObject]) -> Void in
				_ = contentEditingInput!.fullSizeImageURL
				let jpegData = UIImageJPEGRepresentation(processedImage, 1.0)
				let adjustmentData = PHAdjustmentData(formatIdentifier: AdjustmentFormatIdentifier, formatVersion: AdjustmentFormatVersionIdentifier, data: NSKeyedArchiver.archivedDataWithRootObject(self.processor.arguments))
				let contentEditingOutput = PHContentEditingOutput(contentEditingInput: contentEditingInput!)
				jpegData!.writeToURL(contentEditingOutput.renderedContentURL, atomically: true)
				contentEditingOutput.adjustmentData = adjustmentData
                // send change request to Photo library, maybe have some delay
				PHPhotoLibrary.sharedPhotoLibrary().performChanges({
					let request = PHAssetChangeRequest(forAsset: self.asset)
					request.contentEditingOutput = contentEditingOutput
					}, completionHandler: { (success: Bool, error: NSError?) -> Void in
						if !success {
							NSLog("Error: %@", error!)
						} else {
							print("success", terminator: "")
							//self.collectionViewController.update()
						}
					}
				)
			})
		}
		self.navigationController?.popViewControllerAnimated(true)
	}
	
	func switchToSubFunction(num: Int) {
		var index = num
		
		for var i = 0; i < 3; ++i {
			for var j = 0; j < subFunctionButtons[i].count; ++j {
				subFunctionButtons[i][j].removeFromSuperview()
			}
		}
        // brightness subfunction
		if index == 1 {
			subFunctionViewHeightConstraint.constant = 0
			adjustBarViewHeightConstraint.constant = constHeight * 2
			adjustBarView.addSubview(colorHistogramView)
			adjustBarSliderView.removeFromSuperview()
			adjustBarLabelView.removeFromSuperview()
			colorHistogramView.update(resizeImage(thumbnail, ratio: 0.3))
			refreshHistogram()
			adjustBarView.addSubview(toneCurveView)
        // other subfunctions
		} else {
			if index > 1 {
				index = index - 1
			}
			if (subFunctionViewHeightConstraint.constant == 0) {
				subFunctionViewHeightConstraint.constant = constHeight
				adjustBarViewHeightConstraint.constant = constHeight
				colorHistogramView.removeFromSuperview()
				toneCurveView.removeFromSuperview()
			}
			for var j = 0; j < subFunctionButtons[index].count; ++j {
				subFunctionView.addSubview(subFunctionButtons[index][j])
			}
			adjustBarView.addSubview(adjustBarSliderView)
			adjustBarView.addSubview(adjustBarLabelView)
		}
	}
	
	///////////////
	/*  Events   */
	///////////////
	
	func adjustBarSliderChanged(sender: UISlider) {
		processor.arguments[nowFunction]! = sliderValueToArgumentValue(nowFunction)
		refreshAdjustBar()
		refreshImage()
	}
	
	func toneCurveViewSliderChanged(toneCurveView : ToneCurveEditor) {
		for var i = 0; i < 5; ++i {
			processor.arguments["曲线点" + String(i)] = toneCurveView.curveValues[i]
		}
		refreshImage()
	}
	
	func toneCurveViewSlidesDidChange(toneCurveView: ToneCurveEditor) {
		refreshHistogram()
	}
	
	func photoLibraryDidChange(changeInstance: PHChange) {
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
			let changeDetails = changeInstance.changeDetailsForObject(self.asset)
			if (changeDetails != nil) {
				self.asset = changeDetails!.objectAfterChanges as? PHAsset
				self.initializeContent()
				self.refreshAdjustBar()
				self.refreshHistogram()
				self.refreshToneCurveView()
			}
		})
	}
	
	//////////////////////
	/*  Refresh Methods */
	//////////////////////
	
    func refreshAdjustBar() {
        adjustBarSliderView.value = argumentValueToSliderValue(nowFunction)
        adjustBarLabelView.text = String(format: "%.1f", processor.arguments[nowFunction]!)
    }
    
    func refreshImage() {
        processor.inputImage = originalThumbnail
        thumbnail = processor.outputImage
        imageView.image = CIImageToUIImage(thumbnail)
    }
    
    func refreshHistogram() {
        colorHistogramView.update(resizeImage(thumbnail, ratio: 0.3))
        colorHistogramView.setNeedsDisplay()
    }

    func refreshToneCurveView() {
        for var i = 0; i < 5; ++i {
            toneCurveView.curveValues[i] = processor.arguments["曲线点" + String(i)]!
        }
        toneCurveView.setNeedsDisplay()
    }
	
	//////////////
	/*  Others  */
	//////////////
	
    func argumentValueToSliderValue(argumentName: String)->Float {
        let value = processor.arguments[argumentName]!
        let range = processor.argumentRanges[argumentName]!
        let sliderRange = (adjustBarSliderView.minimumValue, adjustBarSliderView.maximumValue)
        return (sliderRange.1 - sliderRange.0) / Float(range.1 - range.0) * Float(value - range.0) + sliderRange.0
    }
    
    func sliderValueToArgumentValue(argumentName: String)->Double {
        let range = processor.argumentRanges[argumentName]!
        let sliderValue = adjustBarSliderView.value
        let sliderRange = (adjustBarSliderView.minimumValue, adjustBarSliderView.maximumValue)
        return (range.1 - range.0) / Double(sliderRange.1 - sliderRange.0) * Double(sliderValue - sliderRange.0) + range.0
    }
	
	func resizeImage(image: CIImage, ratio: Float)->CIImage {
		let resizeFilter = CIFilter(name: "CILanczosScaleTransform")
		resizeFilter!.setValue(image, forKey: kCIInputImageKey)
		resizeFilter!.setValue(1.0, forKey: kCIInputAspectRatioKey)
		resizeFilter!.setValue(ratio, forKey: kCIInputScaleKey)
		return resizeFilter!.outputImage!
	}
	
	func imageWithSize(image: UIImage, size: CGSize)->UIImage {
		UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
		image.drawInRect(CGRectMake(0, 0, size.width, size.height))
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return newImage
	}
    
    // will maintain ratio of the image
	func CIImageToUIImage(image: CIImage)->UIImage {
		let cgImage = context.createCGImage(image, fromRect: image.extent)
		return UIImage(CGImage: cgImage)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
}

