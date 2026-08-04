# Whop GTM Templates

Google Tag Manager templates for [Whop](https://whop.com) conversion tracking: a web container tag for the Whop pixel and a server container tag for the [Whop Events API](https://docs.whop.com/api-reference/beta/events/create-event).

Developed by [Kristian Krogh Bang](https://kristiankroghbang.com) and [Claude](https://claude.ai).

## The problem

Whop records every checkout view, purchase, subscription, and trial on its own platform automatically. But the events that happen on your own funnel - leads, bookings, registrations, purchases outside Whop checkout - are invisible to Whop's attribution unless you send them yourself.

Whop ships a pixel snippet and a server-side Events API for exactly this, but no GTM templates. In practice that means custom HTML tags in the web container and hand-rolled API calls on the server. These two templates replace both.

## The solution

```
Browser  --Whop Pixel tag-->  t.whop.tw            (page views, light engagement)
Browser  --GA4 / Stape Data Tag-->  sGTM  --Whop Events API tag-->  api.whop.com   (conversions)
```

| File | Container | Description |
|------|-----------|-------------|
| `whop-pixel-web-tag.tpl` | Web | Loads the Whop pixel and tracks page views, standard and custom events |
| `whop-events-api-tag.tpl` | Server | Sends events to the Whop Events API with automatic data mapping |

## Web tag

Sandboxed replacement for the official pixel snippet. It recreates the snippet's stub queue, loads `t.whop.tw/s.js` once (across any number of tag instances), and calls the pixel API directly on later fires.

- **Page view**, **standard event** (all 7 Whop standard events in a dropdown), or **custom event**
- Optional value, currency, customer data (email, phone, name, external_id, address fields) and free-form parameters
- Multi-business support: comma-separated `biz_` IDs (max 3 per tag)
- Permissions locked to `t.whop.tw` script injection and `whop.*` globals

### Setup

1. In your GTM Web Container: **Templates** > **Tag Templates** > **New** > three-dot menu > **Import** > `whop-pixel-web-tag.tpl`
2. Create a tag from the template. Set your **Business ID** (`biz_...`, found in your Whop dashboard URL)
3. Event = **Page view**, trigger = **All Pages** (add History Change for SPAs)
4. Add more tag instances for standard/custom events as needed
5. Remove any hardcoded Whop snippet so page views are not tracked twice

Verify at `whop.com/dashboard/{biz_id}/pixel` - status turns green once data flows.

## Server tag

Sends events to `POST https://api.whop.com/api/v1/events` with Bearer auth. Reads the standard GA4 client event model and the [Stape](https://stape.io) Data Tag / Data Client model, including cookies forwarded in the Data Tag's `common_cookie` object.

Auto-populated from incoming event data (override tables for everything):

| Whop field | Source |
|------------|--------|
| `event_name` | Incoming event name; GA4 names auto-mapped (`page_view`/`view_item` > `view_content`, `generate_lead` > `lead`, `sign_up` > `complete_registration`), unknown names sent as custom events |
| `event_id` | `event_id` or `unique_event_id` (also sent as `Idempotency-Key`) |
| `value`, `currency` | `value`, `currency` (currency lowercased per Whop spec) |
| `url`, `referrer_url`, `title` | `page_location`, `page_referrer`, `page_title` |
| `user.email`, `user.phone`, names, address | `user_data` in both GA4 (`email_address`, `address.*`) and Stape (`email`, flat fields) shapes; hashed emails skipped |
| `user.anonymous_id` | The Whop pixel's `_wuid` cookie (falls back to `_wuid_link`, then GA4 `client_id`) - stitches server events to pixel sessions |
| `user.external_id` | `user_id` |
| `context` click IDs | `gclid`, `gbraid`, `wbraid`, `fbclid`, `ttclid`, `msclkid`, `li_fat_id`, `rdt_cid`, `sccid`, `twclid` from event data, `common_cookie`, or the page URL; `gclid` also parsed from `_gcl_aw` |
| `context.fbp` / `fbc` / `ttp` | Cookies or event data; `fbc` constructed from `fbclid` when the cookie is missing |
| `context.ga` | GA4 `client_id` (or parsed from the `_ga` cookie) |
| `context` UTMs | All six `utm_*` parameters from event data or page URL |
| `context.ip_address`, `user_agent`, `language`, `screen_resolution` | `ip_override`, `user_agent`, `language`, `screen_resolution` |

### Setup

1. Create a Whop API key with the `event:create` scope in your Whop dashboard
2. In your GTM Server Container: **Templates** > **Tag Templates** > **New** > three-dot menu > **Import** > `whop-events-api-tag.tpl`
3. Create a tag: set **API Key** and **Account ID** (your `biz_...` ID)
4. Leave Event Name on **Inherit** and fire the tag on your conversion triggers (lead, sign_up, purchase, ...)
5. Pass a stable event ID from the browser (e.g. a Stape unique event ID variable) so retries deduplicate

## Limitations

- **Don't send Whop checkout purchases.** Whop records those server-side automatically; only send events Whop cannot see (leads, bookings, purchases on your own infrastructure). This is [Whop's own guidance](https://docs.whop.com/developer/guides/pixel).
- **Pixel vs. server dedupe is undocumented.** The pixel generates its own event IDs, so the same action tracked in both containers can double-count. Split by event type: pixel for page views, server tag for conversions.
- **Custom event names**: max 35 characters; names under ~34 characters forward to Meta as custom conversions. Keep them short and stable, and reuse a small set.
- **`_wuid` stitching** requires the sGTM container on a subdomain of the site (standard first-party setup) so the pixel's cookie reaches it.
- The Events API is part of Whop's beta/experimental API surface and may change.

## Resources

- [Install the Whop pixel](https://docs.whop.com/developer/guides/pixel)
- [Whop Events API reference](https://docs.whop.com/api-reference/beta/events/create-event)
- [sGTM tag templates guide](https://developers.google.com/tag-platform/tag-manager/server-side/api)

## License

Apache 2.0 - see [LICENSE](LICENSE).
