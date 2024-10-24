//
//  MessageCell + extension + CollectionCell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 24/05/2024.
//

import UIKit


extension MessageCellTableViewCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func registerCollectionCell() {
    
        let nib = UINib(nibName: "ImageCollectionViewCell", bundle: .main)
        let headerNib = UINib(nibName: "HomeHeaderView", bundle: .main)
        collectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomeHeaderView")
        collectionView.register(nib, forCellWithReuseIdentifier: "ImageCollectionViewCell")
        collectionView.isScrollEnabled = false
        collectionView!.collectionViewLayout = flowLayout
        
        collectionView.delegate = self
        collectionView.dataSource = self
    
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let message = self.data else{
            return 0
        }
        return message.media.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        
        if let message = self.data{
            let i = indexPath.row
            
            cell.link = message.media[i].url_local.isEmpty
            ? MediaUtils.getFullMediaLink(string: message.media[i].original.url)
            : message.media[i].url_local
        }

        return cell
    }
    


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let message = data, let viewModel = viewModel else { return }
        viewModel.view?.handleSelectedMedia(message: message,media: message.media[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let message = self.data else{
            return CGSize(width: 0, height: 0)
        }
        
        let i = indexPath.item
        var columns: CGFloat = 0
        var height: CGFloat = 0
        
        switch message.media.count{
            case 0:
                columns = 0
                height = 0
                break
            
            case 1:
                columns = 1
                height = 250
                break

            case 2:
                columns = 2
                height = 200
                break

            case 3:
                columns = 3
                height = 100
                break

            case 4:
                columns = 2
                height = 100
                break

            case 5:
                columns = (i == 0 || i == 1) ? 2 : 3
                height = 100
                break

            default:
                columns = 3
                height = 100
                break
        }

        
    
        let width = collectionView.bounds.width
        let spacing: CGFloat = flowLayout.minimumInteritemSpacing
        let availableWidth = width - spacing * (columns + 1)
        let itemDimension = floor(availableWidth / columns)
        return CGSize(width: itemDimension, height: height)
    }
}
