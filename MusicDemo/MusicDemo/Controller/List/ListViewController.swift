//
//  ViewController.swift
//  MusicDemo
//
//  Created by  on 23/09/19.


import UIKit

class ListViewController: UIViewController {

   
    //MARK:- Variable Declaration
    var arrSongList = Constants.loadSongArray()
    
    //MARK:- IBOutlets
    @IBOutlet weak var tblListSongs:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblListSongs.tableFooterView = UIView()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        arrSongList = Constants.loadSongArray()
        tblListSongs.reloadData()
    }


}

//MARK:- UITableView DataSourse and Delegate Methods
extension ListViewController:UITableViewDelegate , UITableViewDataSource{
    
    // number of row Count Pass in this method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSongList.count
    }
    
     // setup & load cell here
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell") as! ListCell
        cell.obj = arrSongList[indexPath.row]
      return cell
    }
    // Select Song Code here
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        arrSongList[indexPath.row].isSelected = !arrSongList[indexPath.row].isSelected
        let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "SongDetailVC") as! SongDetailVC
        nextVc.AudioURL = self.arrSongList
        nextVc.currentIndex = indexPath.row
        _ = self.navigationController?.pushViewController(nextVc, animated: true)
    }
    
    // Pass height OF Cell here
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

