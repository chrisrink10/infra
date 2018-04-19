# Getting Started

## Setting Up Your Local Environment

You will need to download a few different dependencies to make sure your
local environment can be used to use Terraform.

```bash
brew update
brew install Caskroom/cask/google-cloud-sdk
brew install terraform
```

Afterwards, authenticate to your Google cloud account:

```bash
gcloud auth login
```

## Preparing a Project Environment

### Assumptions

The instructions below generally assume that you are planning to deploy
personal projects and will not have multiple environments dedicated to
staging, demoing, and production (for example).

### Structure



### Creating Terraform Admin Credentials

Below I am assuming that you have already created a new project in Google
Cloud Console. Each GCP project folder should have a `.envrc` file which
contains environment variables that make usage of `gcloud` and `terraform`
command line tools simpler. Initial setup will generate an `.envrc` file.

For each project on Google's cloud, you'll want to create a Terraform
specific service account which can manipulate resources within that
project.

1. Prepare your environment with some useful variables:

```bash
export TF_PROJECT=...     # Project name
mkdir $TF_PROJECT
cd $TF_PROJECT
echo 'source_env ..' > .envrc
echo "export TF_PROJECT=$TF_PROJECT" >> .envrc
echo 'export TF_USER=terraform' >> .envrc
echo 'export TF_CREDS=${INFRA_PROJECT_DIR}/.creds/gcp/${TF_PROJECT}-${TF_USER}.json' >> .envrc
echo 'export GOOGLE_CREDENTIALS=$TF_CREDS' >> .envrc
```

2. List your active projects to get the relevant Project ID:

```bash
gcloud projects list
```

3. After you select the project ID, set the active project with:

```bash
gcloud config set project $GCLOUD_PROJECT_ID
```

4. Now create the service accounts:

```bash
gcloud iam service-accounts create ${TF_USER} \
  --display-name "Terraform admin account"

gcloud iam service-accounts keys create ${TF_CREDS} \
  --iam-account ${TF_USER}@${TF_PROJECT}.iam.gserviceaccount.com
```

5. Grant the Terraform service account rights on the account. In the
example below, we grant the Terraform user admin rights to Cloud Storage.

```bash
gcloud projects add-iam-policy-binding ${TF_PROJECT} \
  --member serviceAccount:${TF_USER}@${TF_PROJECT}.iam.gserviceaccount.com \
  --role roles/storage.admin
```

6. If Terraform will request other types of resources, the APIs must be
enabled. You can enable APIs as such:

```bash
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable cloudbilling.googleapis.com
gcloud services enable iam.googleapis.com
gcloud services enable compute.googleapis.com
gcloud services enable sqladmin.googleapis.com
```

### Running Terraform

Create your Terraform configuration for this project and once you've got it
how you want it, check the plan like so:

```bash
terraform plan
```

If everything, seems good then you can apply with:

```bash
terraform apply
```
