bash fetch-inventory.sh
git add .
git add -u
SET datetime=%date% %time%
git commit -m "%datetime%"
git push origin HEAD -ff