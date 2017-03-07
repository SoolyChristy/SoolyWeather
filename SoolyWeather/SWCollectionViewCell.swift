//
//  SWCollectionViewCell.swift
//  SoolyWeather
//
//  Created by SoolyChristina on 2017/3/5.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit

private let reuseID = "forecastCell"
class SWCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var forecastCollectionView: UICollectionView!
    
    /// 天气图标
    @IBOutlet weak var iconView: UIImageView!
    /// 城市名
    @IBOutlet weak var cityLabel: UILabel!
    /// 天气
    @IBOutlet weak var weatherLabel: UILabel!
    /// 温度
    @IBOutlet weak var tempLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        self.backgroundColor = UIColor.white
        forecastCollectionView.register(UINib(nibName: "ForecastCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: reuseID)
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
//        layout.sectionInset = UIEdgeInsetsMake(-0.1, -0.1, -0.1, -0.1)
        layout.itemSize = CGSize(width: ScreenWidth / 4, height: forecastCollectionView.bounds.height)
        layout.scrollDirection = .horizontal
        forecastCollectionView.collectionViewLayout = layout
        forecastCollectionView.isPagingEnabled = true
        forecastCollectionView.dataSource = self
        forecastCollectionView.delegate = self
    }

}

// MARK: forecastCollectionView
extension SWCollectionViewCell: UICollectionViewDelegate,UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath)
//        cell.backgroundColor = UIColor.blue
        return cell
    }
}
