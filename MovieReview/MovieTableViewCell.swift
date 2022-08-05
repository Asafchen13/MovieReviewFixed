//
//  MovieTableViewCell.swift
//  MovieReview
//
//  Created by Asaf Chen on 27/06/2022.
//

import UIKit
import Kingfisher


class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var title_LBL: UILabel!
    @IBOutlet weak var image_IMG: UIImageView!


    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static let identifier = "MovieTableViewCell"
    
 /*   static func nib() -> UINib {
        return UINib(nibName: "MovieTableViewCell", bundle: nil)
    }*/
    
    func setUpView(with movie: Movie) {
        let url = URL(string: movie.Poster)
        image_IMG.kf.setImage(with: url)
        title_LBL.text = movie.Title
       
        }
    }
    
    


