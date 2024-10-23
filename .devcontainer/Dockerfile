FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

RUN mkdir ./terraform-temp/
RUN wget https://releases.hashicorp.com/terraform/1.9.5/terraform_1.9.5_linux_amd64.zip -O ./terraform-temp/terraform.zip
RUN unzip ./terraform-temp/terraform.zip -d ./terraform-temp/
RUN mkdir -p /home/vscode/.local/bin/
RUN cp ./terraform-temp/terraform /home/vscode/.local/bin/
RUN rm -rf ./terraform-temp/

# Azure CLI is setup in the postCreateCommand (had trouble getting the script to be found/run here)