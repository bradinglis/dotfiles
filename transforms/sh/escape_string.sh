printf hi\";
sed 's/\"/\\"/g' | sed -z "s/\n$//g"
printf \";
