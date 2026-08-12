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
  "displayName": "Whop Events API",
  "description": "Sends conversion events to the Whop Events API. Auto-maps GA4 and Stape Data Client events, populates user data, click IDs and UTMs, with per-field overrides. Developed by Kristian Krogh Bang.",
  "containerContexts": [
    "SERVER"
  ],
  "brand": {
    "id": "brand_dummy",
    "displayName": "Kristian Krogh Bang",
    "thumbnail": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIAAAACACAYAAADDPmHLAAAELklEQVR42u2dQWoUQRSGy0yicYwL0QiCEBBEBRExLkSQkL038AB6Ak/gAQQv4NozuBIP4cpTuHBX9mscSUTp6unuqr/qfQMPQhKY7ve+rnpfT01XCAu/1ut1JLaPUMuLYjkEg0I4hYGkOwWBJDsGgcQ6hoCEOoaARDqGgAQ6hoDEOYaAhDmGgEQ5h4AkOQaABDmHgOQ4BoDEOIeApAAAifEKAAlxDgHJAAASAgAEABAAQDgDgEQ4h4AkAACJAAACAAgAIACAAABifXgQL74+irsfHvRhP9vvAMBB7L84jKsvxzHE03Nhv7O/AUDjV/6/in8WgtZGAgA4EzbU/6/4m+inAwBoc27e/fhwEAB735Z6hcDc/DtuHMSdb8+SAWilV6gCgMv3rsWdr08XnZsvvbw1WPx+CnhzNNgr2LHaMQPAHHH1Slx9erT43Lz37u4wAD9O4v7j60m9gh2zHTsATIy99/eTrsxzc/MWsfr8ZLio3f/0vUL3XinHZMcOAFO68rd3khI9FQC7qu3qHixoN0qMAaAfmbpzAIBt5uRXt2P4eZKe6AlTgM3rKe9hfUKqLv6J7hzsXABgzBV5ejNe+P48OclTm8AU/TNDMFNIuWH0d9i52DkBwAwd/+zJTdW/DpIpkKqaQaix459zeB2lfxOnKUUzCDV2/HM2WGP0b2qjqmgGocaOf85EjtE/JXCbAqDUUDpW/5SmrmYAKNlMjdU/qea1BQBKJ220/gnDXB8ApYfNLfVPdTqrDoDSjdMU/VNtaKsBQCFBU/VPHXBZAFSGyDn0rwUzCF46/kX0rwEzCF46/qX0r3YzCC46/oX1r2YzCB46/hz6V6sZBA8dfy79q9EMgoeOP6f+1WYGofWOP7v+VWYGywAgumQql/6pLXnLDoDqosmc+qe06DU7AKrLpnPrn8qydwAoqH8uAVCcAkrqn7spQLEJLKp/3ppARQ0srX++NFDsRpCK/rm6EaR0K1hF/9zdClY5cQX9c/thUPGhT0D/3H8cXLL5Ka1/LAgpnIyS+seSMIHhsJj+sSi0fENUUv9YFi6QoFL6xxdDRIbIEvrHV8NUmqQC+seXQ4WSllv/+Hq42LCZVf94QIRe45RT/3hEjJgZ5NQ/HhIlaAa59I/HxImaQQ7940GRqkumcugfj4rVXTSZQ/94WLTwsukc+sfj4gXNYANADv1jwwhBM7BhOZf+sWWMmBlsmsBsn/6xaVQBM0jYpi1laJ7r0z+2jSsRAxs1pgAw6+JPNo4UswaHW78CwIi5ucXNnwGg0bkZAJzPzQBAAAABAAQAEABAAAABAMQSANiLRDguPgAAAAAAAMkAAAIACKcAAIHz4gMAAACAdwCAwHnxAQAAgMB78QEAAIDAe/GBgOIDAcUHAooPBBQfCCg+EFB8QKDwgEDhgYGiA0aDhf4FNBjxPUEbCkIAAAAASUVORK5CYII="
  },
  "categories": [
    "CONVERSIONS",
    "ANALYTICS"
  ],
  "termsOfServiceAccepted": true
}

___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "apiKey",
    "displayName": "API Key",
    "simpleValueType": true,
    "help": "Whop API key with the event:create scope. Sent as Authorization: Bearer.",
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ]
  },
  {
    "type": "TEXT",
    "name": "accountId",
    "displayName": "Account ID",
    "simpleValueType": true,
    "help": "Your Whop business ID (biz_...). Found in the Whop dashboard settings.",
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ]
  },
  {
    "type": "RADIO",
    "name": "eventNameSetting",
    "displayName": "Event Name",
    "simpleValueType": true,
    "defaultValue": "inherit",
    "radioItems": [
      {
        "value": "inherit",
        "displayValue": "Inherit from incoming event",
        "help": "Uses the incoming event name. GA4 names are auto-mapped to Whop standard events (page_view/view_item → view_content, generate_lead → lead, sign_up → complete_registration, add_to_cart → add_to_cart). Names matching a Whop standard event pass through unchanged. Anything else is sent as a custom event under its own name (e.g. purchase arrives in Whop as a custom event named purchase). Keep custom names short and stable - names under ~34 characters forward to Meta as custom conversions."
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
                "displayValue": "lead"
              },
              {
                "value": "submit_application",
                "displayValue": "submit_application"
              },
              {
                "value": "contact",
                "displayValue": "contact"
              },
              {
                "value": "complete_registration",
                "displayValue": "complete_registration"
              },
              {
                "value": "schedule",
                "displayValue": "schedule"
              },
              {
                "value": "view_content",
                "displayValue": "view_content"
              },
              {
                "value": "add_to_cart",
                "displayValue": "add_to_cart"
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
            "help": "Sent directly as the event name. Max 35 characters - keep names short, stable and reused from a small set; names under ~34 characters forward to Meta as custom conversions."
          }
        ]
      }
    ]
  },
  {
    "type": "CHECKBOX",
    "name": "readCookies",
    "checkboxText": "Read browser cookies (_fbp, _fbc, _ttp, _ga, _wuid)",
    "simpleValueType": true,
    "defaultValue": true,
    "help": "Populates context.fbp, context.fbc, context.ttp, context.ga, gclid (from _gcl_aw) and user.anonymous_id (the Whop pixel's _wuid visitor cookie, falling back to the GA4 client_id) from the incoming request cookies when not present in event data. Cookies forwarded by the Stape Data Tag inside common_cookie are always read, regardless of this setting."
  },
  {
    "type": "CHECKBOX",
    "name": "useSandbox",
    "checkboxText": "Use sandbox endpoint",
    "simpleValueType": true,
    "defaultValue": false,
    "help": "Sends events to sandbox-api.whop.com instead of api.whop.com."
  },
  {
    "type": "GROUP",
    "name": "overridesGroup",
    "displayName": "Data Overrides",
    "groupStyle": "ZIPPY_CLOSED",
    "subParams": [
      {
        "type": "SIMPLE_TABLE",
        "name": "eventDataList",
        "displayName": "Event Parameters",
        "help": "Overrides or adds top-level event fields. Table values win over auto-detected values. Whop only requires account_id and event_name (set above) - everything here is optional. Recommended: event_id for deduplication (use the same ID as the browser pixel so duplicate events are dropped), and value + currency on conversion events.",
        "simpleTableColumns": [
          {
            "defaultValue": "",
            "displayName": "Field",
            "name": "name",
            "type": "SELECT",
            "selectItems": [
              {
                "value": "event_id",
                "displayValue": "event_id"
              },
              {
                "value": "value",
                "displayValue": "value"
              },
              {
                "value": "currency",
                "displayValue": "currency"
              },
              {
                "value": "product_id",
                "displayValue": "product_id"
              },
              {
                "value": "plan_id",
                "displayValue": "plan_id"
              },
              {
                "value": "url",
                "displayValue": "url"
              },
              {
                "value": "referrer_url",
                "displayValue": "referrer_url"
              },
              {
                "value": "title",
                "displayValue": "title"
              },
              {
                "value": "action_source",
                "displayValue": "action_source"
              },
              {
                "value": "event_time",
                "displayValue": "event_time"
              },
              {
                "value": "duration",
                "displayValue": "duration"
              },
              {
                "value": "source",
                "displayValue": "source"
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
        "name": "userDataList",
        "displayName": "User Data",
        "help": "Overrides or adds fields on the user object. Table values win over auto-detected values. All fields are optional, but Whop recommends attaching as much customer data as you have so events attribute correctly - email is the strongest identifier, followed by user_id/external_id, phone and name fields. Send plain values, not hashed.",
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
                "value": "username",
                "displayValue": "username"
              },
              {
                "value": "user_id",
                "displayValue": "user_id"
              },
              {
                "value": "member_id",
                "displayValue": "member_id"
              },
              {
                "value": "membership_id",
                "displayValue": "membership_id"
              },
              {
                "value": "external_id",
                "displayValue": "external_id"
              },
              {
                "value": "anonymous_id",
                "displayValue": "anonymous_id"
              },
              {
                "value": "linked_anonymous_id",
                "displayValue": "linked_anonymous_id"
              },
              {
                "value": "linked_wuid",
                "displayValue": "linked_wuid"
              },
              {
                "value": "birthdate",
                "displayValue": "birthdate"
              },
              {
                "value": "gender",
                "displayValue": "gender"
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
        "name": "contextDataList",
        "displayName": "Context / Attribution Data",
        "help": "Overrides or adds fields on the context object. Table values win over auto-detected values. All fields are optional. Recommended for ad attribution: platform click IDs (gclid, fbclid, ttclid, ...), fbp/fbc, utm parameters, plus ip_address and user_agent.",
        "simpleTableColumns": [
          {
            "defaultValue": "",
            "displayName": "Field",
            "name": "name",
            "type": "SELECT",
            "selectItems": [
              {
                "value": "gclid",
                "displayValue": "gclid"
              },
              {
                "value": "gbraid",
                "displayValue": "gbraid"
              },
              {
                "value": "wbraid",
                "displayValue": "wbraid"
              },
              {
                "value": "fbclid",
                "displayValue": "fbclid"
              },
              {
                "value": "fbp",
                "displayValue": "fbp"
              },
              {
                "value": "fbc",
                "displayValue": "fbc"
              },
              {
                "value": "ttclid",
                "displayValue": "ttclid"
              },
              {
                "value": "ttp",
                "displayValue": "ttp"
              },
              {
                "value": "msclkid",
                "displayValue": "msclkid"
              },
              {
                "value": "li_fat_id",
                "displayValue": "li_fat_id"
              },
              {
                "value": "rdt_cid",
                "displayValue": "rdt_cid"
              },
              {
                "value": "sccid",
                "displayValue": "sccid"
              },
              {
                "value": "twclid",
                "displayValue": "twclid"
              },
              {
                "value": "ig_sid",
                "displayValue": "ig_sid"
              },
              {
                "value": "ga",
                "displayValue": "ga"
              },
              {
                "value": "ad_campaign_id",
                "displayValue": "ad_campaign_id"
              },
              {
                "value": "ad_set_id",
                "displayValue": "ad_set_id"
              },
              {
                "value": "ad_id",
                "displayValue": "ad_id"
              },
              {
                "value": "utm_source",
                "displayValue": "utm_source"
              },
              {
                "value": "utm_medium",
                "displayValue": "utm_medium"
              },
              {
                "value": "utm_campaign",
                "displayValue": "utm_campaign"
              },
              {
                "value": "utm_term",
                "displayValue": "utm_term"
              },
              {
                "value": "utm_content",
                "displayValue": "utm_content"
              },
              {
                "value": "utm_id",
                "displayValue": "utm_id"
              },
              {
                "value": "ip_address",
                "displayValue": "ip_address"
              },
              {
                "value": "user_agent",
                "displayValue": "user_agent"
              },
              {
                "value": "language",
                "displayValue": "language"
              },
              {
                "value": "timezone",
                "displayValue": "timezone"
              },
              {
                "value": "screen_resolution",
                "displayValue": "screen_resolution"
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
      }
    ]
  }
]


___SANDBOXED_JS_FOR_SERVER___

var getAllEventData = require('getAllEventData');
var sendHttpRequest = require('sendHttpRequest');
var getCookieValues = require('getCookieValues');
var getContainerVersion = require('getContainerVersion');
var getTimestampMillis = require('getTimestampMillis');
var parseUrl = require('parseUrl');
var logToConsole = require('logToConsole');
var JSON = require('JSON');
var makeString = require('makeString');
var makeNumber = require('makeNumber');
var getType = require('getType');

var eventData = getAllEventData();
var cv = getContainerVersion();
var isDebug = cv && (cv.debugMode || cv.previewMode);

if (!data.apiKey || !data.accountId) {
  if (isDebug) logToConsole('Whop Events API: missing API key or account ID');
  return data.gtmOnFailure();
}

var STANDARD_EVENTS = {
  lead: true,
  submit_application: true,
  contact: true,
  complete_registration: true,
  schedule: true,
  view_content: true,
  add_to_cart: true
};

var GA4_MAP = {
  page_view: 'view_content',
  view_item: 'view_content',
  generate_lead: 'lead',
  sign_up: 'complete_registration'
};

function isPresent(v) {
  return v !== undefined && v !== null && v !== '';
}

function firstOf(candidates) {
  for (var i = 0; i < candidates.length; i++) {
    if (isPresent(candidates[i])) return candidates[i];
  }
  return undefined;
}

function setIf(target, key, value) {
  if (isPresent(value)) target[key] = value;
}

function truncate35(s) {
  s = makeString(s);
  return s.length > 35 ? s.substring(0, 35) : s;
}

function resolveEventName() {
  if (data.eventNameSetting === 'standard') {
    return data.standardEventName;
  }
  if (data.eventNameSetting === 'custom') {
    return truncate35(data.customEventName);
  }
  var incoming = makeString(eventData.event_name || '');
  if (STANDARD_EVENTS[incoming]) return incoming;
  if (GA4_MAP[incoming]) return GA4_MAP[incoming];
  return truncate35(incoming || 'unknown');
}

var body = {
  account_id: data.accountId,
  event_name: resolveEventName(),
  action_source: 'website'
};

setIf(body, 'event_id', firstOf([eventData.event_id, eventData.unique_event_id]));
setIf(body, 'url', eventData.page_location);
setIf(body, 'referrer_url', eventData.page_referrer);
setIf(body, 'title', eventData.page_title);

if (isPresent(eventData.value)) body.value = makeNumber(eventData.value);
if (isPresent(eventData.currency)) body.currency = makeString(eventData.currency).toLowerCase();

// user object: GA4 client nests PII under user_data (email_address/phone_number/address),
// Stape Data Tag uses user_data with flat email/phone/first_name keys - check both.
var ud = eventData.user_data || {};
var addr = ud.address;
if (getType(addr) === 'array') addr = addr[0];
addr = addr || {};

var user = {};
var email = firstOf([ud.email_address, ud.email, eventData.email]);
if (isPresent(email) && makeString(email).indexOf('@') === -1) email = undefined;
setIf(user, 'email', email);
setIf(user, 'phone', firstOf([ud.phone_number, ud.phone, eventData.phone]));
setIf(user, 'first_name', firstOf([ud.first_name, addr.first_name, eventData.first_name]));
setIf(user, 'last_name', firstOf([ud.last_name, addr.last_name, eventData.last_name]));
setIf(user, 'city', firstOf([ud.city, addr.city]));
setIf(user, 'state', firstOf([ud.state, ud.region, addr.region]));
setIf(user, 'postal_code', firstOf([ud.postal_code, addr.postal_code]));
setIf(user, 'country', firstOf([ud.country, addr.country]));
setIf(user, 'external_id', eventData.user_id);
// _wuid is the Whop browser pixel's own visitor ID - the strongest anonymous identifier.
// GA4 client_id is only a fallback when the pixel cookie is unavailable.
var wuid = firstOf([eventData._wuid, data.readCookies ? getCookieValues('_wuid')[0] : undefined, data.readCookies ? getCookieValues('_wuid_link')[0] : undefined]);
setIf(user, 'anonymous_id', firstOf([wuid, eventData.client_id]));

var context = {};
setIf(context, 'ip_address', eventData.ip_override);
setIf(context, 'user_agent', eventData.user_agent);
setIf(context, 'language', eventData.language);
setIf(context, 'screen_resolution', eventData.screen_resolution);

var query = {};
if (isPresent(eventData.page_location)) {
  var parsedUrl = parseUrl(eventData.page_location);
  if (parsedUrl && parsedUrl.searchParams) query = parsedUrl.searchParams;
}

// Stape Data Tag forwards browser cookies nested under common_cookie
var commonCookie = eventData.common_cookie || {};

var CLICK_ID_KEYS = ['gclid', 'gbraid', 'wbraid', 'fbclid', 'ttclid', 'msclkid', 'li_fat_id', 'rdt_cid', 'sccid', 'twclid'];
for (var c = 0; c < CLICK_ID_KEYS.length; c++) {
  var ck = CLICK_ID_KEYS[c];
  setIf(context, ck, firstOf([eventData[ck], commonCookie[ck], query[ck]]));
}

var UTM_KEYS = ['utm_source', 'utm_medium', 'utm_campaign', 'utm_term', 'utm_content', 'utm_id'];
for (var u = 0; u < UTM_KEYS.length; u++) {
  var uk = UTM_KEYS[u];
  setIf(context, uk, firstOf([eventData[uk], query[uk]]));
}

setIf(context, 'fbp', firstOf([eventData._fbp, commonCookie._fbp]));
setIf(context, 'fbc', firstOf([eventData._fbc, commonCookie._fbc]));
setIf(context, 'ttp', firstOf([eventData._ttp, commonCookie._ttp]));
if (data.readCookies) {
  setIf(context, 'fbp', firstOf([context.fbp, getCookieValues('_fbp')[0]]));
  setIf(context, 'fbc', firstOf([context.fbc, getCookieValues('_fbc')[0]]));
  setIf(context, 'ttp', firstOf([context.ttp, getCookieValues('_ttp')[0]]));
}
// context.ga expects the GA client ID, not the raw _ga cookie (GA1.1.<clientId>)
setIf(context, 'ga', eventData.client_id);
if (!isPresent(context.ga) && data.readCookies) {
  var gaCookie = getCookieValues('_ga')[0];
  if (isPresent(gaCookie)) {
    var gaParts = makeString(gaCookie).split('.');
    context.ga = gaParts.length >= 4 ? gaParts.slice(2).join('.') : gaCookie;
  }
}
if (!isPresent(context.fbc) && isPresent(context.fbclid)) {
  context.fbc = 'fb.1.' + getTimestampMillis() + '.' + context.fbclid;
}
// _gcl_aw format is GCL.<timestamp>.<gclid>
if (!isPresent(context.gclid)) {
  var gclAw = firstOf([commonCookie._gcl_aw, commonCookie.FPGCLAW, data.readCookies ? getCookieValues('_gcl_aw')[0] : undefined]);
  if (isPresent(gclAw)) {
    var gclParts = makeString(gclAw).split('.');
    if (gclParts.length >= 3) context.gclid = gclParts.slice(2).join('.');
  }
}

function applyOverrides(table, target) {
  if (!table) return;
  for (var i = 0; i < table.length; i++) {
    var row = table[i];
    if (row.name && isPresent(row.value)) target[row.name] = row.value;
  }
}

applyOverrides(data.eventDataList, body);
applyOverrides(data.userDataList, user);
applyOverrides(data.contextDataList, context);

if (isPresent(body.value)) body.value = makeNumber(body.value);
if (isPresent(body.duration)) body.duration = makeNumber(body.duration);
if (isPresent(body.currency)) body.currency = makeString(body.currency).toLowerCase();

var hasKeys = false;
var USER_KEYS = ['email', 'phone', 'first_name', 'last_name', 'name', 'username', 'user_id', 'member_id', 'membership_id', 'external_id', 'anonymous_id', 'linked_anonymous_id', 'linked_wuid', 'birthdate', 'gender', 'city', 'state', 'postal_code', 'country'];
for (var uu = 0; uu < USER_KEYS.length; uu++) {
  if (isPresent(user[USER_KEYS[uu]])) hasKeys = true;
}
if (hasKeys) body.user = user;

var CONTEXT_KEYS = ['ip_address', 'user_agent', 'language', 'timezone', 'screen_resolution', 'fbp', 'fbc', 'ttp', 'ga', 'ig_sid', 'ad_campaign_id', 'ad_set_id', 'ad_id'].concat(CLICK_ID_KEYS).concat(UTM_KEYS);
var hasContext = false;
for (var cc = 0; cc < CONTEXT_KEYS.length; cc++) {
  if (isPresent(context[CONTEXT_KEYS[cc]])) hasContext = true;
}
if (hasContext) body.context = context;

var endpoint = data.useSandbox ? 'https://sandbox-api.whop.com/api/v1/events' : 'https://api.whop.com/api/v1/events';

var headers = {
  'Content-Type': 'application/json',
  Authorization: 'Bearer ' + data.apiKey
};
if (isPresent(body.event_id)) headers['Idempotency-Key'] = makeString(body.event_id);

if (isDebug) logToConsole('Whop Events API request', endpoint, JSON.stringify(body));

sendHttpRequest(
  endpoint,
  function (statusCode, respHeaders, respBody) {
    if (isDebug) logToConsole('Whop Events API response', statusCode, respBody);
    if (statusCode >= 200 && statusCode < 300) {
      data.gtmOnSuccess();
    } else {
      data.gtmOnFailure();
    }
  },
  { headers: headers, method: 'POST', timeout: 5000 },
  JSON.stringify(body)
);


___SERVER_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "read_event_data",
        "versionId": "1"
      },
      "param": [
        {
          "key": "eventDataAccess",
          "value": {
            "type": 1,
            "string": "any"
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
        "publicId": "get_cookies",
        "versionId": "1"
      },
      "param": [
        {
          "key": "cookieAccess",
          "value": {
            "type": 1,
            "string": "any"
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
        "publicId": "send_http",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedUrls",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "urls",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "https://api.whop.com/*"
              },
              {
                "type": 1,
                "string": "https://sandbox-api.whop.com/*"
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
