# Flutter Firebase, Awesome Notifications, RxDart 🚀

A Flutter project demonstrating about

- Authentication with firebase
- Database management with firebase
- Storage management with firebase
- Managing app state with rx-dart
- Showing notifications with locally and remotely

## Firestore Database

- `Collection`
  - Contains documents and nothing else.
  - Can't directly contain raw fields with values, and can't contain other collections
- `CollectionReference`
  - Can be used for adding documents, getting document references, and querying for documents
- `DocumentReference`
  - Refers to a document location in a Firestore database
  - Can be used to write, read, or listen to the location
- `DocumentSnapshot`
  - An immutable representation for a document in a Firestore database.
- `Query`
  - Refers to a query which you can read or stream from
- `QueryDocumentSnapshot`
  - Contains data read from a document in your Firestore database as part of a query
  - Offers the same API surface as a DocumentSnapshot
- `QuerySnapshot`
  - Contains zero or more QueryDocumentSnapshot objects representing the results of a query

## Firestore CollectionReference Operations

- `snapshots()`
  - Stream of querySnapshot
- `get()`
  - Future of querySnapshot
- `where(...)`
  - Filters documents based on specific condition
- `orderBy(...)`
  - Filters documents in descending or ascending order
- `limit(int limit)`
  - limits the number of documents
- `orderBy(Object field1).where(Object field1, ...)`
  - filter documents base on conditions
  - The initial orderBy() field should be same as the where() field when an inequality operator is invoked
- `orderBy(Object field1).where(Object field1, ...).orderBy(Object field2)`
  - filter documents base on conditions
  - Use of orderBy() field again after initial query and pass different field to it
- `withConverter<R>(FromFirestore<R> fromFirestore, ToFirestore<R> toFirestore)`
  - Transforms a CollectionReference to manipulate a custom object instead of a Map<String, dynamic>
- `add(Map<Sting, dynamic> json)`
  - Takes a json value and adds a document in the collection
- `doc(String? path)`
  - Gives a document reference with the provided path

## Firestore QueryDocumentSnapshot Operations

- `id`
  - Gives document id for the snapshot
- `reference`
  - Gives the reference of the snapshot
- `data()`
  - Contains all the data of the document snapshot
- `get(Object field)`
  - Gives the field value

## Firestore DocumentReference Operations

- `firestore`
  - The Firestore instance associated with this document reference
- `id`
  - This document's given ID within the collection
- `parent`
  - The parent CollectionReference of this document
- `collection(string collectionPath)`
  - Gets a CollectionReference instance that
  - Refers to the collection at the specified path, relative from this DocumentReference
  - Example, Chat Collection has a nested Message Collection, get Message Collection from a chat document
- `delete()`
  - Deletes the current document from the collection
- `update(Map<Object, Object?> data)`
  - Updates data on the document
  - Data will be merged with any existing document data
  - Does not create new document or field
- `get([GetOptions? options])`
  - Future of documentSnapshot
- `snapshots({bool includeMetadataChanges = false})`
  - Stream of documentSnapshot
- `set(T data, [SetOptions? options])`
  - Sets data on the document, overwriting any existing data
  - If the document does not yet exist, it will be created
  - If SetOptions are provided, the data can be merged into an existing document instead of overwriting
  - It can create new document or field if not presented
- `withConverter<R>({FromFirestore<R> fromFirestore, ToFirestore<R> toFirestore,})`
  - Transforms a DocumentReference to manipulate a custom object instead of a Map<String, dynamic>

## Awesome Notifications

### Local

- `Initialize local notifications`
  - Provide channel key, name, description and other properties
  - Provide custom icon and sound
- `Get initial notification actions`
  - Do operation when the app is opened
  - Navigate to specific page when the app is opened by a notification
- `Request for notification permission`
  - Allow device to send notification
- `Create local notifications`
  - basic notifications
  - scheduled notifications
- `Listen notifications action events`
  - onNotificationCreatedMethod
  - onNotificationDisplayedMethod
  - onActionReceivedMethod
  - onDismissActionReceivedMethod

### (Firebase)

- `Initialize firebase notifications`
  - onFcmTokenHandle
  - onNativeTokenHandle
  - onFcmSilentDataHandle
- `Request firebase token`
  - Get the firebase token
- `Delete token`
