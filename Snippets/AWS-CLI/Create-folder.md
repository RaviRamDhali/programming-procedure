SET today=%Date:~-10,2%%Date:~-7,2%%Date:~-4,4%
aws s3api put-object --bucket successce-backup-sets --key %today%/

aws s3api put-object --bucket root-bucket-name --key new-dir-name/
