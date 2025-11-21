awk -F'\t' '{ line [NR] = $0 }
END { 
  for (t = 1; t <= NF; t++) {
    printf("\"");
    for (i = 1; i <= NR; i++) {
      n = split(line[i], field)
      printf("%s", field[t])
      if (i < NR) {
        printf("\n")
      }
    }
    printf("\"");
    if(t != NF) {
      printf("\t");
    }
  }
}'

