import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import json

cred = credentials.Certificate('path/to/your/serviceAccountKey.json')
firebase_admin.initialize_app(cred)

db = firestore.client()

with open('data.json', 'r') as file:
    data = json.load(file)

def upload_to_firestore(data):
    for item in data:
        doc_ref = db.collection('users').add(item)
        print(f"Uploaded document with ID: {doc_ref[1].id}")

upload_to_firestore(data)