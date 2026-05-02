## Total size per year folder instead.


for year in 2019 2020 2021 2022 2023 2024 2025; do
  echo -n "$year: "
  aws s3 ls s3://dhali-server-backup/web-prod/long-term-archive/$year/ --recursive --summarize 2>/dev/null | grep "Total Size"
done
