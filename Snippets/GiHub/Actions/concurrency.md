The default behavior of GitHub Actions is to allow multiple jobs or workflow runs to run concurrently. The concurrency keyword allows you to control the concurrency of workflow runs.
For example, you can use the concurrency keyword immediately after where trigger conditions are defined to limit the concurrency of entire workflow runs for a specific branch:

## cancel-in-progress: true

```
concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true
```

![image](https://github.com/user-attachments/assets/dca93b31-1d63-4aac-a76e-f2b631d77a57)

