---
title: "Jenkins Setup on AWS EC2 Instance"
chapter: false
weight: 4
---


### Architecture

![Architecture](/images/jenkins-setup-aws-ec2/jenkins-on-aws-ec2.png?width=100pc)

{{% notice warning %}}

The provisioning process will incur costs and do not use following configuration for production setup.

{{% /notice %}}

## Prerequisites
- [x] Personal AWS Account
- [x] AWS EC2 & VPC access

Below are the following AWS resources to be created during provisioning process.

**AWS Resources**

| Type            | Description                                              |
| --------------- | -------------------------------------------------------- |
| EC2             | AWS EC2 Instance `t3.medium` (Jenkins Server)            |
| EC2             | AWS EC2 Instance `t3.small` (Jenkins Slave)              |
| EBS Root Volume | `50GB` `gp3` for Jenkins Server                          |
| EBS Root Volume | `50GB` `gp3` for Jenkins Slave                           |
| Public IP       | Dynamic Public ip address for Jenkins Server             |
| Public IP       | Dynamic Public ip address for Jenkins Slave              |
| Security Group  | `jenkins-server-cloud-workshop` allow ports `80/443/22` |
| Security Group  | `jenkins-slave-cloud-workshop` allow ports `22`         |
| Key Pair        | `RSA` Algorithm for SSH connection                       |


**Tools Used for this workshop**

| Tools       |
| ----------- |
| Bash Script |
| Terraform   |
| Ansible     |
| AWSCLI      |


## Provisioning Process

To start the provisioning process.

1. Login to you aws account through [https://console.aws.amazon.com](https://console.aws.amazon.com).

 ![AWS Console Login](/images/jenkins-setup-aws-ec2/aws-console-login.png?width=50pc)

2. After login, click the highlighted button **(CloudShell)**

**Note: Make sure you are in `ap-southeast-1` region on AWS console**

![AWS Cloud Shell Button](/images/jenkins-setup-aws-ec2/aws-cloudshell.png?width=50pc)

3. After that, it will prepare your cloud shell environment

![Cloud Shell Preparing](/images/jenkins-setup-aws-ec2/aws-cloudshell-console-preparing.png?width=50pc)

4. Once cloudshell is ready. Clone the repository and navigate to the `lab-src` where our script is located.

```bash
## Clone the repository
git clone https://github.com/redopsbay/cloudworkshop.git
cd cloudworkshop/lab-src/cicd/jenkins/jenkins-setup-ec2
```

5. Make `workshop.sh` as executable file. So, we can execute it.

```bash
chmod +x workshop.sh
```

6. Now, Execute the `workshop.sh` via:

```bash
./workshop.sh
```

7. You will be prompt for the desired actions:

```bash
============= Choose target action =============

1) Setup CLI Binaries

2) Provision Jenkins

3) Cleanup Terraform Resources

Choose action:
```

8. Choose `1` as desired action to install necessary package dependencies such as `terraform` cli.

```bash
============= Choose target action =============

1) Setup CLI Binaries

2) Provision Jenkins

3) Cleanup Terraform Resources

Choose action: 1
```

![Setup CLI Dependencies](/images/jenkins-setup-aws-ec2/setup-dependency.png?width=50pc)


9. Next, Provision the jenkins server via:



```bash
./workshop.sh

============= Choose target action =============

1) Setup CLI Binaries

2) Provision Jenkins

3) Cleanup Terraform Resources

Choose action: 2
```

{{% notice note %}}

The provisioning process will use your AWS default VPC for the sake of this workshop.

{{% /notice %}}


### VPC details
![Specify VPC Details](/images/jenkins-setup-aws-ec2/vpc-details.png?width=50pc)


### Provisioning
![Provisioning](/images/jenkins-setup-aws-ec2/provisioning.png?width=50pc)

![EC2 Instances](/images/jenkins-setup-aws-ec2/ec2-instances.png?width=50pc)

### Jenkins Installation with Ansible
![Jenkins Installation with Ansible](/images/jenkins-setup-aws-ec2/ansible-config.png?width=50pc)

just wait for a few minutes. The Jenkins initial admin password will be provided at the console.

![Jenkins initial admin password](/images/jenkins-setup-aws-ec2/jenkins-initial-password.png?width=50pc)

Here, After a few minutes, the jenkins initial admin password has been displayed.


10. Navigate to jenkins server by getting the `server_public_dns` value from terraform output. In my case [http://ec2-13-212-62-187.ap-southeast-1.compute.amazonaws.com](http://ec2-13-212-62-187.ap-southeast-1.compute.amazonaws.com)

![Jenkins initial admin login](/images/jenkins-setup-aws-ec2/jenkins-login-initialadmin.png?width=50pc)


11. Click **Install Suggested Plugin**.

12. Then, setup your new Admin account.

![Jenkins first admin user](/images/jenkins-setup-aws-ec2/jenkins-first-admin-user.png?width=50pc)


## Cleanup resources

To avoid such costs. We have to cleanup our AWS resources.

1. Navigate again to your cloudshell and navigate to the `cloudworkshop/lab-src/cicd/jenkins/jenkins-setup-ec2` directory.

2. Next, run the `workshop.sh` script via:

```bash
./workshop.sh
```

3. Choose `3` to cleanup terraform resources.

![Cleanup](/images/jenkins-setup-aws-ec2/cleanup.png?width=50pc)
![Terminated Instances](/images/jenkins-setup-aws-ec2/terminated.png?width=50pc)


### Reference
- Lab Resource link: [https://github.com/redopsbay/cloudworkshop/tree/master/lab-src/cicd/jenkins/jenkins-setup-ec2](https://github.com/redopsbay/cloudworkshop/tree/master/lab-src/cicd/jenkins/jenkins-setup-ec2)
