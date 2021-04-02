# dev-box

Create a dev box on DigitalOcean using Terraform

# Pre-requisite

Install:
[ ] `make` on your local computer
[ ] `terraform` on your local computer

For authentication:
[ ] DigitalOcean API Token
[ ] List your RSA key on DigitalOcean

# How to use?

1. Copy `example.tfvars` to `dev.tfvars`

    cp example.tfvars dev.tfvars

1. Change both `do_token` and `pvt_key` in dev.tfvars to Digital Ocean token and path to
	 private key on your local machine

	  do_token=A3B9231
	  pvt_key=/path/to/private/key

1. Plan your run using `make plan`

    make plan

1. Apply the changes using `make apply`

    make apply

1. Once you're done and you want to destroy all resource, do so with `make
	 destroy`

    make destroy
