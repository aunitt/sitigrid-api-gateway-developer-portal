## Introduction
The Sitigrid API Developer Portal is built upon the Amazon API Gateway Serverless Developer Portal documented here: 
[https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-developer-portal.html](https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-developer-portal.html).

This developer portal is deployed using SAR.

### Prerequisites for development

First, ensure you have the [latest version of the SAM CLI installed](https://docs.aws.amazon.com/lambda/latest/dg/sam-cli-requirements.html). Note that while the instructions specify Docker as a pre-requisite, you can safely skip this.

## Registering Users
Users can self-register by clicking the 'Register' button in the developer portal. Cognito calls the `CognitoPreSignupTriggerFn` lambda to determine if the user is allowed to register themselves. By default, this function always accepts the user into the user pool, but you can customize the body of the function either in a local repository (followed by packaging and deploying) or in the lambda console. Documentation on this lambda function's use can be found [here](https://docs.aws.amazon.com/cognito/latest/developerguide/user-pool-lambda-pre-sign-up.html).

### Promoting a User to an Admin
Admin users can manage what APIs are visible to normal users and whether or not SDK generation is enabled (per api) for normal users. To promote a user to an admin, go to the Cognito console in the account the developer portal is in, select User Pools, then select the correct User Pool for the dev portal. From there, choose Users and groups, click on the users' name, choose Add to group, and select the group named `STACK-NAMEAdminsGroup`. This user is now an admin; if they're currently logged in, they will have to log out and back in to receive admin credentials.

### Testing APIs

When logged into the developer portal with an account that has a provisioned api key, you should be able to test your APIs by selecting a resource/method in them and clicking "Try it out!". Note that this requires CORS to be set up on your API to allow the developer portal to call it. Note that the default PetStore has CORS enabled on all resources but `/`.

### To update SAR deployment
1. When deploying follow the same steps as previous and use the same values for the parameters. The only difference is passing in a new value for the stack parameter StaticAssetRebuildToken.

## Components
For an overview of the components of the developer portal, please see [this page](https://github.com/awslabs/aws-api-gateway-developer-portal/wiki/Components).

## Debugging

You can trace and troubleshoot the Lambda functions using CloudWatch Logs. See [this blog post](https://aws.amazon.com/blogs/compute/techniques-and-tools-for-better-serverless-api-logging-with-amazon-api-gateway-and-aws-lambda/) for more information.

## Tear-down

Deleting the developer portal should be as easy as deleting the cloudformation stack. This will empty the `ArtifactsS3Bucket` and `DevPortalSiteS3Bucket` s3 buckets, including any custom files! Note that this will not delete any api keys provisioned by the developer portal. If you would like to delete api keys provisioned through the developer portal but not those provisioned through other means, make sure to download a backup of the `Customers` DDB table before deleting the cloudformation stack. This table lists the provisioned api keys that will need to be cleaned up afterwards.
