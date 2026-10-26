# Drift test: resource deleted by hand

What I did:
- Deleted the HTTP:80 listener of the load balancer in the AWS console.
- The website stopped working.

What Terraform did:
- terraform plan found the change and showed: 1 to add, 0 to change, 0 to destroy.
- terraform apply created only the missing listener.
- The website worked again and plan showed: No changes.

Lesson: make changes through code, not the console.
