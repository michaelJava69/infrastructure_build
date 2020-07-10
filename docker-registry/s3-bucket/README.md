
links

```
https://icicimov.github.io/blog/docker/Docker-Private-Registry-with-S3-backend-on-AWS/
``

Create S3 Bucket and permissions for Instance holding Registry to communicate with it

```

S3 Bucket
=======


https://icicimov.github.io/blog/docker/Docker-Private-Registry-with-S3-backend-on-AWS/


create bucket
--------------
  
aws s3api create-bucket --bucket pipline-registry-bucket --region eu-west-2 — create-bucket-configuration LocationConstraint=eu-west-2

result:
 {
      "Location": "http://pipline-registry-bucket.s3.amazonaws.com/"
 }

aws s3api put-bucket-versioning --region eu-west-2 --bucket pipline-registry-bucket --versioning-configuration Status=Enabled

--Next is the IAM setup to control the bucket access. We add IAM Instance Profile that allows access to the DockerHub S3 bucket and attach it to the EC2 instance that will be running our Docker Registry. 
  The json file DockerHubS3Policy.json looks like:

nano :

{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket",
        "s3:GetBucketLocation",
        "s3:ListBucketMultipartUploads"
      ],
      "Resource": "arn:aws:s3:::pipline-registry-bucket"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject",
        "s3:ListMultipartUploadParts",
        "s3:AbortMultipartUpload"
      ],
      "Resource": "arn:aws:s3:::pipline-registry-bucket/*"
    }
  ]
}

--Create the policy based on the json file we created:

aws iam create-policy --policy-name DockerHubS3Policy --policy-document file://DockerHubS3Policy.json


result : DockerHubS3Policy

{
    "Policy": {
        "PolicyName": "DockerHubS3Policy",
        "PolicyId": "ANPA5FKVQQBHML2VZMHR7",
        "Arn": "arn:aws:iam::904806826062:policy/DockerHubS3Policy",
        "Path": "/",
        "DefaultVersionId": "v1",
        "AttachmentCount": 0,
        "PermissionsBoundaryUsageCount": 0,
        "IsAttachable": true,
        "CreateDate": "2020-07-08T11:58:55+00:00",
        "UpdateDate": "2020-07-08T11:58:55+00:00"
    }
}


--Now we create an IAM Role. First the policy file TrustPolicy.json:

nano:

{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}

aws iam create-role --role-name DockerHubS3Role --assume-role-policy-document file://TrustPolicy.json

result:
{
    "Role": {
        "Path": "/",
        "RoleName": "DockerHubS3Role",
        "RoleId": "AROA5FKVQQBHHRPGGN277",
        "Arn": "arn:aws:iam::904806826062:role/DockerHubS3Role",
        "CreateDate": "2020-07-08T12:03:49+00:00",
        "AssumeRolePolicyDocument": {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Effect": "Allow",
                    "Principal": {
                        "Service": "ec2.amazonaws.com"
                    },
                    "Action": "sts:AssumeRole"
                }
            ]
        }
    }
}

--Then we attach the Policy to the Role:
aws iam attach-role-policy --role-name DockerHubS3Role --policy-arn arn:aws:iam::904806826062:policy/DockerHubS3Policy


--Next we create Instance Profile and attach the Role to it:
aws iam create-instance-profile --instance-profile-name DockerHubS3Profile

result:
{
    "InstanceProfile": {
        "Path": "/",
        "InstanceProfileName": "DockerHubS3Profile",
        "InstanceProfileId": "AIPA5FKVQQBHKT5FV4QQ6",
        "Arn": "arn:aws:iam::904806826062:instance-profile/DockerHubS3Profile",
        "CreateDate": "2020-07-08T12:11:45+00:00",
        "Roles": []
    }
}
aws iam add-role-to-instance-profile --role-name DockerHubS3Role --instance-profile-name DockerHubS3Profile

--and finally we attach the IAM Instance Role to an existing EC2 instance that was originally launched without an IAM role:


aws ec2 associate-iam-instance-profile --instance-id i-0407f57b3d5e0770b --iam-instance-profile Name=DockerHubS3Profile

result:

{
    "IamInstanceProfileAssociation": {
        "AssociationId": "iip-assoc-0e2b80e2b3b55452d",
        "InstanceId": "i-0407f57b3d5e0770b",
        "IamInstanceProfile": {
            "Arn": "arn:aws:iam::904806826062:instance-profile/DockerHubS3Profile",
            "Id": "AIPA5FKVQQBHKT5FV4QQ6"
        },
        "State": "associating"
    }
}
For above make sure config file has correct region stated

```


