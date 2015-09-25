//
//  ISCollectionViewController.swift
//  Insight
//
//  Created by 钟泽轩 on 15/7/3.
//  Copyright (c) 2015年 Definiter. All rights reserved.
//

import UIKit
import Photos

let reuseIdentifier = "Cell"
let InterSpace:CGFloat = 1.0
let ItemsOfEachLine:CGFloat = 4
let SelectViewRightMargin:CGFloat = 8.0

class ISCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, PHPhotoLibraryChangeObserver {
    
    var allPhotos: PHFetchResult!
    var smartAlbums: PHFetchResult!
    var userAlbums: PHFetchResult!
    var nowFetchResult: PHFetchResult!
    var ThumbnailSize: CGSize?
    var popSelectView: ISPopSelectView!
	
    override func awakeFromNib() {
        ThumbnailSize = CGSize(width: (UIScreen.mainScreen().bounds.width - InterSpace * (ItemsOfEachLine + 2)) / ItemsOfEachLine, height: (UIScreen.mainScreen().bounds.width - InterSpace * (ItemsOfEachLine + 2)) / ItemsOfEachLine)
		let options = PHFetchOptions()
		options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
		
		/* Get Albums */
		allPhotos = PHAsset.fetchAssetsWithOptions(options)
		
		nowFetchResult = allPhotos
		
		smartAlbums = PHAssetCollection.fetchAssetCollectionsWithType(PHAssetCollectionType.SmartAlbum, subtype: PHAssetCollectionSubtype.AlbumSyncedAlbum, options: nil)
		
		userAlbums = PHCollectionList.fetchTopLevelUserCollectionsWithOptions(nil)
		
		/* Set popSelectVie */
		popSelectView = ISPopSelectView(frame: CGRectMake(UIScreen.mainScreen().bounds.width * 0.45, 70.0, UIScreen.mainScreen().bounds.width * 0.55 - SelectViewRightMargin, UIScreen.mainScreen().bounds.height * 0.6), style: UITableViewStyle.Plain)
		popSelectView.backgroundColor = UIColor(white: 1.0, alpha: 0.95)
		popSelectView.backgroundView = nil
		popSelectView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
		popSelectView.separatorInset = UIEdgeInsetsMake(0.0, 15.0, 0.0, 15.0)
		
		popSelectView.layer.borderWidth = 1.0
		popSelectView.layer.borderColor = UIColor.grayColor().CGColor
		
		popSelectView.delegate = self
		popSelectView.dataSource = self
		
		PHPhotoLibrary.sharedPhotoLibrary().registerChangeObserver(self)
    }
	
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
	
	func photoLibraryDidChange(changeInstance: PHChange) {
		print("Changed")
		update()
	}
	
	/* Set navigationBar */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        navigationItem.title = "All Photos"
        navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
	
	/* Get number of collectionView items */
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nowFetchResult.count
    }
	
	/* Get each collectionViewCell */
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ISCell", forIndexPath: indexPath) as! ISCollectionViewCell
        
        let nowAsset = nowFetchResult.objectAtIndex(indexPath.row) as? PHAsset
        
        if let checkedAsset = nowAsset {
            PHImageManager.defaultManager().requestImageForAsset(nowAsset!, targetSize: CGSizeMake(ThumbnailSize!.width * 2, ThumbnailSize!.height * 2), contentMode: PHImageContentMode.AspectFit, options: nil, resultHandler: {(image: UIImage?, info: [NSObject: AnyObject]?) in
                cell.contentImage.image = image
            })
        }
        
        cell.layer.borderWidth = 0
        return cell
    }
	
	/* Get Size of a collection item */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return ThumbnailSize!
    }
	
	/* Get space between collection items */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return InterSpace
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return InterSpace
    }
	
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: InterSpace, left: InterSpace, bottom: InterSpace, right: InterSpace)
    }
	
	
	///////////////////////////
	/* UITableViewDataSource */
	///////////////////////////
	
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tableViewCell = UITableViewCell()
        tableViewCell.backgroundColor = UIColor.clearColor()
		
        if (indexPath.section == 0) {
            tableViewCell.textLabel?.text = "All Photos"
        }
        
        if (indexPath.section == 1) {
            tableViewCell.textLabel?.text = smartAlbums[indexPath.row].localizedTitle
        }
        
        if (indexPath.section == 2) {
            tableViewCell.textLabel?.text = userAlbums[indexPath.row].localizedTitle
        }
        
        tableViewCell.textLabel?.font = UIFont.systemFontOfSize(15.0)
        
        tableViewCell.selectionStyle = UITableViewCellSelectionStyle.None;
        return tableViewCell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 1
        }
        if (section == 1) {
            return smartAlbums.count
        }
        if (section == 2) {
            return userAlbums.count
        }
        return 0
    }
	
	///////////////////////////
	/*  UITableViewDelegate  */
	///////////////////////////
	
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            nowFetchResult = allPhotos
            navigationItem.title = "All Photos"
        }
        if indexPath.section == 1 {
            let collection: AnyObject! = smartAlbums[indexPath.row]
            if collection.isKindOfClass(PHAssetCollection) {
                let assetColletion = collection as! PHAssetCollection
                print(assetColletion.localizedTitle)
                nowFetchResult = PHAsset.fetchAssetsInAssetCollection(assetColletion, options: nil)
                navigationItem.title = assetColletion.localizedTitle
            }
        }
        if indexPath.section == 2 {
            let collection: AnyObject! = userAlbums[indexPath.row]
            if collection.isKindOfClass(PHAssetCollection) {
                let assetColletion = collection as! PHAssetCollection
                print(assetColletion.localizedTitle)
                nowFetchResult = PHAsset.fetchAssetsInAssetCollection(assetColletion, options: nil)
                navigationItem.title = assetColletion.localizedTitle
            }
        }
        
        self.collectionView?.reloadData()
        self.popSelectView.removeFromSuperview()
    }
	
	/* Press “相册" button */
    var visiable = false
    @IBAction func pressSelectButton(sender: UIBarButtonItem) {
        if !visiable {
            self.view.addSubview(popSelectView)
            visiable = true
        }
        else {
            self.popSelectView.removeFromSuperview()
            visiable = false
        }
    }
	
	/* Update assets data and redraw the collection view */
    func update() {
        print("reload")
        
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        allPhotos = PHAsset.fetchAssetsWithOptions(options)
        
        smartAlbums = PHAssetCollection.fetchAssetCollectionsWithType(PHAssetCollectionType.SmartAlbum, subtype: PHAssetCollectionSubtype.AlbumSyncedAlbum, options: nil)
        
        userAlbums = PHCollectionList.fetchTopLevelUserCollectionsWithOptions(nil)
        
        if (navigationItem.title == "All Photos") {
            nowFetchResult = allPhotos
        }
        for var i = 0; i < smartAlbums.count; ++i {
            if navigationItem.title == smartAlbums[i].localizedTitle {
                nowFetchResult = PHAsset.fetchAssetsInAssetCollection(smartAlbums[i] as! PHAssetCollection, options: nil)
            }
        }
        for var i = 0; i < userAlbums.count; ++i {
            if navigationItem.title == userAlbums[i].localizedTitle {
                nowFetchResult = PHAsset.fetchAssetsInAssetCollection(userAlbums[i] as! PHAssetCollection, options: nil)
            }
        }
        
        collectionView!.reloadData()
    }
	
	/* Send the asset to ISDarkroomViewController */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "darkroom" {
            let vc = segue.destinationViewController as! ISDarkroomViewController
            let indexPath = self.collectionView?.indexPathForCell(sender as! UICollectionViewCell)
            vc.asset = nowFetchResult[indexPath!.row] as? PHAsset
            vc.collectionViewController = self
        }
    }
}
