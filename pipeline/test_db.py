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


@pytest.fixture
def model() -> Model:
    return Model(field="test")


@pytest.mark.integration
def test_db_insert_get_delete_query(db: DatabaseClient, collection: str, model: Model):
    # test: insert model into collection
    key = db.insert(table=collection, data=model)
    assert len(key) > 0
    # test: get by key
    assert db.get(table=collection, key=key) == to_json_dict(model)
    # test: query by field value
    got_key = list(db.query(table=collection, field=("==", "test")))[0]
    assert got_key == key
    db.delete(collection, key)
