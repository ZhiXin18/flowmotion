#
# Flowmotion
# Pipeline
# Time Utitilties
#


from datetime import datetime
from zoneinfo import ZoneInfo


def datetime_sgt() -> datetime:
    """Get the current timestamp in the SGT timezone."""
    return datetime.now(ZoneInfo("Asia/Singapore"))
