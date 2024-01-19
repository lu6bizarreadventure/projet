//
//  DocumentTableViewController.swift
//  projet
//
//  Created by Lucie GAROFALO on 1/17/24.
//

import UIKit
import SwiftUI
import QuickLook

extension Int {
    func formattedSize() -> String{
        return ByteCountFormatter.string(fromByteCount: Int64(self), countStyle: ByteCountFormatter.CountStyle.file)
    }
}

extension DocumentTableViewController: QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return urlToPreview as QLPreviewItem
    }
}

class DocumentTableViewController: UITableViewController, QLPreviewControllerDelegate, UIDocumentPickerDelegate {

    var urlToPreview = NSURL()
    
    struct DocumentFile {
        var title: String
        var size: Int
        var imageName: String? = nil
        var url: URL
        var type: String
    }
    
    var files: [DocumentFile] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        files = listFileInBundle()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addDocument))
    }

    // MARK: - Table view data source
    
    @objc func addDocument() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.jpeg, .png])
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    func

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rowsß
        return files.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell", for: indexPath)

        // Configure the cell...
        let document = files[indexPath.row]
        cell.textLabel?.text = document.title
        cell.detailTextLabel?.text = document.size.formattedSize()

        return cell
    }
    
    // declaration de la fonction
    func listFileInBundle() -> [DocumentFile] {
            
            // on vient recupérer le FileManager
            let fm = FileManager.default
            // on initialise path avec le path du bundle
            let path = Bundle.main.resourcePath!
            // on recupère le contenu du path
            let items = try! fm.contentsOfDirectory(atPath: path)
            // ligne vide
        
            // on crée le tableau de DocumentFile
            var documentListBundle = [DocumentFile]()
            // ligne vide
        
            // on parcoure tous les fichiers du path
            for item in items {
                // on controle si ça fait partie des items qu'on veut recup
                if !item.hasSuffix("DS_Store") && item.hasSuffix(".jpg") {
                    // on met l'url
                    let currentUrl = URL(fileURLWithPath: path + "/" + item)
                    // on essaie d'ajouter l'url au resources avec le type le nom et la taille
                    let resourcesValues = try! currentUrl.resourceValues(forKeys: [.contentTypeKey, .nameKey, .fileSizeKey])
                    // ligne vide
                    
                    // on ajoute à la liste un nouvel objet correspondant
                    documentListBundle.append(DocumentFile(
                        // on met le titre
                        title: resourcesValues.name!,
                        // on met la taille
                        size: resourcesValues.fileSize ?? 0,
                        // on met le nom de l'image
                        imageName: item,
                        // on met l'url
                        url: currentUrl,
                        // on met les resources
                        type: resourcesValues.contentType!.description)
                    // fin de document
                    )
                // fin de if
                }
            // fin de for
            }
            // retour de la liste
            return documentListBundle
        // fin de la fonction
        }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let destination = segue.destination as? DocumentViewController
//        let index = tableView.indexPathForSelectedRow?.row
//        if index != nil, destination != nil {
//            destination!.imageName = files[index!].imageName
//        }
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let file = files[indexPath.row]
        // A vous de coder cette fonction
        self.instantiateQLPreviewController(withUrl: file.url)
    }
    
    func instantiateQLPreviewController(withUrl url: URL) {
        self.urlToPreview = url as NSURL
        let previewController = QLPreviewController()
        previewController.dataSource = self
        
        previewController.delegate = self
        present(previewController, animated: true)
    }
    
    func previewControllerDidDismiss(_ controller: QLPreviewController) {
        dismiss(animated: true, completion: nil)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
