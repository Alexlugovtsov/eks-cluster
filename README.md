# Creates EKS cluster with teams

teams are defined in tfvars/*.tfvars files "teams" section

- for branch "*-dev" cluster
- for MR "*-test" cluster
- for main "tfschool" cluster

Longest jobs (>1min): 
- eks 12 min
- alb 3 min

Things to improve:
- combine kubeconfigs into one for teams
- get rid of hardcoded values (helm_release versions)
- dns is not working on a AWS level, cert dependent to dns

## Variables needed for local run
```
export AWS_DEFAULT_REGION=eu-central-1
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
export GITLAB_ACCESS_TOKEN=
```
## Basic Usage
```
#get terraform init command from https://gitlab.devops.telekom.de/mavie/system/aws/eks-terraform/-/terraform
terraform plan
terraform apply -auto-approve
terraform destroy
```
## Advanced Usage
```
terraform state list #get all resources
terraform state rm module... #remove manually deleted resource form state file
terraform destroy --auto-approve --target module... #destroy target resource if it exists with all dependencies
```
## Manage Gitlab TF State versions via curl
```
curl --header "Private-Token: $GITLAB_ACCESS_TOKEN" "https://gitlab.devops.telekom.de/api/v4/projects/76277/terraform/state/terraform-dev"
curl --header "Private-Token: $GITLAB_ACCESS_TOKEN" --request DELETE "https://gitlab.devops.telekom.de/api/v4/projects/76277/terraform/state/terraform-dev/versions/43"
```
For more information on how to use it, please refer to the [official docs](https://docs.gitlab.com/ee/user/infrastructure/clusters/connect/new_eks_cluster.html).