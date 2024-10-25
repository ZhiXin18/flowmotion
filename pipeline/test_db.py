#
# Flowmotion
# Firestore DB Client
# Integration Test
#


# Usage:
# - Google Application Default credentials should be provided to authenticate
#       with firestore eg. by setting GOOGLE_APPLICATION_CREDENTIALS env var.


from uuid import uuid4

import pytest
from pydantic import BaseModel

from data import to_json_dict
from db import DatabaseClient


class Model(BaseModel):
    field: str


@pytest.fixture(scope="session")
def db() -> DatabaseClient:
    return DatabaseClient()


@pytest.fixture(scope="session")
def collection(db: DatabaseClient):
    # unique collection name for testing
    name = f"test_db_{uuid4()}"
    yield name

    # empty collection of any existing documents to cleanup test collection
    collection = db._db.collection(name)
    for document in collection.list_documents():
        document.delete()


@pytest.mark.integration
def test_db_insert_get_max_delete_query(db: DatabaseClient, collection: str):
    # test: insert model into collection
    model_a, model_b = Model(field="A"), Model(field="B")
    key_a = db.insert(table=collection, data=model_a)
    key_b = db.insert(table=collection, data=model_b)
    assert len(key_a) > 0
    # test: get by key
    assert db.get(table=collection, key=key_a) == to_json_dict(model_a)
    # test: query by field value
    got_key = [key for key, _ in db.query(table=collection, field=("==", "A"))][0]
    assert got_key == key_a
    # test: get max for field value
    got_entry = db.max(table=collection, field="field")
    assert got_entry is not None
    assert got_entry[0] == key_b
    # test: delete for key
    db.delete(collection, key_a)
    assert db.get(table=collection, key=key_a) is None
