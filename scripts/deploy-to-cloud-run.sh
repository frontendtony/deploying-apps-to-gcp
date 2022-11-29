#!/bin/bash

# deploy already created image to cloud run
gcloud run deploy devops-image \
--image=gcr.io/gads-370102/devops-image@sha256:a04e4b72bfe0b03f3eace69715eb2d1ac87c3995550efba849126904e432012a \
--allow-unauthenticated \
--region=us-central1