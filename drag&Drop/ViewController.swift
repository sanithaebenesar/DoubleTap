//
//  ViewController.swift
//  drag&Drop
//
//  Created by CH 002 on 17/11/22.
//

import UIKit

class ViewController: UIViewController {
    
    var data = ["a","b","c","d","e","f","g","h","i","j","k","l","m"]
    
    var data2 = ["123123","1e3131","123123","1e3131","123123","1e3131","123123","1e3131","123123","1e3131","123123","1e3131","123123","1e3131","123123","1e3131","123123","1e3131","123123","1e3131"]
    
    @IBOutlet weak var orderListCollectionView: UICollectionView!
    
    @IBOutlet weak var OrderCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        orderListCollectionView.delegate = self
        orderListCollectionView.dataSource = self
        OrderCollectionView.delegate = self
        OrderCollectionView.dataSource = self
        orderListCollectionView.reloadData()
        OrderCollectionView.reloadData()
        self.orderListCollectionView.dragInteractionEnabled = true
        self.orderListCollectionView.dragDelegate = self
        self.orderListCollectionView.dropDelegate = self
        
        //CollectionView-2 drag and drop configuration
        self.OrderCollectionView.dragInteractionEnabled = true
        self.OrderCollectionView.dropDelegate = self
        self.OrderCollectionView.dragDelegate = self
        self.OrderCollectionView.reorderingCadence = .fast
        
    }
   func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView)
    {
        let items = coordinator.items
        if items.count == 1, let item = items.first, let sourceIndexPath = item.sourceIndexPath
        {
            var dIndexPath = destinationIndexPath
            if dIndexPath.row >= collectionView.numberOfItems(inSection: 0)
            {
                dIndexPath.row = collectionView.numberOfItems(inSection: 0) - 1
            }
            collectionView.performBatchUpdates({
                if collectionView === self.orderListCollectionView
                {
                    self.data2.remove(at: sourceIndexPath.row)
                    self.data2.insert(item.dragItem.localObject as! String, at: dIndexPath.row)
                }
                else
                {
                    self.data.remove(at: sourceIndexPath.row)
                    self.data.insert(item.dragItem.localObject as! String, at: dIndexPath.row)
                }
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [dIndexPath])
            })
            coordinator.drop(items.first!.dragItem, toItemAt: dIndexPath)
        }
    }
    
   func copyItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView)
    {
        collectionView.performBatchUpdates({
            var indexPaths = [IndexPath]()
            for (index, item) in coordinator.items.enumerated()
            {
                let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)
                if collectionView === self.OrderCollectionView
                {
                    self.data2.insert(item.dragItem.localObject as! String, at: indexPath.row)
                }
                else
                {
                    self.data.insert(item.dragItem.localObject as! String, at: indexPath.row)
                }
                indexPaths.append(indexPath)
            }
            collectionView.insertItems(at: indexPaths)
        })
    }
    
}

extension ViewController : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == orderListCollectionView{
        return data.count
        }
        else{
            return data2.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == orderListCollectionView{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PrepareCollectionCell", for: indexPath) as! PrepareCollectionCell
        let data1 = data[indexPath.row]
        cell.orderLabel.text = "\(data1)"
        cell.addPhoto.isHidden = false
        return cell
    }
    
    else {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SecCollectionCell", for: indexPath) as! SecCollectionCell
        let data3 = data2[indexPath.row]
        cell.oderLabel2.text = "\(data3)"
        return cell
    }
        
    }
}
extension ViewController :  UICollectionViewDragDelegate{

    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem]
    {
        let item = collectionView == orderListCollectionView ? self.data[indexPath.row] : self.data2[indexPath.row]
        let itemProvider = NSItemProvider(object: item as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem]
    {
        let item = collectionView == orderListCollectionView ? self.data[indexPath.row] : self.data2[indexPath.row]
        let itemProvider = NSItemProvider(object: item as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
    
    func collectionView(_ collectionView: UICollectionView, dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters?
    {
        if collectionView == orderListCollectionView
        {
            let previewParameters = UIDragPreviewParameters()
            previewParameters.visiblePath = UIBezierPath(rect: CGRect(x: 12, y: 12, width: 12, height: 12))
            return previewParameters
        }
        return nil
    }
}

extension ViewController : UICollectionViewDropDelegate
{
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool
    {
        return session.canLoadObjects(ofClass: NSString.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal
    {
        if collectionView === self.orderListCollectionView
        {
            if collectionView.hasActiveDrag
            {
                return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            }
            else
            {
                return UICollectionViewDropProposal(operation: .forbidden)
            }
        }
        else
        {
            if collectionView.hasActiveDrag
            {
                return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            }
            else
            {
                return UICollectionViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator)
    {
        let destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath
        {
            destinationIndexPath = indexPath
        }
        else
        {
            // Get last index path of table view.
            let section = collectionView.numberOfSections - 1
            let row = collectionView.numberOfItems(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }
        
        switch coordinator.proposal.operation
        {
        case .move:
            self.reorderItems(coordinator: coordinator, destinationIndexPath:destinationIndexPath, collectionView: collectionView)
            break
            
        case .copy:
            self.copyItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
            
        default:
            return
        }
    }
  
    
}
