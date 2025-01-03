#
# Flowmotion
# Pipeline
# Firestore DB Client
#

from typing import Any, Iterable, Optional, cast

import firebase_admin
from firebase_admin import firestore
from google.cloud.firestore import DocumentReference, Query
from pydantic import BaseModel

from data import to_json_dict


class DatabaseClient:
    Row = dict[str, Any]
    Entry = tuple[str, Row]
    """Firestore Database (DB) client"""

    def __init__(self) -> None:
        """Creates a new Firestore DB client.

        Uses Google Application Default credentials with authenticate DB requests.
        See https://firebase.google.com/docs/admin/setup#initialize-sdk.
        """
        app = firebase_admin.initialize_app(options={"projectId": "flowmotion-4e268"})
        self._db = firestore.client(app)

    def insert(self, table: str, data: BaseModel) -> str:
        """
        Inserts the given data into the specified table.

        Args:
            table: Name of Firestore collection to insert to.
            data: Pydantic model to insert as a document.
        Returns:
            Key of the inserted firebase document.
        """
        _, doc = self._db.collection(table).add(to_json_dict(data))
        return _to_key(doc)

    def update(self, table: str, key: str, data: BaseModel):
        """
        Updates the given data into the specified table.

        Args:
            table: Name of Firestore collection to update to.
            key: Key specifying the Firestore document to update.
            data: Pydantic model to update Firestore document's contents
        """
        self._db.collection(table).document(_doc_id(key)).set(to_json_dict(data))

    def delete(self, table: str, key: str):
        """
        Deletes the row (document) with key from the specified table.

        Args:
            table: Name of Firestore collection to delete from.
            key: Key specifying the Firestore document to delete.
        """
        self._db.collection(table).document(_doc_id(key)).delete()

    def get(self, table: str, key: str) -> Optional[Row]:
        """
        Retrieves the contents of the row (document) with key from the specified table.

        Args:
            table: Name of Firestore collection to delete from.
            key: Key specifying the Firestore document to delete.
        Returns:
            Contents of matching document as dict or None if not such document exists.
        """
        return self._db.collection(table).document(_doc_id(key)).get().to_dict()

    def query(self, table: str, **params) -> Iterable[Entry]:
        """
        Query all keys & rows (Firestore documents) on the specified table that match params.

        Args:
            table: Name of Firestore collection to query from.
            params: Query parameters are given as document fields in in the format
                <field>=(<operator>, <value>) where:
                - <field> is a field path "<name>[__<subfield>...]" which refers the documents
                    <name> field (or <name>.<subfield> if optional sub field name is specified).
                - <operator> is one of Firestore's supported operators.
                    See https://firebase.google.com/docs/firestore/query-data/queries
                - <value> is used by the operator to find matching rows.
        Example:
            Get User rows with `name="john"`:

                db = DatabaseClient()
                entries = db.query("Users", name=("==", "john"))

        Returns:
            Iterator of matching keys & rows in on the table.
        """
        # build query by applying query params
        collection = self._db.collection(table)
        for field, (op, value) in params.items():
            collection = collection.where(
                field_path=field.replace("__", "."), op_string=op, value=value
            )

        for document in collection.stream():
            yield _to_key(document.reference), document.to_dict()

    def max(self, table: str, field: str) -> Optional[Entry]:
        """Retrieves the key & row (Firestore document) with the  max value of the selected field in collection.

        Args:
            table: Name of Firestore collection to query from.
            field: field path "<name>[__<subfield>...]" which refers the documents
                    <name> field (or <name>.<subfield> if optional sub field name is specified).
        Returns:
            The key & row with maximum value of the specified field or None if no value
                is stored for the field.
        """
        results = (
            self._db.collection(table)
            .order_by(field.replace("__", "."), direction=Query.DESCENDING)
            .limit(1)
            .get()
        )
        if len(results) <= 0:
            return None
        return _to_key(results[0].reference), cast(
            DatabaseClient.Row, results[0].to_dict()
        )


def _to_key(ref: DocumentReference) -> str:
    return cast(DocumentReference, ref).path


def _doc_id(key: str) -> str:
    return key.split("/")[-1]
