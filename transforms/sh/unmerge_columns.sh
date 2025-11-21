sed -z "s/\n/\\\n/g" | sed "s/\"//g" | awk -F'\t' '{ line [NR] = $0 }
END { 
  n = split($1, s, "\\\\n");
  for (i = 1; i <= n; i++) {
    for (t = 1; t <= NF; t++) {
      split($t, field, "\\\\n");
      printf("%s", field[i]);
      if (t < NF){ printf("\t"); }
    }
    if (i < n){ printf("\n"); }
  }
}'

