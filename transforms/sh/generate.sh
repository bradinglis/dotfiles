#!/bin/sh


echo "---"
echo "geometry: margin=3cm"
echo "output: pdf_document"
echo "---"
echo ""

echo "# Itinerary"

echo ""
echo "\n---\n"

gawk --csv 'NR > 1 { 

  split($1,a,"-");
  printf("## %s/%s/%s\n", a[3], a[2], a[1]);

  if ($5 != "") {
    printf("Awake in %s: *%s*\n\n", $2, $5);
  }

  if($4 != "") { 
    printf("Travel:"); 
    s = split($4, ta, "\\n");
    if (s == 1) {
      printf(" %s\n\n", $4);
    } else {
      printf("\n\n");
      for(j = 1; j <= s; j++) {
        printf("- %s\n", ta[j]);
      }
    }
    printf("\n");
  }


  n = 1;
  for (i = 8; i < 12; i++) {
    if($i != "") { 
      if(n){
        printf("**Activities**:\n\n");
        n = 0;
      }
      printf("- %s\n", $i);
    }
  }

  printf("\n");
  

  if ($6 != "") {
    printf("Sleep in %s: *%s*\n\n", $3, $6);
  }
  printf("---\n\n");
}'


