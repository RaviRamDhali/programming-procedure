SET "sourceBucket=success-backup-sets"
SET "sourceFolder=success-production/sql/archives"
aws s3 sync s3://%sourceBucket%/%sourceFolder%/ C:\SQL\backups\from-prod --exclude "*" --include "test_07302020.bak"
