//
//  ImageVideoStoreViewController+Extension.swift
//  TECHRES-SEEMT
//
//  Created by Nguyen Thanh Vinh on 29/12/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit
import RxCocoa
import RxDataSources
import ObjectMapper

struct MediaSection {
    var date: String
    var items: [MediaStore]
}

extension MediaSection: SectionModelType {
    typealias Item = MediaStore

    var identity: String {
        return date
    }

    init(original: MediaSection, items: [MediaStore]) {
        self = original
        self.items = items
    }
}

extension ImageVideoStoreViewController {
    func registerCell(){
        let itemImageVideoStoreCollectionViewCell = UINib(nibName: "ItemImageVideoStoreCollectionViewCell", bundle: .main)
        collectionView.register(itemImageVideoStoreCollectionViewCell, forCellWithReuseIdentifier: "ItemImageVideoStoreCollectionViewCell")
        
        collectionView.register(ImageVideoStoreCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "ImageVideoStoreCollectionReusableView")
        
        refreshControl.tintColor = .systemOrange
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        collectionView.addSubview(refreshControl)
   }
    
   @objc func refresh(_ sender: AnyObject) {
       isLoadingMore = true
       isResetData = true
       viewModel.position.accept("")
       dataArrayReview.removeAll()
       getListMedia()
       refreshControl.endRefreshing()
   }
    
    func bindCollectionView(){
        let mediaObservable = viewModel.dataArray.asObservable()
        groupedMediaObservable = mediaObservable
            .map { mediaArray in
                Dictionary(grouping: mediaArray, by: { $0.time })
                    .sorted { $0.key > $1.key }
                    .map { MediaSection(date: $0.key, items: $0.value) }
            }
        let dataSource = RxCollectionViewSectionedReloadDataSource<MediaSection>(
            configureCell: { dataSource, collectionView, indexPath, mediaItem in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemImageVideoStoreCollectionViewCell",
                                                              for: indexPath) as! ItemImageVideoStoreCollectionViewCell
                cell.data = mediaItem
                return cell
            },
            configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                 withReuseIdentifier: "ImageVideoStoreCollectionReusableView",
                                                                                 for: indexPath) as! ImageVideoStoreCollectionReusableView
                let section = dataSource.sectionModels[indexPath.section]
                headerView.configure()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                if let date = dateFormatter.date(from: section.date) {
                    let currentDate = Date()
                    if Calendar.current.isDate(date, inSameDayAs: currentDate) {
                        headerView.lbl_time.text = "Hôm nay"
                    } else {
                        headerView.lbl_time.text = section.date
                    }
                } else {
                    headerView.lbl_time.text = section.date
                }
                return headerView
            })
        groupedMediaObservable
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: rxbag)
    }
}

extension ImageVideoStoreViewController {
    func getListMedia() {
        viewModel.getListMedia().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue) {
                if let dataFromServer = Mapper<MediaStore>().mapArray(JSONObject: response.data) {
                    
                    if self.isResetData {
                        self.viewModel.dataArray.accept([])
                        self.isResetData = false
                    }
                    
                    var newData = self.viewModel.dataArray.value
                    newData.append(contentsOf: dataFromServer)
                    self.viewModel.dataArray.accept(newData)
                    
                    self.dataArrayReview.removeAll()
                    for data_review in newData {
                        if (data_review.media.type == TYPE_IMAGE) {
                            self.dataArrayReview.append(SingleMedia(
                                imageURL: URL(
                                    string: MediaUtils.getFullMediaLink(string: data_review.media.original.url)
                                )
                            ))
                        } else {
                            let videoLocal = URL(string: MediaUtils.getFullMediaLink(string: data_review.media.original.link_full, media_type: .video))
                            let thumbNailVideo = URL(string: MediaUtils.getFullMediaLink(string: data_review.media.thumb.url))
                            self.dataArrayReview.append(SingleMedia(
                                imageURL: thumbNailVideo,
                                isVideoThumbnail: true,
                                videoURL: videoLocal,
                                videoString: videoLocal?.absoluteString ?? ""
                            ))
                        }
                    }
                    
                    self.root_view_empty_data.isHidden = newData.count > 0
                    self.isLoadingMore = dataFromServer.count > 0
                    
                    self.view_load_more.isHidden = true
                    self.spinner.stopAnimating()
                }
            } else {
                dLog(response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ. Vui lòng thử lại")
            }
        }).disposed(by: rxbag)
    }
}

extension ImageVideoStoreViewController: UICollectionViewDelegateFlowLayout {
    // UICollectionViewDelegate method to load more data when reaching the end of collection view
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // Check if the last cell is being displayed
        let lastSection = collectionView.numberOfSections - 1
        if indexPath.section == lastSection
            && indexPath.row == collectionView.numberOfItems(inSection: lastSection) - 1
            && isLoadingMore {
            // Load more data when the last cell is displayed
            isLoadingMore = false
            let lastPosition = viewModel.dataArray.value.last?.position ?? ""
            viewModel.position.accept(lastPosition)
            getListMedia()
            view_load_more.isHidden = false
            spinner.startAnimating()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Calculate the width and height of each cell
        let cellsPerRow: CGFloat = 3
        let spacing: CGFloat = 10
        let contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let fixedDimension = collectionView.frame.width - (contentInset.left + contentInset.right)
        let itemFixedDimension = (fixedDimension - (CGFloat(cellsPerRow) * spacing) + spacing) / CGFloat(cellsPerRow)
        return CGSize(width: itemFixedDimension, height: itemFixedDimension)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 40)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) // Section insets define the spacing around each section
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // Adjust as per your requirement
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // Adjust as per your requirement
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dataArray = self.viewModel.dataArray.value
        self.groupedMediaObservable
            .take(1) // Which can help in preventing memory leaks and unnecessary processing.
            .subscribe(onNext: { sections in
                let selectedItem = sections[indexPath.section].items[indexPath.item]
                if let index = dataArray.firstIndex(where: { $0.media.media_id == selectedItem.media.media_id }) {
                    self.presentModalPreviewViewController(position: index)
                }
            }).disposed(by: rxbag)
    }
}
