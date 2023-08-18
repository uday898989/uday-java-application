
STEP-1 : Launch a SonarQube Virtual Machine/Instace OR Containerise Or SaaS

STEP-2 : Login to SonarQube 

STEP-3 : Create a Project in SonarQube 

    - Oragnisation Name : 
    - Project Name : 
    - Type of Project : 
    - Project URL :
    - Project Key :

STEP-4 : Take the above details and integrate with SCM/VCS i.e. Source Code pom.xml

STEP-5 : Create a CodeBuild Job in AWS & Execute Sonar Goal

# mvn verify sonar:sonar 

STEP-6 : Validate & Clean Up!



version: 0.2

phases:
  install:
    runtime-versions:
      java: corretto11
  pre_build:
    commands:
      - echo "Download JQ"
      - curl -qL -o jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 && chmod +x ./jq
      - mv jq /usr/local/bin 
      - echo "Install Hashicorp Terraform"
      - wget https://releases.hashicorp.com/terraform/1.1.0/terraform_1.1.0_linux_amd64.zip
      - unzip terraform_1.1.0_linux_amd64.zip
      - ls -lrt
      - pwd
      - ls -lrt
      - mv terraform /usr/local/bin/
      - pwd
      - ls -lrt /usr/local/bin/terraform
      #- sudo mv /usr/local/bin/terraform_* /usr/local/bin/terraform
      - ls -lrt $CODEBUILD_SRC_DIR/
      - cd $CODEBUILD_SRC_DIR/
      - terraform -v 
      - echo "Configuring AWS Credentials"
      - export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_IDs_PARAM
      - export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY_PARAM
      - terraform init 
      - terraform fmt
      - terraform validate 
      - pwd
      - ls -lrta 

  build:
    commands:
      - echo "Executing Build Phase"
      - ls -lrt $CODEBUILD_SRC_DIR
      - cd $CODEBUILD_SRC_DIR
      - pwd
      - ls -lrta
      - terraform -v 
      - terraform plan
      #- terraform apply -auto-approve 
  post_build:
    commands:
      - echo "Infra Job is completed on `date`"

      