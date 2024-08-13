import UIKit

class PostsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLBL: UILabel!
    
    @IBOutlet weak var userNameLBL: UILabel!
    
    @IBOutlet weak var tagsLBL: UILabel!
    
    @IBOutlet weak var descrLBL: UILabel!
    
    
    
       // Called when the cell is loaded from the Storyboard
       override func awakeFromNib() {
           super.awakeFromNib()
           // Configure the cell's UI elements
           titleLBL.font = UIFont.boldSystemFont(ofSize: 18)
           descrLBL.numberOfLines = 0
       }

       // Called when the cell's selection state changes
       override func setSelected(_ selected: Bool, animated: Bool) {
           super.setSelected(selected, animated: animated)
           // Change the background color based on selection
           contentView.backgroundColor = selected ? UIColor.lightGray : UIColor.white
       }

       // Method to configure the cell with a Post object
       func configure(with post: Post) {
           titleLBL.text = post.title
           userNameLBL.text = post.userName
           tagsLBL.text = post.category.rawValue // Display the category in place of tags
           descrLBL.text = post.description
       }
   }
