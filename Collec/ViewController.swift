//
//  ViewController.swift
//  Collec
//
//  Created by Mohamed Abd el Aty on 3/28/20.
//  Copyright © 2020 Aty. All rights reserved.
//

import UIKit


extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}



struct Hero: Decodable {
    let localized_name : String
    let img : String
}


class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  // var ivImage:[String] = ["dice2","dice2","dice2","dice2","dice2","dice2","dice2","dice2","dice2","dice2"]
    //var ilText:[String] = ["1","2","3","4","5","1","2","3","4","5"]
    
   var heroes = [Hero]()
    
   
    
    fileprivate let cellIdentifier = "photoCell"
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
         let url = URL(string: "https://api.opendota.com/api/heroStats")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil {
                do {
                    self.heroes =  try JSONDecoder().decode([Hero].self,from: data!)
                } catch {
                    print("parse error ")
                }
                DispatchQueue.main.async {
                    
                    self.collectionView.reloadData()                }
            }
        }.resume()
//        getData(url: APIURL)

        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        
        
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return ilText.count
        return heroes.count
      }
      
      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! photoCell
        
           
        cell.il.text = heroes[indexPath.row].localized_name.capitalized
        cell.iv.contentMode = .scaleAspectFill
        let defultLinke = "https://api.opendota.com"
        let completeLinke = defultLinke + heroes[indexPath.row].img
        cell.iv.downloaded(from: completeLinke)
        
                   return cell

        
      }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        var width = (screenWidth-30)/2
        width = width > 200 ? 200 : width
        return CGSize.init(width: width, height: width)
    }
     
    }

