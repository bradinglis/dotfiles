[.DataArea.OperationsRequest[] |
.OpOperationsRequest as $opsReq |
{
  (.OpOperationsRequest.ID): [.OpOperationsRequest.SegmentRequirement[].OpSegmentRequirement | select(.Description == "StockID") |
  . as $feedcoil | { 
    (.ID): {
      "Load": {
        "ApplicationArea": {
          "Sender": {
            "LogicalID": "WPCSC",
            "ReferenceID": "177F7B28-1B9F-4903-9AA1-E28197443520"
          },
          "CreationDateTime": now | todate,
          "BODID": "LoadCoil"
        },
        "DataArea": {
          "OperationsResponse": {
            "ID": "LoadCoil",
            "HierarchyScope": {
              "EquipmentID": $opsReq.HierarchyScope.EquipmentID,
              "EquipmentElementLevel": "StorageZone"
            },
            "OperationsType": "Production",
            "OperationsRequestID": $opsReq.ID, 
            "SegmentResponse": [
              {
                "OpSegmentResponse": {
                  "ID": "",
                  "ProcessSegmentID": "LoadCoil",
                  "MaterialActual": [
                    {
                      "OpMaterialActual": {
                        "MaterialLotID": "",
                        "MaterialActualProperty": [
                          {
                            "OpMaterialActualProperty": {
                              "ID": "StockID",
                              "Value": {
                                "ValueString": .ID,
                                "DataType": "string",
                                "UnitOfMeasure": ""
                              }
                            }
                          },
                          {
                            "OpMaterialActualProperty": {
                              "ID": "UnitID",
                              "Value": {
                                "ValueString": $opsReq.HierarchyScope.EquipmentID,
                                "DataType": "string",
                                "UnitOfMeasure": ""
                              }
                            }
                          },
                          {
                            "OpMaterialActualProperty": {
                              "ID": "Transaction_Type_ID",
                              "Value": {
                                "ValueString": "LOAD",
                                "DataType": "string",
                                "UnitOfMeasure": ""
                              }
                            }
                          },
                          {
                            "OpMaterialActualProperty": {
                              "ID": "DateTimeStockLoaded",
                              "Value": {
                                "ValueString": now | todate,
                                "DataType": "datetime",
                                "UnitOfMeasure": ""
                              }
                            }
                          },
                          {
                            "OpMaterialActualProperty": {
                              "ID": "PPINumber",
                              "Value": {
                                "ValueString": $opsReq.ID,
                                "DataType": "string",
                                "UnitOfMeasure": ""
                              }
                            }
                          },
                          {
                            "OpMaterialActualProperty": {
                              "ID": "Width",
                              "Value": {
                                "ValueString": ([.MaterialRequirement[0].OpMaterialRequirement.MaterialRequirementProperty[].OpMaterialRequirementProperty | select(.ID == "Width")] | .[]?.Value?.ValueString // ""),
                                "DataType": "real",
                                "UnitOfMeasure": "mm"
                              }
                            }
                          },
                          {
                            "OpMaterialActualProperty": {
                              "ID": "Thickness",
                              "Value": {
                                "ValueString": ([.MaterialRequirement[0].OpMaterialRequirement.MaterialRequirementProperty[].OpMaterialRequirementProperty | select(.ID == "Thickness")] | .[]?.Value?.ValueString // ""),
                                "DataType": "real",
                                "UnitOfMeasure": "mm"
                              }
                            }
                          },
                          {
                            "OpMaterialActualProperty": {
                              "ID": "InventoryLotID",
                              "Value": {
                                "ValueString": ([.SegmentParameter[].OpSegmentParameter | select(.ID == "InventoryLotID")] | .[]?.Value?.ValueString // ""),
                                "DataType": "string",
                                "UnitOfMeasure": ""
                              }
                            }
                          },
                          {
                            "OpMaterialActualProperty": {
                              "ID": "ProductItemNumber",
                              "Value": {
                                "ValueString": ([.SegmentParameter[].OpSegmentParameter | select(.ID == "ProductItemId")] | .[]?.Value?.ValueString // ""),
                                "DataType": "string",
                                "UnitOfMeasure": ""
                              }
                            }
                          },
                          {
                            "OpMaterialActualProperty": {
                              "ID": "ProductItemVariant",
                              "Value": {
                                "ValueString": ([.MaterialRequirement[0].OpMaterialRequirement.MaterialRequirementProperty[].OpMaterialRequirementProperty | select(.ID == "ShortSpec")] | .[]?.Value?.ValueString // ""),
                                "DataType": "string",
                                "UnitOfMeasure": ""
                              }
                            }
                          },
                          {
                            "OpMaterialActualProperty": {
                              "ID": "Mass",
                              "Value": {
                                "ValueString": ([.MaterialRequirement[0].OpMaterialRequirement.Quantity[].QuantityValue | select(.Key == "MassOfCoil")] | .[]?.QuantityString // ""),
                                "DataType": "integer",
                                "UnitOfMeasure": "kg"
                              }
                            }
                          },
                          {
                            "OpMaterialActualProperty": {
                              "ID": "UnitMass",
                              "Value": {
                                "ValueString": ([.SegmentParameter[].OpSegmentParameter | select(.ID == "ProductUnitMass")] | .[]?.Value?.ValueString // ""),
                                "DataType": "integer",
                                "UnitOfMeasure": "kg"
                              }
                            }
                          },
                          {
                            "OpMaterialActualProperty": {
                              "ID": "FloorLocation",
                              "Value": {
                                "ValueString": ([.MaterialRequirement[0].OpMaterialRequirement.MaterialRequirementProperty[].OpMaterialRequirementProperty | select(.ID == "FloorLocation")] | .[]?.Value?.ValueString // ""),
                                "DataType": "string",
                                "UnitOfMeasure": ""
                              }
                            }
                          },
                          {
                            "OpMaterialActualProperty": {
                              "ID": "Quality",
                              "Value": {
                                "ValueString": ([.SegmentParameter[].OpSegmentParameter | select(.ID == "FormulaQuality")] | .[]?.Value?.ValueString // ""),
                                "DataType": "string",
                                "UnitOfMeasure": ""
                              }
                            }
                          }
                        ]
                      }
                    }
                  ]
                }
              }
            ]
          }
        }
      },
      "RTS": {
        "ApplicationArea": {
          "Sender": {
            "LogicalID": "WPCSC",
            "ReferenceID": "177F7B28-1B9F-4903-9AA1-E28197443520"
          },
          "CreationDateTime": now | todate,
          "BODID": "LoadCoil"
        },
        "DataArea": {
          "OperationsResponse": {
            "ID": "LoadCoil",
            "HierarchyScope": {
              "EquipmentID": $opsReq.HierarchyScope.EquipmentID,
              "EquipmentElementLevel": "StorageZone"
            },
            "OperationsType": "Production",
            "OperationsRequestID": $opsReq.ID, 
            "SegmentResponse": [
              {
                "OpSegmentResponse": {
                  "ID": "HEADER",
                  "ProcessSegmentID": "LoadCoil",
                  "MaterialActual": [
                    {
                      "OpMaterialActual": {
                        "MaterialLotID": "",
                        "MaterialActualProperty": [
                          {
                            "OpMaterialActualProperty": {
                              "ID": "StockID",
                              "Value": {
                                "ValueString": .ID,
                                "DataType": "string",
                                "UnitOfMeasure": ""
                              }
                            }
                          },
                          {
                            "OpMaterialActualProperty": {
                              "ID": "UnitID",
                              "Value": {
                                "ValueString": $opsReq.HierarchyScope.EquipmentID,
                                "DataType": "string",
                                "UnitOfMeasure": ""
                              }
                            }
                          },
                          {
                            "OpMaterialActualProperty": {
                              "ID": "Transaction_Type_ID",
                              "Value": {
                                "ValueString": "RTS",
                                "DataType": "string",
                                "UnitOfMeasure": ""
                              }
                            }
                          },
                          {
                            "OpMaterialActualProperty": {
                              "ID": "DateTimeStockUnLoaded",
                              "Value": {
                                "ValueString": now | todate,
                                "DataType": "datetime",
                                "UnitOfMeasure": ""
                              }
                            }
                          },
                          {
                            "OpMaterialActualProperty": {
                              "ID": "CurrentMass",
                              "Value": {
                                "ValueString": ([.MaterialRequirement[0].OpMaterialRequirement.Quantity[].QuantityValue | select(.Key == "MassOfCoil")] | .[]?.QuantityString // ""),
                                "DataType": "integer",
                                "UnitOfMeasure": "kg"
                              }
                            }
                          },
                          {
                            "OpMaterialActualProperty": {
                              "ID": "StatusCode",
                              "Value": {
                                "ValueString": "A",
                                "DataType": "string",
                                "UnitOfMeasure": ""
                              }
                            }
                          },
                          {
                            "OpMaterialActualProperty": {
                              "ID": "InventoryLotID",
                              "Value": {
                                "ValueString": ([.SegmentParameter[].OpSegmentParameter | select(.ID == "InventoryLotID")] | .[]?.Value?.ValueString // ""),
                                "DataType": "string",
                                "UnitOfMeasure": ""
                              }
                            }
                          },
                          {
                            "OpMaterialActualProperty": {
                              "ID": "ProductItemNumber",
                              "Value": {
                                "ValueString": ([.SegmentParameter[].OpSegmentParameter | select(.ID == "ProductItemId")] | .[]?.Value?.ValueString // ""),
                                "DataType": "string",
                                "UnitOfMeasure": ""
                              }
                            }
                          },
                          {
                            "OpMaterialActualProperty": {
                              "ID": "ProductItemVariant",
                              "Value": {
                                "ValueString": ([.MaterialRequirement[0].OpMaterialRequirement.MaterialRequirementProperty[].OpMaterialRequirementProperty | select(.ID == "ShortSpec")] | .[]?.Value?.ValueString // ""),
                                "DataType": "string",
                                "UnitOfMeasure": ""
                              }
                            }
                          },
                          {
                            "OpMaterialActualProperty": {
                              "ID": "Width",
                              "Value": {
                                "ValueString": ([.MaterialRequirement[0].OpMaterialRequirement.MaterialRequirementProperty[].OpMaterialRequirementProperty | select(.ID == "Width")] | .[]?.Value?.ValueString // ""),
                                "DataType": "real",
                                "UnitOfMeasure": "mm"
                              }
                            }
                          },
                          {
                            "OpMaterialActualProperty": {
                              "ID": "UnitMass",
                              "Value": {
                                "ValueString": ([.SegmentParameter[].OpSegmentParameter | select(.ID == "ProductUnitMass")] | .[]?.Value?.ValueString // ""),
                                "DataType": "integer",
                                "UnitOfMeasure": "kg"
                              }
                            }
                          },
                          {
                            "OpMaterialActualProperty": {
                              "ID": "FloorLocation",
                              "Value": {
                                "ValueString": ([.MaterialRequirement[0].OpMaterialRequirement.MaterialRequirementProperty[].OpMaterialRequirementProperty | select(.ID == "FloorLocation")] | .[]?.Value?.ValueString // ""),
                                "DataType": "string",
                                "UnitOfMeasure": ""
                              }
                            }
                          },
                          {
                            "OpMaterialActualProperty": {
                              "ID": "Quality",
                              "Value": {
                                "ValueString": ([.SegmentParameter[].OpSegmentParameter | select(.ID == "FormulaQuality")] | .[]?.Value?.ValueString // ""),
                                "DataType": "string",
                                "UnitOfMeasure": ""
                              }
                            }
                          }
                        ]
                      }
                    }
                  ]
                }
              },
              {
                "OpSegmentResponse": {
                  "ID": "SCRAP",
                  "Description": "Scrap details",
                  "ProcessSegmentID": "ChildCoil",
                  "SegmentData": [
                    {
                      "OpSegmentData": {
                        "ID": "StockHoldFileKey",
                        "Value": {
                          "ValueString": "",
                          "DataType": "string",
                          "UnitOfMeasure": ""
                        }
                      }
                    },
                    {
                      "OpSegmentData": {
                        "ID": "StockID",
                        "Value": {
                          "ValueString": .ID,
                          "DataType": "string",
                          "UnitOfMeasure": ""
                        }
                      }
                    },
                    {
                      "OpSegmentData": {
                        "ID": "ClassClaim",
                        "Value": {
                          "ValueString": "14114",
                          "DataType": "string",
                          "UnitOfMeasure": ""
                        }
                      }
                    },
                    {
                      "OpSegmentData": {
                        "ID": "HoldReason",
                        "Value": {
                          "ValueString": "126",
                          "DataType": "string",
                          "UnitOfMeasure": ""
                        }
                      }
                    },
                    {
                      "OpSegmentData": {
                        "ID": "HoldDateTime",
                        "Value": {
                          "ValueString": now | todate,
                          "DataType": "datetime",
                          "UnitOfMeasure": ""
                        }
                      }
                    },
                    {
                      "OpSegmentData": {
                        "ID": "LogonID",
                        "Value": {
                          "ValueString": "WPL3",
                          "DataType": "string",
                          "UnitOfMeasure": ""
                        }
                      }
                    },
                    {
                      "OpSegmentData": {
                        "ID": "Mass",
                        "Value": {
                          "ValueString": "150",
                          "DataType": "integer",
                          "UnitOfMeasure": "kg"
                        }
                      }
                    },
                    {
                      "OpSegmentData": {
                        "ID": "DistanceDefectEdge",
                        "Value": {
                          "ValueString": "0",
                          "DataType": "integer",
                          "UnitOfMeasure": "mm"
                        }
                      }
                    },
                    {
                      "OpSegmentData": {
                        "ID": "DistanceDefectSep",
                        "Value": {
                          "ValueString": "0",
                          "DataType": "integer",
                          "UnitOfMeasure": "mm"
                        }
                      }
                    },
                    {
                      "OpSegmentData": {
                        "ID": "Length",
                        "Value": {
                          "ValueString": "0",
                          "DataType": "integer",
                          "UnitOfMeasure": "mm"
                        }
                      }
                    },
                    {
                      "OpSegmentData": {
                        "ID": "Height",
                        "Value": {
                          "ValueString": "0",
                          "DataType": "integer",
                          "UnitOfMeasure": "mm"
                        }
                      }
                    },
                    {
                      "OpSegmentData": {
                        "ID": "PositionDefectDrive",
                        "Value": {
                          "ValueString": "Y",
                          "DataType": "char",
                          "UnitOfMeasure": ""
                        }
                      }
                    },
                    {
                      "OpSegmentData": {
                        "ID": "PositionDefectOperator",
                        "Value": {
                          "ValueString": "Y",
                          "DataType": "char",
                          "UnitOfMeasure": ""
                        }
                      }
                    },
                    {
                      "OpSegmentData": {
                        "ID": "PositionDefectMiddle",
                        "Value": {
                          "ValueString": "Y",
                          "DataType": "char",
                          "UnitOfMeasure": ""
                        }
                      }
                    },
                    {
                      "OpSegmentData": {
                        "ID": "PositionDefectTop",
                        "Value": {
                          "ValueString": "Y",
                          "DataType": "char",
                          "UnitOfMeasure": ""
                        }
                      }
                    },
                    {
                      "OpSegmentData": {
                        "ID": "PositionDefectRev",
                        "Value": {
                          "ValueString": "Y",
                          "DataType": "char",
                          "UnitOfMeasure": ""
                        }
                      }
                    },
                    {
                      "OpSegmentData": {
                        "ID": "PositionDefectFront",
                        "Value": {
                          "ValueString": "Y",
                          "DataType": "char",
                          "UnitOfMeasure": ""
                        }
                      }
                    },
                    {
                      "OpSegmentData": {
                        "ID": "PositionDefectQuarter",
                        "Value": {
                          "ValueString": "Y",
                          "DataType": "char",
                          "UnitOfMeasure": ""
                        }
                      }
                    },
                    {
                      "OpSegmentData": {
                        "ID": "PositionDefectHalf",
                        "Value": {
                          "ValueString": "N",
                          "DataType": "char",
                          "UnitOfMeasure": ""
                        }
                      }
                    },
                    {
                      "OpSegmentData": {
                        "ID": "PositionDefect3Quarter",
                        "Value": {
                          "ValueString": "N",
                          "DataType": "char",
                          "UnitOfMeasure": ""
                        }
                      }
                    },
                    {
                      "OpSegmentData": {
                        "ID": "PositionDefectEnd",
                        "Value": {
                          "ValueString": "Y",
                          "DataType": "char",
                          "UnitOfMeasure": ""
                        }
                      }
                    },
                    {
                      "OpSegmentData": {
                        "ID": "PositionDefectRandom",
                        "Value": {
                          "ValueString": "Y",
                          "DataType": "char",
                          "UnitOfMeasure": ""
                        }
                      }
                    },
                    {
                      "OpSegmentData": {
                        "ID": "Subtypecode",
                        "Value": {
                          "ValueString": "",
                          "DataType": "string",
                          "UnitOfMeasure": ""
                        }
                      }
                    },
                    {
                      "OpSegmentData": {
                        "ID": "SeverityCode",
                        "Value": {
                          "ValueString": "9",
                          "DataType": "string",
                          "UnitOfMeasure": ""
                        }
                      }
                    },
                    {
                      "OpSegmentData": {
                        "ID": "Crew",
                        "Value": {
                          "ValueString": "A",
                          "DataType": "char",
                          "UnitOfMeasure": ""
                        }
                      }
                    },
                    {
                      "OpSegmentData": {
                        "ID": "PhotoFlag",
                        "Value": {
                          "ValueString": "Y",
                          "DataType": "char",
                          "UnitOfMeasure": ""
                        }
                      }
                    },
                    {
                      "OpSegmentData": {
                        "ID": "Setupcomment",
                        "Value": {
                          "ValueString": "",
                          "DataType": "string",
                          "UnitOfMeasure": ""
                        }
                      }
                    },
                    {
                      "OpSegmentData": {
                        "ID": "RootCauseComment",
                        "Value": {
                          "ValueString": "",
                          "DataType": "string",
                          "UnitOfMeasure": ""
                        }
                      }
                    },
                    {
                      "OpSegmentData": {
                        "ID": "HoldComment",
                        "Value": {
                          "ValueString": "RTS SCRAP COMMENTS VSL1",
                          "DataType": "string",
                          "UnitOfMeasure": ""
                        }
                      }
                    }
                  ]
                }
              },
              {
                "OpSegmentResponse": {
                  "ID": "COMMENT",
                  "ProcessSegmentID": "LoadCoil",
                  "SegmentData": [
                    {
                      "OpSegmentData": {
                        "ID": "ClearCommentFlag",
                        "Value": {
                          "ValueString": "Y",
                          "DataType": "char",
                          "UnitOfMeasure": ""
                        }
                      }
                    },
                    {
                      "OpSegmentData": {
                        "ID": "CommentText",
                        "Value": {
                          "ValueString": "RTS PARTLY SCRAPPED COMMENTS",
                          "DataType": "string",
                          "UnitOfMeasure": ""
                        }
                      }
                    }
                  ]
                }
              }
            ]
          }
        }
      },
      "Scrap": {
        "ApplicationArea": {
          "Sender": {
            "LogicalID": "WPCSC",
            "ReferenceID": "177F7B28-1B9F-4903-9AA1-E28197443520"
          },
          "CreationDateTime": now | todate,
          "BODID": "LoadCoil"
        },
        "DataArea": {
          "OperationsResponse": {
            "ID": "LoadCoil",
            "HierarchyScope": {
              "EquipmentID": $opsReq.HierarchyScope.EquipmentID,
              "EquipmentElementLevel": "StorageZone"
            },
            "OperationsType": "Production",
            "OperationsRequestID": $opsReq.ID, 
            "SegmentResponse": [
              {
                "OpSegmentResponse": {
                  "ID": "HEADER",
                  "ProcessSegmentID": "LoadCoil",
                  "MaterialActual": [
                    {
                      "OpMaterialActual": {
                        "MaterialLotID": "",
                        "MaterialActualProperty": [
                          {
                            "OpMaterialActualProperty": {
                              "ID": "StockID",
                              "Value": {
                                "ValueString": .ID,
                                "DataType": "string",
                                "UnitOfMeasure": ""
                              }
                            }
                          },
                          {
                            "OpMaterialActualProperty": {
                              "ID": "UnitID",
                              "Value": {
                                "ValueString": $opsReq.HierarchyScope.EquipmentID,
                                "DataType": "string",
                                "UnitOfMeasure": ""
                              }
                            }
                          },
                          {
                            "OpMaterialActualProperty": {
                              "ID": "Transaction_Type_ID",
                              "Value": {
                                "ValueString": "CONSUME",
                                "DataType": "string",
                                "UnitOfMeasure": ""
                              }
                            }
                          },
                          {
                            "OpMaterialActualProperty": {
                              "ID": "DateTimeStockUnLoaded",
                              "Value": {
                                "ValueString": now | todate,
                                "DataType": "datetime",
                                "UnitOfMeasure": ""
                              }
                            }
                          },
                          {
                            "OpMaterialActualProperty": {
                              "ID": "CurrentMass",
                              "Value": {
                                "ValueString": "0",
                                "DataType": "integer",
                                "UnitOfMeasure": "kg"
                              }
                            }
                          },
                          {
                            "OpMaterialActualProperty": {
                              "ID": "StatusCode",
                              "Value": {
                                "ValueString": "C",
                                "DataType": "string",
                                "UnitOfMeasure": ""
                              }
                            }
                          },
                          {
                            "OpMaterialActualProperty": {
                              "ID": "ProductItemNumber",
                              "Value": {
                                "ValueString": ([.SegmentParameter[].OpSegmentParameter | select(.ID == "ProductItemId")] | .[]?.Value?.ValueString // ""),
                                "DataType": "string",
                                "UnitOfMeasure": ""
                              }
                            }
                          },
                          {
                            "OpMaterialActualProperty": {
                              "ID": "ProductItemVariant",
                              "Value": {
                                "ValueString": ([.MaterialRequirement[0].OpMaterialRequirement.MaterialRequirementProperty[].OpMaterialRequirementProperty | select(.ID == "ShortSpec")] | .[]?.Value?.ValueString // ""),
                                "DataType": "string",
                                "UnitOfMeasure": ""
                              }
                            }
                          },
                          {
                            "OpMaterialActualProperty": {
                              "ID": "InventoryLotID",
                              "Value": {
                                "ValueString": ([.SegmentParameter[].OpSegmentParameter | select(.ID == "InventoryLotID")] | .[]?.Value?.ValueString // ""),
                                "DataType": "string",
                                "UnitOfMeasure": ""
                              }
                            }
                          },
                          {
                            "OpMaterialActualProperty": {
                              "ID": "ProductWidth",
                              "Value": {
                                "ValueString": ([.MaterialRequirement[0].OpMaterialRequirement.MaterialRequirementProperty[].OpMaterialRequirementProperty | select(.ID == "Width")] | .[]?.Value?.ValueString // ""),
                                "DataType": "integer",
                                "UnitOfMeasure": "mm"
                              }
                            }
                          },
                          {
                            "OpMaterialActualProperty": {
                              "ID": "ProductUnitMass",
                              "Value": {
                                "ValueString": ([.SegmentParameter[].OpSegmentParameter | select(.ID == "ProductUnitMass")] | .[]?.Value?.ValueString // ""),
                                "DataType": "integer",
                                "UnitOfMeasure": "kg"
                              }
                            }
                          }
                        ]
                      }
                    }
                  ]
                }
              },
              {
                "OpSegmentResponse": {
                  "ID": "SCRAP",
                  "ProcessSegmentID": "SCRAPCoil",
                  "MaterialActual": null,
                  "SegmentData": [
                    {
                      "OpSegmentData": {
                        "ID": "StockHoldFileKey",
                        "Value": {
                          "ValueString": "",
                          "DataType": "string",
                          "UnitOfMeasure": null
                        }
                      }
                    },
                    {
                      "OpSegmentData": {
                        "ID": "ClassClaim",
                        "Value": {
                          "ValueString": "40102",
                          "DataType": "string",
                          "UnitOfMeasure": null
                        }
                      }
                    },
                    {
                      "OpSegmentData": {
                        "ID": "HoldReason",
                        "Value": {
                          "ValueString": "127",
                          "DataType": "string",
                          "UnitOfMeasure": null
                        }
                      }
                    },
                    {
                      "OpSegmentData": {
                        "ID": "HoldDateTime",
                        "Value": {
                          "ValueString": now | todate,
                          "DataType": "datetime",
                          "UnitOfMeasure": null
                        }
                      }
                    },
                    {
                      "OpSegmentData": {
                        "ID": "LogonID",
                        "Value": {
                          "ValueString": "VSL1SPV",
                          "DataType": "string",
                          "UnitOfMeasure": null
                        }
                      }
                    },
                    {
                      "OpSegmentData": {
                        "ID": "Mass",
                        "Value": {
                          "ValueString": "50",
                          "DataType": "integer",
                          "UnitOfMeasure": "kg"
                        }
                      }
                    },
                    {
                      "OpSegmentData": {
                        "ID": "DistanceDefectEdge",
                        "Value": {
                          "ValueString": "100",
                          "DataType": "integer",
                          "UnitOfMeasure": "mm"
                        }
                      }
                    },

                    {
                      "OpSegmentData": {
                        "ID": "SubtypeCode",
                        "Value": {
                          "ValueString": "",
                          "DataType": "char",
                          "UnitOfMeasure": null
                        }
                      }
                    },
                    {
                      "OpSegmentData": {
                        "ID": "SeverityCode",
                        "Value": {
                          "ValueString": "9",
                          "DataType": "string",
                          "UnitOfMeasure": null
                        }
                      }
                    },
                    {
                      "OpSegmentData": {
                        "ID": "Crew",
                        "Value": {
                          "ValueString": "C",
                          "DataType": "char",
                          "UnitOfMeasure": null
                        }
                      }
                    },
                    {
                      "OpSegmentData": {
                        "ID": "SetupComment",
                        "Value": {
                          "ValueString": "Root Cause Comment",
                          "DataType": "string",
                          "UnitOfMeasure": null
                        }
                      }
                    }
                  ]
                }
              }
            ]
          }
        }
      },
      "Orders": $opsReq | [.SegmentRequirement[].OpSegmentRequirement | select(.Description == "InventoryLotId") | {
        (.ID): {
          "Child": {
            "ApplicationArea": {
              "Sender": {
                "LogicalID": "WPCSC",
                "ReferenceID": "D2882995-8131-436A-82F7-6779147BD267"
              },
              "CreationDateTime": now | todate,
              "BODID": "ChildCoil"
            },
            "DataArea": {
              "OperationsResponse": {
                "ID": "ChildCoil",
                "HierarchyScope": {
                  "EquipmentID": $opsReq.HierarchyScope.EquipmentID,
                  "EquipmentElementLevel": "StorageZone"
                },
                "OperationsType": "Production",
                "OperationsRequestID": $opsReq.ID,
                "SegmentResponse": [
                  {
                    "OpSegmentResponse": {
                      "ID": "HEADER",
                      "ProcessSegmentID": "ChildCoil",
                      "SegmentData": [
                        {
                          "OpSegmentData": {
                            "ID": "UnitID",
                            "Value": {
                              "ValueString": $opsReq.HierarchyScope.EquipmentID,
                              "DataType": "string",
                              "UnitOfMeasure": ""
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "TransactionType",
                            "Value": {
                              "ValueString": "CHILD",
                              "DataType": "string",
                              "UnitOfMeasure": ""
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "ChildCoilID",
                            "Value": {
                              "ValueString": ($feedcoil.ID + "S001"),
                              "DataType": "string",
                              "UnitOfMeasure": ""
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "PPINumber",
                            "Value": {
                              "ValueString": $opsReq.ID,
                              "DataType": "string",
                              "UnitOfMeasure": ""
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "InventoryLotID",
                            "Value": {
                              "ValueString": .ID,
                              "DataType": "string",
                              "UnitOfMeasure": ""
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "ProductItemNumber",
                            "Value": {
                              "ValueString": ([.SegmentParameter[].OpSegmentParameter | select(.ID == "ProductItemId")] | .[]?.Value?.ValueString // ""),
                              "DataType": "string",
                              "UnitOfMeasure": ""
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "ProductItemVariant",
                            "Value": {
                              "ValueString": ([.MaterialRequirement[].OpMaterialRequirement | select(.MaterialUse == "Produced") | .MaterialRequirementProperty[].OpMaterialRequirementProperty | select(.ID == "FinishedShortSpec")] | .[]?.Value?.ValueString // ""),
                              "DataType": "string",
                              "UnitOfMeasure": ""
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "FloorLocation",
                            "Value": {
                              "ValueString": "<Default>",
                              "DataType": "string",
                              "UnitOfMeasure": ""
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "ProductionType",
                            "Value": {
                              "ValueString": ([.SegmentParameter[].OpSegmentParameter | select(.ID == "ProductionType")] | .[]?.Value?.ValueString // ""),
                              "DataType": "string",
                              "UnitOfMeasure": ""
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "Quality",
                            "Value": {
                              "ValueString": ([.MaterialRequirement[].OpMaterialRequirement | select(.MaterialUse == "Produced") | .MaterialRequirementProperty[].OpMaterialRequirementProperty | select(.ID == "Quality")] | .[]?.Value?.ValueString // ""),
                              "DataType": "string",
                              "UnitOfMeasure": ""
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "ProductWidth",
                            "Value": {
                              "ValueString": ([.SegmentParameter[].OpSegmentParameter | select(.ID == "ProductWidth")] | .[]?.Value?.ValueString // ""),
                              "DataType": "integer",
                              "UnitOfMeasure": "mm"
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "ProductUnitMass",
                            "Value": {
                              "ValueString": ([.SegmentParameter[].OpSegmentParameter | select(.ID == "ProductUnitMass")] | .[]?.Value?.ValueString // ""),
                              "DataType": "integer",
                              "UnitOfMeasure": "kg"
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "UnitMass",
                            "Value": {
                              "ValueString": ([.MaterialRequirement[].OpMaterialRequirement | select(.MaterialUse == "Consumed") | .Quantity[].QuantityValue | select(.Key == "NominalPackMass")] | .[]?.QuantityString // ""),
                              "DataType": "integer",
                              "UnitOfMeasure": "kg"
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "HeatNumber",
                            "Value": {
                              "ValueString": ([$feedcoil.MaterialRequirement[0].OpMaterialRequirement.MaterialRequirementProperty[].OpMaterialRequirementProperty | select(.ID == "HeatNumber")] | .[]?.Value?.ValueString // ""),
                              "DataType": "string",
                              "UnitOfMeasure": ""
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "MillTag",
                            "Value": {
                              "ValueString": ([$feedcoil.MaterialRequirement[0].OpMaterialRequirement.MaterialRequirementProperty[].OpMaterialRequirementProperty | select(.ID == "MillTag")] | .[]?.Value?.ValueString // ""),
                              "DataType": "string",
                              "UnitOfMeasure": ""
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "MasterTag",
                            "Value": {
                              "ValueString": ([$feedcoil.MaterialRequirement[0].OpMaterialRequirement.MaterialRequirementProperty[].OpMaterialRequirementProperty | select(.ID == "MasterTag")] | .[]?.Value?.ValueString // ""),
                              "DataType": "string",
                              "UnitOfMeasure": ""
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "COMCustomerCode",
                            "Value": {
                              "ValueString": ([$feedcoil.MaterialRequirement[0].OpMaterialRequirement.MaterialRequirementProperty[].OpMaterialRequirementProperty | select(.ID == "COMCustomerCode")] | .[]?.Value?.ValueString // ""),
                              "DataType": "string",
                              "UnitOfMeasure": ""
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "BundleID",
                            "Value": {
                              "ValueString": "",
                              "DataType": "string",
                              "UnitOfMeasure": ""
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "PackMass",
                            "Value": {
                              "ValueString": ([.MaterialRequirement[].OpMaterialRequirement | select(.MaterialUse == "Consumed") | .Quantity[].QuantityValue | select(.Key == "NominalPackMass")] | .[]?.QuantityString // ""),
                              "DataType": "integer",
                              "UnitOfMeasure": "kg"
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "Thickness",
                            "Value": {
                              "ValueString": ([.MaterialRequirement[].OpMaterialRequirement | select(.MaterialUse == "Produced") | .MaterialRequirementProperty[].OpMaterialRequirementProperty | select(.ID == "Thickness")] | .[]?.Value?.ValueString // ""),
                              "DataType": "integer",
                              "UnitOfMeasure": "mm"
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "Length",
                            "Value": {
                              "ValueString": "9999",
                              "DataType": "integer",
                              "UnitOfMeasure": "mm"
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "BoreDiameter",
                            "Value": {
                              "ValueString": ([.MaterialRequirement[].OpMaterialRequirement | select(.MaterialUse == "Produced") | .MaterialRequirementProperty[].OpMaterialRequirementProperty | select(.ID == "BoreDiameter")] | .[]?.Value?.ValueString // ""),
                              "DataType": "integer",
                              "UnitOfMeasure": "mm"
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "OutsideDiameter",
                            "Value": {
                              "ValueString": ([.MaterialRequirement[].OpMaterialRequirement | select(.MaterialUse == "Produced") | .MaterialRequirementProperty[].OpMaterialRequirementProperty | select(.ID == "MaximumCoilDiameter")] | .[]?.Value?.ValueString // ""),
                              "DataType": "integer",
                              "UnitOfMeasure": "mm"
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "BrandCode",
                            "Value": {
                              "ValueString": ([.MaterialRequirement[].OpMaterialRequirement | select(.MaterialUse == "Produced") | .MaterialRequirementProperty[].OpMaterialRequirementProperty | select(.ID == "BrandCode")] | .[]?.Value?.ValueString // ""),
                              "DataType": "string",
                              "UnitOfMeasure": ""
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "WrapUnderFlag",
                            "Value": {
                              "ValueString": ([.MaterialRequirement[].OpMaterialRequirement | select(.MaterialUse == "Produced") | .MaterialRequirementProperty[].OpMaterialRequirementProperty | select(.ID == "WrapUnderFlag")] | .[]?.Value?.ValueString // ""),
                              "DataType": "string",
                              "UnitOfMeasure": ""
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "ParentCoilID",
                            "Value": {
                              "ValueString": $feedcoil.ID,
                              "DataType": "string",
                              "UnitOfMeasure": ""
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "Mass",
                            "Value": {
                              "ValueString": ([.MaterialRequirement[].OpMaterialRequirement | select(.MaterialUse == "Consumed") | .Quantity[].QuantityValue | select(.Key == "NominalPackMass")] | .[]?.QuantityString // ""),
                              "DataType": "integer",
                              "UnitOfMeasure": "kg"
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "Width",
                            "Value": {
                              "ValueString": ([.MaterialRequirement[].OpMaterialRequirement | select(.MaterialUse == "Produced") | .MaterialRequirementProperty[].OpMaterialRequirementProperty | select(.ID == "Width")] | .[]?.Value?.ValueString // ""),
                              "DataType": "real",
                              "UnitOfMeasure": "mm"
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "Action",
                            "Value": {
                              "ValueString": .ID,
                              "DataType": "string",
                              "UnitOfMeasure": ""
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "SurfaceProtection",
                            "Value": {
                              "ValueString": ([.MaterialRequirement[].OpMaterialRequirement | select(.MaterialUse == "Produced") | .MaterialRequirementProperty[].OpMaterialRequirementProperty | select(.ID == "SurfaceProtectionAbbrevDesc")] | .[]?.Value?.ValueString // ""),
                              "DataType": "string",
                              "UnitOfMeasure": ""
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "PackTypeCode",
                            "Value": {
                              "ValueString": ([.MaterialRequirement[].OpMaterialRequirement | select(.MaterialUse == "Produced") | .MaterialRequirementProperty[].OpMaterialRequirementProperty | select(.ID == "PackType")] | .[]?.Value?.ValueString // ""),
                              "DataType": "string",
                              "UnitOfMeasure": ""
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "KeepDryCount",
                            "Value": {
                              "ValueString": "2",
                              "DataType": "integer",
                              "UnitOfMeasure": ""
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "NumberOfCoils",
                            "Value": {
                              "ValueString": ([.MaterialRequirement[].OpMaterialRequirement | select(.MaterialUse == "Produced") | .MaterialRequirementProperty[].OpMaterialRequirementProperty | select(.ID == "MinimumNumberOfUnitsPerPack")] | .[]?.Value?.ValueString // ""),
                              "DataType": "integer",
                              "UnitOfMeasure": ""
                            }
                          }
                        }
                      ]
                    }
                  },
                  {
                    "OpSegmentResponse": {
                      "ID": "COMMENT",
                      "ProcessSegmentID": "ChildCoil",
                      "SegmentData": [
                        {
                          "OpSegmentData": {
                            "ID": "ClearCommentFlag",
                            "Value": {
                              "ValueString": "N",
                              "DataType": "char",
                              "UnitOfMeasure": ""
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "CommentText",
                            "Value": {
                              "ValueString": "",
                              "DataType": "string",
                              "UnitOfMeasure": ""
                            }
                          }
                        }
                      ]
                    }
                  }
                ]
              }
            }
          },
          "Hold": {
            "ApplicationArea": {
              "Sender": {
                "LogicalID": "WPCSC",
                "ReferenceID": "D2882995-8131-436A-82F7-6779147BD267"
              },
              "CreationDateTime": now | todate,
              "BODID": "ChildCoil"
            },
            "DataArea": {
              "OperationsResponse": {
                "ID": "ChildCoil",
                "HierarchyScope": {
                  "EquipmentID": $opsReq.HierarchyScope.EquipmentID,
                  "EquipmentElementLevel": "StorageZone"
                },
                "OperationsType": "Production",
                "OperationsRequestID": $opsReq.ID,
                "SegmentResponse": [
                  {
                    "OpSegmentResponse": {
                      "ID": "HEADER",
                      "ProcessSegmentID": "ChildCoil",
                      "SegmentData": [
                        {
                          "OpSegmentData": {
                            "ID": "UnitID",
                            "Value": {
                              "ValueString": $opsReq.HierarchyScope.EquipmentID,
                              "DataType": "string",
                              "UnitOfMeasure": ""
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "TransactionType",
                            "Value": {
                              "ValueString": "CHILD",
                              "DataType": "string",
                              "UnitOfMeasure": ""
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "ChildCoilID",
                            "Value": {
                              "ValueString": ($feedcoil.ID + "S002"),
                              "DataType": "string",
                              "UnitOfMeasure": ""
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "PPINumber",
                            "Value": {
                              "ValueString": $opsReq.ID,
                              "DataType": "string",
                              "UnitOfMeasure": ""
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "InventoryLotID",
                            "Value": {
                              "ValueString": .ID,
                              "DataType": "string",
                              "UnitOfMeasure": ""
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "ProductItemNumber",
                            "Value": {
                              "ValueString": ([.SegmentParameter[].OpSegmentParameter | select(.ID == "ProductItemId")] | .[]?.Value?.ValueString // ""),
                              "DataType": "string",
                              "UnitOfMeasure": ""
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "ProductItemVariant",
                            "Value": {
                              "ValueString": ([.MaterialRequirement[].OpMaterialRequirement | select(.MaterialUse == "Produced") | .MaterialRequirementProperty[].OpMaterialRequirementProperty | select(.ID == "FinishedShortSpec")] | .[]?.Value?.ValueString // ""),
                              "DataType": "string",
                              "UnitOfMeasure": ""
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "FloorLocation",
                            "Value": {
                              "ValueString": "<Default>",
                              "DataType": "string",
                              "UnitOfMeasure": ""
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "ProductionType",
                            "Value": {
                              "ValueString": ([.SegmentParameter[].OpSegmentParameter | select(.ID == "ProductionType")] | .[]?.Value?.ValueString // ""),
                              "DataType": "string",
                              "UnitOfMeasure": ""
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "Quality",
                            "Value": {
                              "ValueString": ([.MaterialRequirement[].OpMaterialRequirement | select(.MaterialUse == "Produced") | .MaterialRequirementProperty[].OpMaterialRequirementProperty | select(.ID == "Quality")] | .[]?.Value?.ValueString // ""),
                              "DataType": "string",
                              "UnitOfMeasure": ""
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "ProductWidth",
                            "Value": {
                              "ValueString": ([.SegmentParameter[].OpSegmentParameter | select(.ID == "ProductWidth")] | .[]?.Value?.ValueString // ""),
                              "DataType": "integer",
                              "UnitOfMeasure": "mm"
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "ProductUnitMass",
                            "Value": {
                              "ValueString": ([.SegmentParameter[].OpSegmentParameter | select(.ID == "ProductUnitMass")] | .[]?.Value?.ValueString // ""),
                              "DataType": "integer",
                              "UnitOfMeasure": "kg"
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "UnitMass",
                            "Value": {
                              "ValueString": ([.MaterialRequirement[].OpMaterialRequirement | select(.MaterialUse == "Consumed") | .Quantity[].QuantityValue | select(.Key == "NominalPackMass")] | .[]?.QuantityString // ""),
                              "DataType": "integer",
                              "UnitOfMeasure": "kg"
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "HeatNumber",
                            "Value": {
                              "ValueString": ([$feedcoil.MaterialRequirement[0].OpMaterialRequirement.MaterialRequirementProperty[].OpMaterialRequirementProperty | select(.ID == "HeatNumber")] | .[]?.Value?.ValueString // ""),
                              "DataType": "string",
                              "UnitOfMeasure": ""
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "MillTag",
                            "Value": {
                              "ValueString": ([$feedcoil.MaterialRequirement[0].OpMaterialRequirement.MaterialRequirementProperty[].OpMaterialRequirementProperty | select(.ID == "MillTag")] | .[]?.Value?.ValueString // ""),
                              "DataType": "string",
                              "UnitOfMeasure": ""
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "MasterTag",
                            "Value": {
                              "ValueString": ([$feedcoil.MaterialRequirement[0].OpMaterialRequirement.MaterialRequirementProperty[].OpMaterialRequirementProperty | select(.ID == "MasterTag")] | .[]?.Value?.ValueString // ""),
                              "DataType": "string",
                              "UnitOfMeasure": ""
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "COMCustomerCode",
                            "Value": {
                              "ValueString": ([$feedcoil.MaterialRequirement[0].OpMaterialRequirement.MaterialRequirementProperty[].OpMaterialRequirementProperty | select(.ID == "COMCustomerCode")] | .[]?.Value?.ValueString // ""),
                              "DataType": "string",
                              "UnitOfMeasure": ""
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "BundleID",
                            "Value": {
                              "ValueString": "",
                              "DataType": "string",
                              "UnitOfMeasure": ""
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "PackMass",
                            "Value": {
                              "ValueString": ([.MaterialRequirement[].OpMaterialRequirement | select(.MaterialUse == "Consumed") | .Quantity[].QuantityValue | select(.Key == "NominalPackMass")] | .[]?.QuantityString // ""),
                              "DataType": "integer",
                              "UnitOfMeasure": "kg"
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "Thickness",
                            "Value": {
                              "ValueString": ([.MaterialRequirement[].OpMaterialRequirement | select(.MaterialUse == "Produced") | .MaterialRequirementProperty[].OpMaterialRequirementProperty | select(.ID == "Thickness")] | .[]?.Value?.ValueString // ""),
                              "DataType": "integer",
                              "UnitOfMeasure": "mm"
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "Length",
                            "Value": {
                              "ValueString": "9999",
                              "DataType": "integer",
                              "UnitOfMeasure": "mm"
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "BoreDiameter",
                            "Value": {
                              "ValueString": ([.MaterialRequirement[].OpMaterialRequirement | select(.MaterialUse == "Produced") | .MaterialRequirementProperty[].OpMaterialRequirementProperty | select(.ID == "BoreDiameter")] | .[]?.Value?.ValueString // ""),
                              "DataType": "integer",
                              "UnitOfMeasure": "mm"
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "OutsideDiameter",
                            "Value": {
                              "ValueString": ([.MaterialRequirement[].OpMaterialRequirement | select(.MaterialUse == "Produced") | .MaterialRequirementProperty[].OpMaterialRequirementProperty | select(.ID == "MaximumCoilDiameter")] | .[]?.Value?.ValueString // ""),
                              "DataType": "integer",
                              "UnitOfMeasure": "mm"
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "BrandCode",
                            "Value": {
                              "ValueString": ([.MaterialRequirement[].OpMaterialRequirement | select(.MaterialUse == "Produced") | .MaterialRequirementProperty[].OpMaterialRequirementProperty | select(.ID == "BrandCode")] | .[]?.Value?.ValueString // ""),
                              "DataType": "string",
                              "UnitOfMeasure": ""
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "WrapUnderFlag",
                            "Value": {
                              "ValueString": ([.MaterialRequirement[].OpMaterialRequirement | select(.MaterialUse == "Produced") | .MaterialRequirementProperty[].OpMaterialRequirementProperty | select(.ID == "WrapUnderFlag")] | .[]?.Value?.ValueString // ""),
                              "DataType": "string",
                              "UnitOfMeasure": ""
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "ParentCoilID",
                            "Value": {
                              "ValueString": $feedcoil.ID,
                              "DataType": "string",
                              "UnitOfMeasure": ""
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "Mass",
                            "Value": {
                              "ValueString": ([.MaterialRequirement[].OpMaterialRequirement | select(.MaterialUse == "Consumed") | .Quantity[].QuantityValue | select(.Key == "NominalPackMass")] | .[]?.QuantityString // ""),
                              "DataType": "integer",
                              "UnitOfMeasure": "kg"
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "Width",
                            "Value": {
                              "ValueString": ([.MaterialRequirement[].OpMaterialRequirement | select(.MaterialUse == "Produced") | .MaterialRequirementProperty[].OpMaterialRequirementProperty | select(.ID == "Width")] | .[]?.Value?.ValueString // ""),
                              "DataType": "real",
                              "UnitOfMeasure": "mm"
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "Action",
                            "Value": {
                              "ValueString": "HOLD",
                              "DataType": "string",
                              "UnitOfMeasure": ""
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "SurfaceProtection",
                            "Value": {
                              "ValueString": ([.MaterialRequirement[].OpMaterialRequirement | select(.MaterialUse == "Produced") | .MaterialRequirementProperty[].OpMaterialRequirementProperty | select(.ID == "SurfaceProtectionAbbrevDesc")] | .[]?.Value?.ValueString // ""),
                              "DataType": "string",
                              "UnitOfMeasure": ""
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "PackTypeCode",
                            "Value": {
                              "ValueString": ([.MaterialRequirement[].OpMaterialRequirement | select(.MaterialUse == "Produced") | .MaterialRequirementProperty[].OpMaterialRequirementProperty | select(.ID == "PackType")] | .[]?.Value?.ValueString // ""),
                              "DataType": "string",
                              "UnitOfMeasure": ""
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "KeepDryCount",
                            "Value": {
                              "ValueString": "2",
                              "DataType": "integer",
                              "UnitOfMeasure": ""
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "NumberOfCoils",
                            "Value": {
                              "ValueString": ([.MaterialRequirement[].OpMaterialRequirement | select(.MaterialUse == "Produced") | .MaterialRequirementProperty[].OpMaterialRequirementProperty | select(.ID == "MinimumNumberOfUnitsPerPack")] | .[]?.Value?.ValueString // ""),
                              "DataType": "integer",
                              "UnitOfMeasure": ""
                            }
                          }
                        }
                      ]
                    }
                  },
                  {
                    "OpSegmentResponse": {
                      "ID": "HOLD",
                      "Description": "Hold details",
                      "ProcessSegmentID": "ChildCoil",
                      "SegmentData": [
                        {
                          "OpSegmentData": {
                            "ID": "StockHoldFileKey",
                            "Value": {
                              "ValueString": "",
                              "DataType": "string",
                              "UnitOfMeasure": null
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "StockId",
                            "Value": {
                              "ValueString": ($feedcoil.ID + "S002"),
                              "DataType": "string",
                              "UnitOfMeasure": null
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "SampleFlag",
                            "Value": {
                              "ValueString": "Y",
                              "DataType": "string",
                              "UnitOfMeasure": null
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "ClassClaim",
                            "Value": {
                              "ValueString": "16411",
                              "DataType": "string",
                              "UnitOfMeasure": null
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "HoldReason",
                            "Value": {
                              "ValueString": "3",
                              "DataType": "string",
                              "UnitOfMeasure": null
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "HoldDateTime",
                            "Value": {
                              "ValueString": now | todate,
                              "DataType": "datetime",
                              "UnitOfMeasure": null
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "LogonID",
                            "Value": {
                              "ValueString": "VSL1SPV",
                              "DataType": "string",
                              "UnitOfMeasure": null
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "Mass",
                            "Value": {
                              "ValueString": "630",
                              "DataType": "integer",
                              "UnitOfMeasure": "kg"
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "DistanceDefectEdge",
                            "Value": {
                              "ValueString": "0",
                              "DataType": "integer",
                              "UnitOfMeasure": "mm"
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "DistanceDefectSep",
                            "Value": {
                              "ValueString": "0",
                              "DataType": "integer",
                              "UnitOfMeasure": "mm"
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "Length",
                            "Value": {
                              "ValueString": "0",
                              "DataType": "integer",
                              "UnitOfMeasure": "mm"
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "Height",
                            "Value": {
                              "ValueString": "0",
                              "DataType": "integer",
                              "UnitOfMeasure": "mm"
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "PositionDefectDrive",
                            "Value": {
                              "ValueString": "N",
                              "DataType": "char",
                              "UnitOfMeasure": null
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "PositionDefectOperator",
                            "Value": {
                              "ValueString": "N",
                              "DataType": "char",
                              "UnitOfMeasure": null
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "PositionDefectMiddle",
                            "Value": {
                              "ValueString": "N",
                              "DataType": "char",
                              "UnitOfMeasure": null
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "PositionDefectTop",
                            "Value": {
                              "ValueString": "N",
                              "DataType": "char",
                              "UnitOfMeasure": null
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "PositionDefectRev",
                            "Value": {
                              "ValueString": "N",
                              "DataType": "char",
                              "UnitOfMeasure": null
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "PositionDefectFront",
                            "Value": {
                              "ValueString": "N",
                              "DataType": "char",
                              "UnitOfMeasure": null
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "PositionDefectQuarter",
                            "Value": {
                              "ValueString": "N",
                              "DataType": "char",
                              "UnitOfMeasure": null
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "PositionDefectHalf",
                            "Value": {
                              "ValueString": "N",
                              "DataType": "char",
                              "UnitOfMeasure": null
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "PositionDefect3Quarter",
                            "Value": {
                              "ValueString": "N",
                              "DataType": "char",
                              "UnitOfMeasure": null
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "PositionDefectEnd",
                            "Value": {
                              "ValueString": "N",
                              "DataType": "char",
                              "UnitOfMeasure": null
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "PositionDefectRandom",
                            "Value": {
                              "ValueString": "N",
                              "DataType": "char",
                              "UnitOfMeasure": null
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "Subtypecode",
                            "Value": {
                              "ValueString": "",
                              "DataType": "string",
                              "UnitOfMeasure": null
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "SeverityCode",
                            "Value": {
                              "ValueString": "",
                              "DataType": "string",
                              "UnitOfMeasure": null
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "Crew",
                            "Value": {
                              "ValueString": "A",
                              "DataType": "char",
                              "UnitOfMeasure": null
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "PhotoFlag",
                            "Value": {
                              "ValueString": "N",
                              "DataType": "char",
                              "UnitOfMeasure": null
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "Setupcomment",
                            "Value": {
                              "ValueString": "",
                              "DataType": "string",
                              "UnitOfMeasure": null
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "RootCauseComment",
                            "Value": {
                              "ValueString": "",
                              "DataType": "string",
                              "UnitOfMeasure": null
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "HoldComment",
                            "Value": {
                              "ValueString": "",
                              "DataType": "string",
                              "UnitOfMeasure": null
                            }
                          }
                        }
                      ]
                    }
                  },
                  {
                    "OpSegmentResponse": {
                      "ID": "COMMENT",
                      "ProcessSegmentID": "ChildCoil",
                      "SegmentData": [
                        {
                          "OpSegmentData": {
                            "ID": "ClearCommentFlag",
                            "Value": {
                              "ValueString": "N",
                              "DataType": "char",
                              "UnitOfMeasure": ""
                            }
                          }
                        },
                        {
                          "OpSegmentData": {
                            "ID": "CommentText",
                            "Value": {
                              "ValueString": "",
                              "DataType": "string",
                              "UnitOfMeasure": ""
                            }
                          }
                        }
                      ]
                    }
                  }
                ]
              }
            }
          },
        }
      }] | add,
    }
  }] | add
}] | add
