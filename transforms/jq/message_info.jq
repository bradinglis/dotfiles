[.DataArea.OperationsResponse | .SegmentResponse.[].OpSegmentResponse |
  { 
    (.ID): 
      [
        .MaterialActual.[]?.OpMaterialActual.MaterialActualProperty[]?.OpMaterialActualProperty?,
        .SegmentData.[]?.OpSegmentData?
      ] | map({(.ID): .Value.ValueString}) | add,
  } 
] | add
