#!/bin/bash

PROJECT_ID=

gcloud iam service-accounts create packer --project $PROJECT_ID --description="Packer Service Account" --display-name="Packer Service Account"
gcloud projects add-iam-policy-binding $PROJECT_ID --member=serviceAccount:packer@$PROJECT_ID.iam.gserviceaccount.com --role=roles/compute.instanceAdmin.v1 --project $PROJECT_ID
gcloud projects add-iam-policy-binding $PROJECT_ID --member=serviceAccount:packer@$PROJECT_ID.iam.gserviceaccount.com --role=roles/iam.serviceAccountUser --project $PROJECT_ID
gcloud iam service-accounts keys create packer-ops.json --iam-account=packer@$PROJECT_ID.iam.gserviceaccount.com --project $PROJECT_ID
