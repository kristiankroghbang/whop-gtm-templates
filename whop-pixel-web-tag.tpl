___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Whop Pixel",
  "description": "Loads the Whop pixel (t.whop.tw/s.js) and tracks page views, standard and custom events with optional value, currency and customer data. Developed by Kristian Krogh Bang.",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "accountIds",
    "displayName": "Business ID(s)",
    "simpleValueType": true,
    "help": "Your Whop business ID (biz_...), found in your dashboard URL. Separate multiple IDs with commas to track several businesses.",
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ]
  },
  {
    "type": "RADIO",
    "name": "eventType",
    "displayName": "Event",
    "simpleValueType": true,
    "defaultValue": "pageview",
    "radioItems": [
      {
        "value": "pageview",
        "displayValue": "Page view",
        "help": "Sends whop.track(\"page\"). Fire on All Pages (or History Change for SPAs)."
      },
      {
        "value": "standard",
        "displayValue": "Standard event",
        "subParams": [
          {
            "type": "SELECT",
            "name": "standardEventName",
            "displayName": "Standard Event",
            "simpleValueType": true,
            "macrosInSelect": false,
            "selectItems": [
              {
                "value": "lead",
                "displayValue": "lead - contact form or opt-in submitted"
              },
              {
                "value": "schedule",
                "displayValue": "schedule - call or appointment booked"
              },
              {
                "value": "submit_application",
                "displayValue": "submit_application - application completed"
              },
              {
                "value": "contact",
                "displayValue": "contact - conversation or inquiry started"
              },
              {
                "value": "complete_registration",
                "displayValue": "complete_registration - signup finished"
              },
              {
                "value": "view_content",
                "displayValue": "view_content - key page or content viewed"
              },
              {
                "value": "add_to_cart",
                "displayValue": "add_to_cart - item added to cart"
              }
            ]
          }
        ]
      },
      {
        "value": "custom",
        "displayValue": "Custom event",
        "subParams": [
          {
            "type": "TEXT",
            "name": "customEventName",
            "displayName": "Custom Event Name",
            "simpleValueType": true,
            "help": "Keep names short, stable and reused from a small set - names under ~34 characters forward to Meta as custom conversions. Do not track purchases, subscriptions or trials that happen on Whop checkout; Whop records those server-side automatically."
          }
        ]
      }
    ]
  },
  {
    "type": "TEXT",
    "name": "eventValue",
    "displayName": "Value",
    "simpleValueType": true,
    "help": "Optional monetary value of the event."
  },
  {
    "type": "TEXT",
    "name": "eventCurrency",
    "displayName": "Currency",
    "simpleValueType": true,
    "help": "Optional ISO 4217 currency code, e.g. USD."
  },
  {
    "type": "GROUP",
    "name": "customerDataGroup",
    "displayName": "Customer Data",
    "groupStyle": "ZIPPY_CLOSED",
    "subParams": [
      {
        "type": "SIMPLE_TABLE",
        "name": "customerDataList",
        "displayName": "Customer Data",
        "help": "Optional but recommended - attach as much customer data as you have so events attribute correctly. Email is the strongest identifier. Send plain values, not hashed.",
        "simpleTableColumns": [
          {
            "defaultValue": "",
            "displayName": "Field",
            "name": "name",
            "type": "SELECT",
            "selectItems": [
              {
                "value": "email",
                "displayValue": "email"
              },
              {
                "value": "phone",
                "displayValue": "phone"
              },
              {
                "value": "first_name",
                "displayValue": "first_name"
              },
              {
                "value": "last_name",
                "displayValue": "last_name"
              },
              {
                "value": "name",
                "displayValue": "name"
              },
              {
                "value": "external_id",
                "displayValue": "external_id"
              },
              {
                "value": "user_id",
                "displayValue": "user_id"
              },
              {
                "value": "anonymous_id",
                "displayValue": "anonymous_id"
              },
              {
                "value": "city",
                "displayValue": "city"
              },
              {
                "value": "state",
                "displayValue": "state"
              },
              {
                "value": "postal_code",
                "displayValue": "postal_code"
              },
              {
                "value": "country",
                "displayValue": "country"
              }
            ]
          },
          {
            "defaultValue": "",
            "displayName": "Value",
            "name": "value",
            "type": "TEXT"
          }
        ],
        "newRowButtonText": "Add field"
      },
      {
        "type": "SIMPLE_TABLE",
        "name": "additionalParamsList",
        "displayName": "Additional Parameters",
        "help": "Optional extra key/value pairs sent with the event.",
        "simpleTableColumns": [
          {
            "defaultValue": "",
            "displayName": "Name",
            "name": "name",
            "type": "TEXT"
          },
          {
            "defaultValue": "",
            "displayName": "Value",
            "name": "value",
            "type": "TEXT"
          }
        ],
        "newRowButtonText": "Add parameter"
      }
    ]
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

var injectScript = require('injectScript');
var copyFromWindow = require('copyFromWindow');
var setInWindow = require('setInWindow');
var createQueue = require('createQueue');
var callInWindow = require('callInWindow');
var getTimestampMillis = require('getTimestampMillis');
var getContainerVersion = require('getContainerVersion');
var makeString = require('makeString');
var makeNumber = require('makeNumber');
var logToConsole = require('logToConsole');

var cv = getContainerVersion();
var isDebug = cv && (cv.debugMode || cv.previewMode);

var PIXEL_ORIGIN = 'https://t.whop.tw';

function isPresent(v) {
  return v !== undefined && v !== null && v !== '';
}

var scopes = [];
var rawIds = makeString(data.accountIds || '').split(',');
for (var i = 0; i < rawIds.length; i++) {
  var id = rawIds[i].trim();
  if (id) scopes.push(id);
}
if (!scopes.length) {
  if (isDebug) logToConsole('Whop Pixel: no business ID configured');
  return data.gtmOnFailure();
}

var eventName;
if (data.eventType === 'standard') {
  eventName = data.standardEventName;
} else if (data.eventType === 'custom') {
  eventName = makeString(data.customEventName || '');
} else {
  eventName = 'page';
}
if (!isPresent(eventName)) {
  if (isDebug) logToConsole('Whop Pixel: missing event name');
  return data.gtmOnFailure();
}

var params = {};
var hasParams = false;
if (isPresent(data.eventValue)) {
  params.value = makeNumber(data.eventValue);
  hasParams = true;
}
if (isPresent(data.eventCurrency)) {
  params.currency = makeString(data.eventCurrency);
  hasParams = true;
}
function addRows(table) {
  if (!table) return;
  for (var r = 0; r < table.length; r++) {
    var row = table[r];
    if (row.name && isPresent(row.value)) {
      params[row.name] = row.value;
      hasParams = true;
    }
  }
}
addRows(data.customerDataList);
addRows(data.additionalParamsList);

// copyFromWindow throws on functions, so whop.track is never read directly:
// loaded-state lives in an own flag, stub presence is detected via whop.t (a number),
// and the real API is only ever invoked through callInWindow.
var alreadyLoaded = copyFromWindow('_whop_gtm_loaded');

if (alreadyLoaded) {
  if (scopes.length === 1) {
    callInWindow('whop.setScope', scopes[0]);
  } else if (scopes.length === 2) {
    callInWindow('whop.setScope', scopes[0], scopes[1]);
  } else {
    callInWindow('whop.setScope', scopes[0], scopes[1], scopes[2]);
    if (isDebug && scopes.length > 3) logToConsole('Whop Pixel: max 3 business IDs supported per tag, extra IDs ignored');
  }
  if (hasParams) {
    callInWindow('whop.track', eventName, params);
  } else {
    callInWindow('whop.track', eventName);
  }
  if (isDebug) logToConsole('Whop Pixel:', eventName, hasParams ? params : '(no params)');
  data.gtmOnSuccess();
} else {
  if (!isPresent(copyFromWindow('whop.t'))) {
    setInWindow('whop', { q: [], t: getTimestampMillis(), s: [], o: PIXEL_ORIGIN }, false);
  }
  var pushToQueue = createQueue('whop.q');
  setInWindow('whop.s', scopes, true);
  pushToQueue([getTimestampMillis(), 'setScope'].concat(scopes));
  var entry = [getTimestampMillis(), eventName];
  if (hasParams) entry.push(params);
  pushToQueue(entry);
  if (isDebug) logToConsole('Whop Pixel:', eventName, hasParams ? params : '(no params)');
  injectScript(PIXEL_ORIGIN + '/s.js', function () {
    setInWindow('_whop_gtm_loaded', true, true);
    data.gtmOnSuccess();
  }, data.gtmOnFailure, 'whopPixel');
}


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "inject_script",
        "versionId": "1"
      },
      "param": [
        {
          "key": "urls",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "https://t.whop.tw/*"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_globals",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keys",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "whop"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "whop.q"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "whop.t"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "whop.s"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "whop.o"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "whop.track"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "whop.setScope"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "_whop_gtm_loaded"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "read_container_data",
        "versionId": "1"
      },
      "param": []
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []
