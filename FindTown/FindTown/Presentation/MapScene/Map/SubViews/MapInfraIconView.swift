//
//  MapIconView.swift
//  FindTown
//
//  Created by 이호영 on 2023/06/07.
//

import UIKit

import FindTownUI

final class MapInfraIconView: UIView {
    
    private let imageView = UIImageView()
    private let backgroundView = UIView()
  
    init(store: InfraStore) {
        
        super.init(frame: .zero)
      
        setupImage(store: store)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupImage(store: InfraStore) {
        
      
        backgroundView.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        backgroundView.backgroundColor = .white

        backgroundView.layer.backgroundColor = store.subCategory.iconColor.cgColor
        backgroundView.layer.cornerRadius = 12
        
        imageView.frame = CGRect(x: 6, y: 6, width: 12, height: 12)
        imageView.image = UIImage(named: store.subCategory.imageName)!.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.white
    }


    private func setupView() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundView.addSubview(imageView)
        self.addSubview(backgroundView)
        
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            imageView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            
            backgroundView.widthAnchor.constraint(equalToConstant: 24),
            backgroundView.heightAnchor.constraint(equalToConstant: 24),
        ])
    }
}
