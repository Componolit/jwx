GNATdoc.Documentation = {
  "label": "JWX.Stream_Auth",
  "qualifier": "",
  "summary": [
    {
      "kind": "paragraph",
      "children": [
        {
          "kind": "span",
          "text": "Stream authentication checking \n"
        }
      ]
    }
  ],
  "description": [
    {
      "kind": "paragraph",
      "children": [
        {
          "kind": "span",
          "text": "Given a key in the form of a JSON web key (JWK), an audience string and an\n"
        },
        {
          "kind": "span",
          "text": "issuer string, the Authenticated procedure in this package searches an input\n"
        },
        {
          "kind": "span",
          "text": "string for a JSON web token (JWT), decodes it and tries to validate it. The\n"
        },
        {
          "kind": "span",
          "text": "JWT must be present as the URL parameter \"id_token=\".\n"
        }
      ]
    }
  ],
  "entities": [
    {
      "entities": [
        {
          "label": "Auth_Result_Type",
          "qualifier": "",
          "line": 24,
          "column": 9,
          "src": "srcs/jwx-stream_auth.ads.html",
          "summary": [
          ],
          "description": [
            {
              "kind": "code",
              "children": [
                {
                  "kind": "line",
                  "number": 24,
                  "children": [
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": "   "
                    },
                    {
                      "kind": "span",
                      "cssClass": "keyword",
                      "text": "type"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Auth_Result_Type",
                      "href": "docs/jwx__stream_auth___spec.html#L24C9"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "keyword",
                      "text": "is"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "("
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Auth_OK",
                      "href": "docs/jwx__stream_auth___spec.html#L24C30"
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ","
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Auth_Noent",
                      "href": "docs/jwx__stream_auth___spec.html#L24C39"
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ","
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Auth_Fail",
                      "href": "docs/jwx__stream_auth___spec.html#L24C51"
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ","
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Auth_Invalid",
                      "href": "docs/jwx__stream_auth___spec.html#L24C62"
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ")"
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ";",
                      "href": "docs/jwx__stream_auth___spec.html#L24C9"
                    }
                  ]
                }
              ]
            },
            {
              "kind": "paragraph",
              "children": [
                {
                  "kind": "span",
                  "text": "Authentication result\n"
                }
              ]
            }
          ],
          "literals": [
            {
              "label": "Auth_OK",
              "line": 24,
              "column": 30,
              "description": [
                {
                  "kind": "paragraph",
                  "children": [
                    {
                      "kind": "span",
                      "text": "Authentication succeeded\n"
                    }
                  ]
                }
              ]
            },
            {
              "label": "Auth_Noent",
              "line": 24,
              "column": 39,
              "description": [
                {
                  "kind": "paragraph",
                  "children": [
                    {
                      "kind": "span",
                      "text": "No JSON web token found in input data\n"
                    }
                  ]
                }
              ]
            },
            {
              "label": "Auth_Fail",
              "line": 24,
              "column": 51,
              "description": [
                {
                  "kind": "paragraph",
                  "children": [
                    {
                      "kind": "span",
                      "text": "JSON web token found, but authentication failed\n"
                    }
                  ]
                }
              ]
            },
            {
              "label": "Auth_Invalid",
              "line": 24,
              "column": 62,
              "description": [
                {
                  "kind": "paragraph",
                  "children": [
                    {
                      "kind": "span",
                      "text": "Unspecified error during authentication\n"
                    }
                  ]
                }
              ]
            }
          ]
        }
      ],
      "label": "Simple types"
    },
    {
      "entities": [
        {
          "label": "Authenticated",
          "qualifier": "",
          "line": 32,
          "column": 13,
          "src": "srcs/jwx-stream_auth.ads.html",
          "summary": [
          ],
          "description": [
            {
              "kind": "code",
              "children": [
                {
                  "kind": "line",
                  "number": 32,
                  "children": [
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": "   "
                    },
                    {
                      "kind": "span",
                      "cssClass": "keyword",
                      "text": "function"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Authenticated",
                      "href": "docs/jwx__stream_auth___spec.html#L32C13"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "("
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Buf",
                      "href": "docs/jwx__stream_auth___spec.html#L32C28"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ":"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "String"
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ";"
                    }
                  ]
                },
                {
                  "kind": "line",
                  "number": 33,
                  "children": [
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": "                           "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Now",
                      "href": "docs/jwx__stream_auth___spec.html#L33C28"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ":"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Long_Integer"
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ")"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "keyword",
                      "text": "return"
                    },
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": " "
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": "Auth_Result_Type",
                      "href": "docs/jwx__stream_auth___spec.html#L24C9"
                    }
                  ]
                },
                {
                  "kind": "line",
                  "number": 34,
                  "children": [
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": "   "
                    },
                    {
                      "kind": "span",
                      "cssClass": "keyword",
                      "text": "with"
                    }
                  ]
                },
                {
                  "kind": "line",
                  "number": 35,
                  "children": [
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": "      Pre => Buf'First >= JWX.Data_Index'First "
                    },
                    {
                      "kind": "span",
                      "cssClass": "keyword",
                      "text": "and"
                    }
                  ]
                },
                {
                  "kind": "line",
                  "number": 36,
                  "children": [
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": "             Buf'Last <= JWX.Data_Index'Last "
                    },
                    {
                      "kind": "span",
                      "cssClass": "keyword",
                      "text": "and"
                    }
                  ]
                },
                {
                  "kind": "line",
                  "number": 37,
                  "children": [
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": "             Buf'Last < Natural'Last - 9 "
                    },
                    {
                      "kind": "span",
                      "cssClass": "keyword",
                      "text": "and"
                    }
                  ]
                },
                {
                  "kind": "line",
                  "number": 38,
                  "children": [
                    {
                      "kind": "span",
                      "cssClass": "text",
                      "text": "             Buf'Length > 9"
                    },
                    {
                      "kind": "span",
                      "cssClass": "identifier",
                      "text": ";"
                    }
                  ]
                }
              ]
            },
            {
              "kind": "paragraph",
              "children": [
                {
                  "kind": "span",
                  "text": "Check whether string contains valid authentication token\n"
                }
              ]
            }
          ],
          "parameters": [
            {
              "label": "Buf",
              "line": 32,
              "column": 28,
              "type": {
                "label": "String"
              },
              "description": [
                {
                  "kind": "paragraph",
                  "children": [
                    {
                      "kind": "span",
                      "text": "String buffer to validate\n"
                    }
                  ]
                }
              ]
            },
            {
              "label": "Now",
              "line": 33,
              "column": 28,
              "type": {
                "label": "Long_Integer"
              },
              "description": [
                {
                  "kind": "paragraph",
                  "children": [
                    {
                      "kind": "span",
                      "text": "Current time as a UNIX Epoch (seconds since 1.1.1970)\n"
                    }
                  ]
                }
              ]
            }
          ]
        }
      ],
      "label": "Subprograms"
    }
  ]
};