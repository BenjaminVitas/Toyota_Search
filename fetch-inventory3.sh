#!/usr/bin/env bash

rm inventory3.json
IFS=', ' read -r -a array < dealers40k-51k.txt

for i in ${array[@]}
do
  curl \
  --header "Content-Type: application/json" \
  --request POST \
  --data '{
      "brand": "TOY",
      "mode": "content",
      "group": true,
      "groupmode": "full",
      "relevancy": false,
      "pagesize": 300,
      "pagestart": 0,
      "filter": {
          "year": [2021, 2022, 2023], 
          "series": ["tacoma", "tundra", "rav4", "4runner", "camry", "corolla"], 
          "dealers": ["'$i'"],
          "andfields": ["accessory", "packages", "dealer"]
        }
    }' \
  https://www.toyota.com/config/services/inventory/search/getInventory \
  | jq -c \
    '.body.response.docs
      | .[] 
      | {
          dealer: "'$i'",
          vin: .vin,
          year: .year.code,
          vehicle: .grade.series_code,
          model: .grade.code,
          enginge: .engine.title,
          transmission: .transmission.title,
          drivetrain: .drive.title,
          cab: .cab.title,
          bed: .bed.title,
          color: .exteriorcolor.title,
          interior: .interiorcolor.title,
          base_msrp: .priceInfo.baseMSRP,
          total_msrp: .priceInfo.totalMSRP,
          availability_date: .availabilityDate,
          total_packages: .accessories | length,
          packages: .accessories | map(.title) | join(", "),
          created_at: now | strflocaltime("%Y-%m-%d %H:%M:%S")
        }' \
  >> inventory3.jsonl
  echo $i
done

cat inventory3.jsonl | jq -s '.' > inventory3.json
rm inventory3.jsonl