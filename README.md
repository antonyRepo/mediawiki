## Mediawiki
<p>The repo contains Terraform scripts and Chef recipes to download, install and run MediaWiki on AWS. The repo contains 3 folders:<br></p>

1. [chef_config_mng](https://github.com/antonyRepo/mediawiki/tree/master/chef_config_mng): Holds the Chef recipes that provisions media wiki inside an EC2 instance, it does the following actions.<br>
    1. Installs all dependencies eg: mysql, php.
    2. Downloads the mediawiki tar ball and extracts the contents.
    3. Replace the httpd.conf file.
    4. Adds the LocalSettings.php.
    5. Starts httpd.

2. [frontend](https://github.com/antonyRepo/mediawiki/tree/master/frontend): Terraform scripts to spin up AWS infrastructure
    1. The following resources are created as part of the infrasructure: <i>EC2, Load Balancer, AutoScaling, Launch Configuration, CLoudwatch alarm.</i>
    2. After provisioning, the EC2 userdata downloads the above Chef cookbooks to install media wiki.
    3. Follows blue green deployment pattern.

3. [rds](https://github.com/antonyRepo/mediawiki/tree/master/frontend): Terraform scripts to create AWS RDS instance.
    1. DB used to store wiki pages.
    2. The frontend communicates with the AWS rds used for persistent storage. 


#### Tools and Services Used:
  1. Cloud Deployment: AWS
  2. Infrtstructure automation: Terraform
  3. Configuration management: Chef


### Pre-requisite:
  1. An AWS account.
  2. Create a new user and generate the Access and the Secret key. 
  3. Create S3 bucket (to store state file), IAM role, 3 Security Groups for EC2 ELB and RDS. 
  4. Install Terraform v0.12.2 on the local machine.
  5. Example screenshots can be found here [here](https://github.com/antonyRepo/mediawiki/tree/master/screenshots/pre_requisite).


### Deployment procedure:
  
  1. RDS creation: After cloning the repo, go under "rds/variables.tf" and edit the variables.tf file associating parameters to your AWS account and run the below commands to create an RDS instance. <br>
     Have the access and secret key handy generated as part of pre-requisite which has to be exported before running terraform scripts.
         <i>Click [here](https://github.com/antonyRepo/mediawiki/tree/master/screenshots/rds) for screenshots</i>
  
          cd rds
          export AWS_ACCESS_KEY_ID=****************
          export AWS_SECRET_ACCESS_KEY=**********************
          export AWS_DEFAULT_REGION=ap-south-1
          terraform init
          terraform plan -var "username=root" -var "password=****" -out=plan.out
          terraform apply plan.out
  
  2. Follow the [doc](https://www.mediawiki.org/wiki/Manual:Running_MediaWiki_on_Red_Hat_Linux) to create a <i>wiki</i> user on the DB and grant necessary permission.
  
  3. Frontend creation: Once the RDS instance is created, we can bring up frontend to deploy media wiki on EC2 instance. Go under "frontend/constants/variables.tf" and update the variable parameters according to your AWS account eg: Subnets, SG's etc. Run the below commands to bring up the stack. <br> 
        <i>Click [here](https://github.com/antonyRepo/mediawiki/tree/master/screenshots/frontend) for screenshots</i>
         
          cd frontend/environment/
          export AWS_ACCESS_KEY_ID=****************
          export AWS_SECRET_ACCESS_KEY=**********************
          export AWS_DEFAULT_REGION=ap-south-1
          terraform init --backend-config="key=state-files/<color>/terraform.tfstate"
          terraform plan -var "keep=1" -var "color=<color>" -var "wiki_version=<wiki_version>" -out=plan.out
          terraform apply plan.out

      <i>Note:</i> In the <color> parameter pass either "blue" or "green" to bring up respective color. To teardown the stack run the above commands with <b>keep</b> parameter value to <b>0</b>. Here "keep" is a boolean variable. "1" to bring up the stack, "0" to teardown the stack.
   
   4. EC2's userdata installs Chef and runs the recipes to install mediawiki and start the apache.
        <i>Click [here](https://github.com/antonyRepo/mediawiki/tree/master/chef_config_mng) for Chef cookbooks </i>
       
   5. Once the instance is in service with the ELB, copy the ELB DNS name from the aws console and hit it in the browser <i><ELB_DNS_NAME>/mediawiki</i> 
  


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
