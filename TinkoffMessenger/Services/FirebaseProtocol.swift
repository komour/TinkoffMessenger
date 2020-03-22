//
//  FirebaseProtocol.swift
//  TinkoffMessenger
//
//  Created by Always Strive And Prosper on 23.03.2020.
//  Copyright © 2020 komarov. All rights reserved.
//

import Foundation
import Firebase

protocol FirebaseProtocol {
  var db: Firestore { get }
  func messagesReference(channelIdentifier: String) -> CollectionReference
  func channelsReference() -> CollectionReference
  func getDateFromTimestamp(receivedTimestamp: Any?) -> Date
}
