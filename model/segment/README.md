# Segmentation Model

## Setup
Large files have been removed from this repository to save space. You can download the files using **gsutil** from the provided Google Cloud Storage bucket.
- Install **gsutil**: [gsutil installation guide](https://cloud.google.com/storage/docs/gsutil_install)
- Use the following **gsutil** commands to download the missing folders

```bash
gsutil cp -r gs://flowmotion-4e268.appspot.com/model/segment/cvatseg_road/ .
gsutil cp -r gs://flowmotion-4e268.appspot.com/model/segment/data/ .
gsutil cp -r gs://flowmotion-4e268.appspot.com/model/segment/runs/ .
gsutil cp -r gs://flowmotion-4e268.appspot.com/model/segment/tmp/ .
```
