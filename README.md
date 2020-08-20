## Mediawiki
<p>This repo contains Terraform scripts and Chef recipes to install and run MediaWiki on AWS. As part of cloud infrastructure the following resources are created EC2, ELB, ASG, LC and follows Blue/Green deployment</p>



#### Tools and Services Used:
  1. Cloud Deployment: AWS
  2. Infrastructure automation: Terraform
  3. Configuration management: Chef



### Pre-requisite:
  1. AWS account
  2. Creation of S3 bucket to store statefile, IAM role for EC2, SG's for EC2, ELB, RDS.
  3. Terraform installation v0.12.2



### Deployment procedure:
  1. Find the screenshots of S3, IAM and SG's [here](https://github.com/antonyRepo/mediawiki/tree/master/screenshots/pre_requisite).
  
  2. RDS creation: Run the below commands to create the DB instance. <br>
         <i>Click [here](https://github.com/antonyRepo/mediawiki/tree/master/aws_infra/rds) for Terraform scripts <br> 
         Click [here](https://github.com/antonyRepo/mediawiki/tree/master/screenshots/rds) for screenshots</i>
  
          export AWS_ACCESS_KEY_ID=****************
          export AWS_SECRET_ACCESS_KEY=**********************
          export AWS_DEFAULT_REGION=ap-south-1
          terraform init
          terraform plan -var "username=root" -var "password=****" -out=plan.out
          terraform apply plan.out
  
  3. Follow the [doc](https://www.mediawiki.org/wiki/Manual:Running_MediaWiki_on_Red_Hat_Linux) to create a <i>wiki</i> user on the DB.
  
  4. Frontend creation: Run the below commands to bring up the stack. <br> 
        <i>Click [here](https://github.com/antonyRepo/mediawiki/tree/master/aws_infra/frontend) for Terraform scripts <br> 
         Click [here](https://github.com/antonyRepo/mediawiki/tree/master/screenshots/frontend) for screenshots</i>
         
          export AWS_ACCESS_KEY_ID=****************
          export AWS_SECRET_ACCESS_KEY=**********************
          export AWS_DEFAULT_REGION=ap-south-1
          terraform init --backend-config="key=state-files/<color>/terraform.tfstate"
          terraform plan -var "keep=1" -var "color=<color>" -var "wiki_version=<wiki_version>" -out=plan.out
          terraform apply plan.out

      <i>Note:</i> To teardown the stack run the above commands with <b>keep</b> parameter value to <b>0</b>
   
   5. EC2's userdata installs Chef and runs the recipes to install mediawiki and start the apache.
        <i>Click [here](https://github.com/antonyRepo/mediawiki/tree/master/chef_config_mng) for Chef cookbooks </i> 
  


### Scaling:
<p>To handle scaling, application is deployed on EC2's managed by Auto scaling group. ASG adds an instance to the fleet of instances if the CPU utilization breaches the threshold of 70%. To support image and media files upload which requires persistent storage, Amazon S3 or EFS can be used. Currently we may loose the instance storage during scaling activity. </p>


### Future Enhancements:
  1. Creation of Weighted Route53 for switching traffic between Blue and Green stack.
  2. Top level simple Route53 for common CNAME.
  3. Integrate Jenkins for Continuous Blue/Green deployment.<br>
      a. 1st Stage to get the active stack color (blue/green)<br>
      b. 2nd Stage to bring up the stack of opposite color and with latest media wiki version<br>
      c. 3rd Stage to test new stack and switch traffic<br>
      d. 4th Stage to teardown the old stack
  4. Enable support for Images and store the images in Amazon S3 or EFS to share across all EC2's to make it persistent.
  5. Enable support for uploading and integration of media files.
