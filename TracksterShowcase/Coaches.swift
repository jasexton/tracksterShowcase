//
//  Coaches.swift
//  TracksterShowcase
//
//  Created by Jack Sexton on 4/29/18.
//  Copyright © 2018 Jack Sexton. All rights reserved.
//

import Foundation
import Firebase

class Coaches
{
    var coachArray: [Coach] = []
    var db: Firestore!
    
    init()
    {
        db = Firestore.firestore()
    }
    // Load data from coaches - not exactly sure how it works, but building block from one of keynotes
    func loadData(completed: @escaping () -> ())
    {
        db.collection("coaches").addSnapshotListener { (querySnapshot, error) in
            self.coachArray = []
            guard error == nil else {
                print("*** ERROR: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            // there are querySnapshot!.documents.count documents
            for document in querySnapshot!.documents
            {
                let coach = Coach(dictionary: document.data())
                coach.documentID = document.documentID
                coach.loadImage
                {
                    print("Image Loaded!")
                }
                self.coachArray.append(coach)
            }
            completed()
        }
        
    }
    
    
}
