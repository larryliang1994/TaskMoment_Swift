//
//  AssetsGridViewController.swift
//  SwiftAssetsPickerController
//
//  Created by Maxim Bilan on 6/5/15.
//  Copyright (c) 2015 Maxim Bilan. All rights reserved.
//

import UIKit
import Photos
import CheckMarkView

class AssetsPickerGridController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
	
	private var assetGridThumbnailSize: CGSize = CGSizeMake(0, 0)
	private let reuseIdentifier = "AssetsGridCell"
	private let typeIconSize = CGSizeMake(20, 20)
	private let checkMarkSize = CGSizeMake(28, 28)
	private let iconOffset: CGFloat = 3
	private let collectionViewEdgeInset: CGFloat = 2
	private let assetsInRow: CGFloat = UIDevice.currentDevice().userInterfaceIdiom == .Phone ? 4 : 8
	
	let cachingImageManager = PHCachingImageManager()
	var collection: PHAssetCollection?
	var selectedIndexes: Set<Int> = Set()
	var didSelectAssets: ((Array<PHAsset!>) -> ())?
	private var assets: [PHAsset]! {
		willSet {
			cachingImageManager.stopCachingImagesForAllAssets()
		}
		
		didSet {
			cachingImageManager.startCachingImagesForAssets(self.assets, targetSize: PHImageManagerMaximumSize, contentMode: PHImageContentMode.AspectFill, options: nil)
		}
	}
	
	// MARK: - Initialization
	
	override init(collectionViewLayout layout: UICollectionViewLayout) {
		super.init(collectionViewLayout: layout)
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.scrollDirection = UICollectionViewScrollDirection.Vertical
		
		collectionView?.collectionViewLayout = flowLayout
		collectionView?.backgroundColor = UIColor.whiteColor()
		collectionView?.registerClass(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: reuseIdentifier)
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: UIBarButtonItemStyle.Done, target: self, action: "doneAction")
		navigationItem.rightBarButtonItem?.enabled = false
		
		let scale = UIScreen.mainScreen().scale;
		let cellSize = flowLayout.itemSize
		assetGridThumbnailSize = CGSizeMake(cellSize.width * scale, cellSize.height * scale);
		
		let assetsFetchResult = (collection == nil) ? PHAsset.fetchAssetsWithMediaType(.Image, options: nil) : PHAsset.fetchAssetsInAssetCollection(collection!, options: nil)
		assets = assetsFetchResult.objectsAtIndexes(NSIndexSet(indexesInRange: NSMakeRange(0, assetsFetchResult.count))) as! [PHAsset]
	}
	
	// MARK: UICollectionViewDataSource
	
	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return assets.count
	}
	
	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) 
		cell.backgroundColor = UIColor.blackColor()
		
		let currentTag = cell.tag + 1
		cell.tag = currentTag
		
		var thumbnail: UIImageView!
		var typeIcon: UIImageView!
		var checkMarkView: CheckMarkView!
		
		if cell.contentView.subviews.count == 0 {
			thumbnail = UIImageView(frame: cell.contentView.frame)
			thumbnail.contentMode = .ScaleAspectFill
			thumbnail.clipsToBounds = true
			cell.contentView.addSubview(thumbnail)
			
			typeIcon = UIImageView(frame: CGRectMake(iconOffset, cell.contentView.frame.size.height - iconOffset - typeIconSize.height, typeIconSize.width, typeIconSize.height))
			typeIcon.contentMode = .ScaleAspectFill
			typeIcon.clipsToBounds = true
			cell.contentView.addSubview(typeIcon)
			
			checkMarkView = CheckMarkView(frame: CGRectMake(cell.contentView.frame.size.width - iconOffset - checkMarkSize.width, iconOffset, checkMarkSize.width, checkMarkSize.height))
			checkMarkView.backgroundColor = UIColor.clearColor()
			checkMarkView.style = CheckMarkView.CheckMarkStyle.Nothing
			cell.contentView.addSubview(checkMarkView)
		}
		else {
			thumbnail = cell.contentView.subviews[0] as! UIImageView
			typeIcon = cell.contentView.subviews[1] as! UIImageView
			checkMarkView = cell.contentView.subviews[2] as! CheckMarkView
		}
		
		let asset = assets[indexPath.row]
		
		typeIcon.image = nil
		if asset.mediaType == .Video {
			if asset.mediaSubtypes == .VideoTimelapse {
				typeIcon.image = UIImage(named: "timelapse-icon.png")
			}
			else {
				typeIcon.image = UIImage(named: "video-icon.png")
			}
		}
		else if asset.mediaType == .Image {
			if asset.mediaSubtypes == .PhotoPanorama {
				typeIcon.image = UIImage(named: "panorama-icon.png")
			}
		}

		checkMarkView.checked = selectedIndexes.contains(indexPath.row)
		
		cachingImageManager.requestImageForAsset(asset, targetSize: assetGridThumbnailSize, contentMode: PHImageContentMode.AspectFill, options: nil, resultHandler: { (image: UIImage?, info :[NSObject : AnyObject]?) -> Void in
			if cell.tag == currentTag {
				thumbnail.image = image
			}
		})
		
		return cell
	}
	
	// MARK: UICollectionViewDelegate
	
	override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		if selectedIndexes.contains(indexPath.row) {
			selectedIndexes.remove(indexPath.row)
			navigationItem.rightBarButtonItem?.enabled = selectedIndexes.count > 0 ? true : false
		}
		else {
			navigationItem.rightBarButtonItem?.enabled = true
			selectedIndexes.insert(indexPath.row)
		}
		collectionView.reloadItemsAtIndexPaths([indexPath])
	}
	
	// MARK: UICollectionViewDelegateFlowLayout
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		let a = (self.view.frame.size.width - assetsInRow * 1 - 2 * collectionViewEdgeInset) / assetsInRow
		return CGSizeMake(a, a)
	}
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
		return UIEdgeInsetsMake(collectionViewEdgeInset, collectionViewEdgeInset, collectionViewEdgeInset, collectionViewEdgeInset)
	}
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
		return 1
	}
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
		return 1
	}
	
	// MARK: - Navigation bar actions
	
	func doneAction() {
		
		var selectedAssets: Array<PHAsset!> = Array()
		for index in selectedIndexes {
			let asset = assets[index]
			selectedAssets.append(asset)
		}
		
		if didSelectAssets != nil {
			didSelectAssets!(selectedAssets)
		}
		
		navigationController!.dismissViewControllerAnimated(true, completion: nil)
	}
	
}