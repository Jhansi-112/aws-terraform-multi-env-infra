# Step 10 - State file and locking

- State file is stored in S3 at envs/dev/terraform.tfstate with versioning on.
- Tested locking: one terminal held the apply prompt, the second terminal's plan failed with "Error acquiring the state lock".
- A .tflock file appears in S3 while the lock is held and disappears after.
