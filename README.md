# Deploying an EC2 Instance with IaC

This repository contains Infrastructure as Code (IaC) templates to deploy a flexible and secure EC2 instance on AWS. It provides two versions of the same infrastructure: one using **AWS CloudFormation (YAML)** and the other using **HashiCorp Terraform (HCL)**.



## Features

* **Dynamic AMI Lookup:** Automatically finds the latest Amazon Linux 2 AMI for the deployment region using the AWS SSM Parameter Store.
* **Parameterised Configuration:** Uses parameters/variables for instance type, SSH key name, and the source IP for the security group.
* **Dedicated Security Group:** Creates a security group to allow SSH access only from a specified IP address.
* **Convenient Outputs:** Outputs the instance ID, public IP, and public DNS name after creation for easy access.



## Prerequisites

Before you begin, ensure you have the following:

1.  An **AWS Account**.
2.  The **AWS CLI** installed and configured (`aws configure`).
3.  An existing **EC2 Key Pair** in your target AWS region.
4.  **Terraform** installed (if using the Terraform version).



## Usage

### AWS CloudFormation

You can deploy this CloudFormation template using either the AWS Management Console or the AWS Command Line Interface (CLI).


### Method 1: Using the AWS Management Console

This method uses the graphical interface of the AWS website.

1.  **Save the File:** Save the CloudFormation code into a file on your computer named `template.yml`.

2.  **Navigate to CloudFormation:** Log in to the [AWS Management Console](https://aws.amazon.com/console/) and navigate to the **CloudFormation** service.

3.  **Create Stack:** Click the **Create stack** button and select **With new resources (standard)**.

4.  **Specify Template:**
    * Under **Prepare template**, select **Template is ready**.
    * Under **Template source**, select **Upload a template file**.
    * Click **Choose file** and select the `template.yml` file you saved earlier.
    * Click **Next**.

5.  **Specify Stack Details:**
    * **Stack name:** Enter a unique name for your stack (e.g., `my-ec2-deployment`).
    * **Parameters:**
        * **KeyName:** Select your existing EC2 Key Pair from the dropdown menu.
        * **MyIP:** > **Important:** For security, replace the default `0.0.0.0/0` with your own public IP address in the format `x.x.x.x/32`.
    * Click **Next**.

6.  **Configure Stack Options:** You can leave everything on this page as default. Click **Next**.

7.  **Review and Create:** Scroll to the bottom of the review page, check the box that says "I acknowledge that AWS CloudFormation might create IAM resources," and click **Create stack**.

Your stack's status will change to `CREATE_COMPLETE` once finished. You can then find your instance details on the **Outputs** tab.


### Method 2: Using the AWS Command Line Interface (CLI)

This method is faster if you are comfortable with the terminal.

**Prerequisites**

1.  [Install the AWS CLI](https://aws.amazon.com/cli/).
2.  [Configure the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html) with your credentials.

**Deployment**

1.  **Save the File:** Save the CloudFormation code into a file named `template.yml`.

2.  **Run the Deploy Command:** Open your terminal and run the following command.
    
    > **Note:** Replace `your-key-pair` with the name of your EC2 Key Pair and `1.2.3.4/32` with your actual public IP address.

    ```sh
    aws cloudformation deploy \
      --template-file template.yml \
      --stack-name my-ec2-deployment \
      --parameter-overrides \
        KeyName=your-key-pair \
        MyIP=1.2.3.4/32
    ```

### Terraform

1. Save the File
Save the Terraform code into a single file named `main.tf` in a new directory.

2. Initialise Your Workspace
Open your terminal, navigate to the directory containing your `main.tf` file, and run the terraform init command. This will download the necessary AWS provider plugin.

```Bash
terraform init
```

3. Apply the Configuration
   Run the `terraform apply` command to create the resources on AWS. You must provide values for the key_name and my_ip variables.
   Important: Replace your-key-pair with the name of your actual EC2 Key Pair and 1.2.3.4/32 with your public IP address.
```Bash
terraform apply -var="key_name=your-key-pair" -var="my_ip=1.2.3.4/32"
```

4. Terraform will show you a plan of the resources to be created and prompt you for confirmation. Type yes and press Enter to proceed.
   After the deployment is successful, Terraform will display the Outputs (instance ID, public IP, and public DNS) in your terminal.


## Cleanup
To avoid ongoing charges, remember to delete the resource/stack after you're finished.

### CloudFormation

To remove all resources created by CloudFormation, delete the stack:

* **Console:** Navigate to the CloudFormation stack, select it, and click **Delete**.
* **CLI:** Run the command `aws cloudformation delete-stack --stack-name my-ec2-deployment`.

### Terraform

1. To remove all resources created by Terraform, run the destroy command:
   In the same directory, run the `terraform destroy` command, providing the same variables you used to create the resources.

```Bash

terraform destroy -var="key_name=your-key-pair" -var="my_ip=1.2.3.4/32"
```

2. Confirm Destruction
   Terraform will show you which resources will be destroyed. Type `yes` and press Enter to permanently delete the EC2 instance and its security group.





