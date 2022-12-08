1. Terraform backend state is maintained in GCS bucket namely **devops-project-tfstates** with versioning enabled.

2. To run the terraform, cloud build triggers are used, which is to be created via script mentioned in blog. To perform the  initial terraform run create the cloud build triggers manually. One for apply and plan.
Plan trigger should be run before doing the actual deployment to check for the resources that are going to be created.
Once done hit the apply trigger, it will create all the required infrastructure.
Cloudbuild files are kept in the root directory of the repository in the dedicated directories.
To run the terraform “dir” attribute makes sure it is run in the correct directory.

whenevr we commit the code changes to github repo cloud build will be triggered automatically and gcp infra will get created.

3. If we have a use case to run the terraform from the directories, follow the below steps.To run the terraform code go to /envs/dev/ directory and execute the below terraform commands:
- terraform init
- terraform plan
- terraform apply

4. All the child modules are defined in **blueprint** folder and All the values passed inside **/envs/dev/main.tf** i.e. root module which are required attributes to create the resources. Whenever we need to update/add any other attributes we need to take the reference of blueprint/modules/** modules.

5. To write code for multiple env, create a directory with env name in the "dir" directory.

6. Update the values in /envs/dev/main.tf and execute the terraform commands.

7. To authenticate with doppler provider, create a new **token.txt** file in /blueprint foler, add the **service token/personal token** provided by your doppler provider in that newly created file. Add the file path in the provider.tf as shown below:
```
provider "doppler" {
  doppler_token = file("${path.module}/token.txt") 
}
```
*Note:* Do make sure token.txt file never exposed to any git repository.

#### Update the values accordingly in /envs/main.tf

#### Following are the terraform resources for which /blueprint folder act as child module and is called in /envs/dev/main.tf

1. doppler_project
2. doppler_environment
3. doppler_config
4. doppler_service_token
5. doppler_secret

#### Random DB password has been created in root module as below which is referenced inside doppler secret value.
```
resource "random_password" "db_password" {
  length  = 32
  special = true
}
```
### doppler_project
**To create a doppler_project in new env pass the required attributes in /envs/dev/main.tf as mentioned below** 
```
  doppler_project      = "tf-test-project"
```
### doppler_environment
**To create a doppler_environment in new env pass the required attributes in /envs/dev/main.tf as mentioned below**
```
   doppler_environment  = "development"
```
*Note*: Whenever we need to create additional firewall rules we can simply add another comma separated map of object and pass the requied values to it. (as shown in above example)

### doppler_config
**To create a doppler_config in new env, pass all the required attributes in /envs/dev/main.tf as mentioned below**
```
  root_config          = "dev"
  branch_config        = "dev_prajakta"
 ```

### doppler_service_token
**To create a doppler_service_token in new env, pass all the required attributes in /envs/dev/main.tf as mentioned below**
```
  service_token        = "tf test service Token"
  service_token_access = "read/write"
 ```
### doppler_secret
**To create a doppler_secret in new env, pass all the required attributes in /envs/dev/main.tf as mentioned below**
```
   doppler_secrets = {
    "DB_PASSWORD" = random_password.db_password.result
  }
 ```
Till now we have prepared our code now, let's take a look at cloudbuild file to change the required values
#### Cloud Build Files
Store the doppler token from GCP secret manager to  blueprint/token.txt file with the help of below command:
```
gcloud secrets --project ${PROJECT_ID} versions access latest \
--secret=$_DOPPLER_TOKEN_SECRET \
--format='get(payload.data)' | \
tr '_-' '/+' | base64 -d > blueprint/token.txt
```
Execute terraform init with 
```
terraform init
```
Execute terraform apply with:
```
terraform apply -input=false -auto-approve
```
Note the substitution variable ***_ENV: dev*** this can be set based on your folder structure. For example if you want to execute the other env from folder stg you can replace the variable as per your requirement.
This helps in deploying code in multiple envs.

All the terraform logs has been stored in **gs://doppler-tf-log** GCS bucket.

In this way we have created doppler resources (project, env, config, service_token , secrets) via child module defined at blueprint/modules/doppler


