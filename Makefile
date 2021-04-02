VAR_FILE_COMMAND=-var-file dev.tfvars
PLAN_OUTPUT=infra.out

plan:
	terraform plan $(VAR_FILE_COMMAND) -out=$(PLAN_OUTPUT)

apply:
	terraform apply $(PLAN_OUTPUT)

destroy:
	terraform destroy $(VAR_FILE_COMMAND)
