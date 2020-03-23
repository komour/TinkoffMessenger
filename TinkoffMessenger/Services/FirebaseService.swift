//
//  FirebaseService.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 23.03.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import Foundation
import Firebase

class FirebaseService: FirebaseProtocol {
  var db = Firestore.firestore()
  
  func messagesReference(channelIdentifier: String) -> CollectionReference {
    return db.collection("channels").document(channelIdentifier).collection("messages")
  }
  
  func channelsReference() -> CollectionReference {
    return db.collection("channels")
  }
  
  func getDateFromTimestamp(receivedTimestamp: Any?) -> Date {
    let castedTimestamp = receivedTimestamp as? Timestamp ?? Timestamp(date: Date(timeIntervalSince1970: 10.0))
    return castedTimestamp.dateValue()
  }
}
