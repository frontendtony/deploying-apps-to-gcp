#!/bin/bash

gcloud app create --region=us-central

gcloud app deploy --version=one --quiet