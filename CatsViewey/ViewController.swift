//
//  ViewController.swift
//  CatsViewey
//
//  Created by Andrii on 05.10.2021.
//

import UIKit


class ViewController: UIViewController, UITableViewDataSource {
    
    private let viewModel = MainViewModel()
    
    @IBOutlet weak var innerSpinner: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        spinner.startAnimating()

        tableView.dataSource = self
        tableView.register(
            UINib(nibName: "CatTableViewCell", bundle: nil),
            forCellReuseIdentifier: "catCell"
        )
        
        viewModel.updateView = { [weak self] in
            DispatchQueue.main.async {
                self?.spinner.stopAnimating()
                self?.innerSpinner.startAnimating()
                self?.tableView.reloadData()
            }
        }
        viewModel.getImageList()
    }
    
    //MARK: DataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let uuid = UUID()
        let cell = tableView.dequeueReusableCell(withIdentifier: "catCell") as! CatTableViewCell

        viewModel.getImageForCell(index: indexPath.row, cell: uuid) { data in
            DispatchQueue.main.async {
                cell.imageCell.image = UIImage(data: data)
            }
        }

        cell.imageName.text = viewModel.getTextForCell(index: indexPath.row)

        cell.reuseForCancel = { [weak self] in
            self?.viewModel.cellReused(uuid)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getPhotosCount()
    }

}
