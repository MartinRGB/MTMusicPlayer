//
//  CoverFlowLayout.swift
//  CoverFlowLayout
//
//  Created by Broccoli on 15/11/26.
//  Copyright © 2015年 Broccoli. All rights reserved.
//

import UIKit

public var vinylMoveValue:CGFloat = 0.0

class CoverFlowLayout: UICollectionViewFlowLayout {
    
    let kDistanceToProjectionPlane: CGFloat = 500.0
    var maxCoverDegree: CGFloat = 30.0
    var coverDensity: CGFloat = 0.25
    

    
    //当collection view的bounds改变时，布局需要告诉collection view是否需要重新计算布局。
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }

    //设置整体Attributes
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let indexPaths = indexPathsOfItemsInRect(rect)
        
        var resultingAttributes = [UICollectionViewLayoutAttributes]()
        
        for indexPath in indexPaths {
            //设置每个Cell的尺寸&位置
            let attributes = layoutAttributesForItemAtIndexPath(indexPath)!
            resultingAttributes.append(attributes)
        }
        
        
        
        return resultingAttributes
    }
    
    //设置每一个Cell的Attributes
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        
        
        attributes.size = CGSizeMake(collectionView!.bounds.size.width*0.4225, collectionView!.bounds.size.width*0.293)
        attributes.center = CGPoint(x: collectionView!.bounds.size.width * CGFloat(indexPath.row) + collectionView!.bounds.size.width, y: collectionView!.bounds.size.height*0.435)
        //设置间距信息
        interpolateAttributes(attributes, forOffset: collectionView!.contentOffset.x)

        return attributes
    }
    
    override func collectionViewContentSize() -> CGSize {
        return CGSize(width: collectionView!.bounds.width * CGFloat(collectionView!.numberOfItemsInSection(0)), height: collectionView!.bounds.height)
    }
}


// MARK: - private method
private extension CoverFlowLayout {
    
    //根据Cell的Invisible来获取IndexPath
    func indexPathsOfItemsInRect(rect: CGRect) -> [NSIndexPath] {
        if collectionView!.numberOfItemsInSection(0) == 0 {
            return [NSIndexPath]()
        }
        //下一个max与上一个min
        var minRow: Int = max(Int(rect.origin.x / collectionView!.bounds.width), 0)
        var maxRow: Int = Int(CGRectGetMaxX(rect) / collectionView!.bounds.width)
        
        
        
        let candidateMinRow = max(minRow - 1, 0)
        if maxXForRow(candidateMinRow) >= rect.origin.x {
            minRow = candidateMinRow
        }
        
        let candidateMaxRow = min(maxRow + 1, collectionView!.numberOfItemsInSection(0) - 1)
        if minXForRow(candidateMaxRow) <= CGRectGetMaxX(rect) {
            maxRow = candidateMaxRow
        }
        
        var resultingInexPaths = [NSIndexPath]()
        
        for i in Int(minRow) ..< Int(maxRow) + 1 {
            resultingInexPaths.append(NSIndexPath(forRow: i, inSection: 0))
        }
        
        return resultingInexPaths
    }
    
    func minXForRow(row: Int) -> CGFloat {
        return itemCenterForRow(row - 1).x + (1 / 2 - coverDensity) * itemSize.width
    }
    
    func maxXForRow(row: Int) -> CGFloat {
        return itemCenterForRow(row + 1).x - (1 / 2 - coverDensity) * itemSize.width
    }
    
    func minXCenterForRow(row: Int) -> CGFloat {
        let halfWidth = itemSize.width / 2
        let maxRads = maxCoverDegree * CGFloat(M_PI) / 180
        let center = itemCenterForRow(row - 1).x
        let prevItemRightEdge = center + halfWidth
        let projectedLeftEdgeLocal = halfWidth * cos(maxRads) * kDistanceToProjectionPlane / (kDistanceToProjectionPlane + halfWidth * sin(maxRads))
        return prevItemRightEdge - coverDensity * itemSize.width + projectedLeftEdgeLocal
    }
    
    func maxXCenterForRow(row: Int) -> CGFloat {
        let halfWidth = itemSize.width / 2
        let maxRads = maxCoverDegree * CGFloat(M_PI) / 180
        let center = itemCenterForRow(row + 1).x
        let nextItemLeftEdge = center - halfWidth
        let projectedRightEdgeLocal = fabs(halfWidth * cos(maxRads) * kDistanceToProjectionPlane / (-halfWidth * sin(maxRads) - kDistanceToProjectionPlane))
        return nextItemLeftEdge + coverDensity * itemSize.width - projectedRightEdgeLocal
    }
    
    func itemCenterForRow(row: Int) -> CGPoint {
        let collectionViewSize = collectionView!.bounds.size
        return CGPoint(x: CGFloat(row) * collectionViewSize.width + collectionViewSize.width / 2, y: collectionViewSize.height / 2)
    }
    
    
    
    
    //间距设置
    func interpolateAttributes(attributes: UICollectionViewLayoutAttributes, forOffset offset: CGFloat) {
        let attributesPath = attributes.indexPath
        
        //间距
        let minInterval = CGFloat(Double(attributesPath.row - 1) - 0.5) * collectionView!.bounds.width
        let maxInterval = CGFloat(Double(attributesPath.row + 1) + 0.5) * collectionView!.bounds.width
        
        let minX = minXCenterForRow(attributesPath.row)
        let maxX = maxXCenterForRow(attributesPath.row)
        
        let interpolatedX = min(max(minX + (((maxX - minX) / (maxInterval - minInterval)) * (offset - minInterval)), minX), maxX)
        
        //MARK: CollectionView XY Position
        attributes.center = CGPoint(x: interpolatedX, y: attributes.center.y)
        
        //Rotation Part
        let angle = -maxCoverDegree + (interpolatedX - minX) * 2 * maxCoverDegree / (maxX - minX)
        //print(angle)
        attributes.transform3D = CATransform3DMakeScale((100-abs(angle)*2)/100, (100-abs(angle)*2)/100, (100-abs(angle)*2)/100)
        attributes.alpha = (60 - abs(angle)*2)/20
        
        vinylMoveValue = 0.1635 - abs(angle) * 0.007325
        
        
    
    }
    
}
