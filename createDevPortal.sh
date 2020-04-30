sam package --template-file ./cloudformation/template.yaml \
    --output-template-file ./cloudformation/packaged.yaml \
    --s3-bucket sitigrid-lambda-artifacts

sam deploy --template-file ./cloudformation/packaged.yaml \
    --stack-name "dev-portal" \
    --s3-bucket sitigrid-lambda-artifacts \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameter-overrides \
    --region $REGION \
    DevPortalSiteS3BucketName="sitigrid-dev-portal-static-assets" \
    ArtifactsS3BucketName="sitigrid-dev-portal-artifacts" \
    CognitoDomainNameOrPrefix="sitigrid"

aws cloudformation describe-stacks --region $REGION --query \
    "Stacks[?StackName=='dev-portal'][Outputs[?OutputKey=='WebsiteURL']][][].OutputValue"
