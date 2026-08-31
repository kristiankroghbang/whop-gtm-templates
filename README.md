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
- Optional **event ID** for deduplication, value, currency, customer data (email, phone, name, external_id, address fields) and free-form parameters
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
| `user.anonymous_id` | The Whop pixel's `_wuid` cookie, read from event data, the Stape Data Tag's `common_cookie`, or the request cookies (falls back to `_wuid_link`, then GA4 `client_id`) - stitches server events to pixel sessions |
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
5. Pass a stable event ID from the browser (e.g. a Stape unique event ID variable) so retries deduplicate - see [Deduplication](#deduplication)

## Deduplication

Whop counts each `event_name` and `event_id` pair once. A retry, a page refresh, or the same conversion sent from both containers collapses into a single event, so the browser tag's **Event ID** field and the server tag's `event_id` should carry the same value for the same action.

Three rules follow from the key being the pair, not the ID alone:

- **The ID identifies one action, not one event type.** Send `lead` as the ID for every lead and Whop treats hundreds of leads as one event. Use a value your system already has: an order number, lead ID, or form submission ID.
- **The same ID under two different event names does not deduplicate.** Those are two distinct pairs and both are counted.
- **Omitting it means no deduplication at all.** Whop assigns an ID that is new on every request, so repeat sends of the same action can never be matched.

A value generated at fire time is new on every fire and stops nothing.

## Limitations

- **Don't send Whop checkout purchases.** Whop records those server-side automatically; only send events Whop cannot see (leads, bookings, purchases on your own infrastructure). This is [Whop's own guidance](https://docs.whop.com/developer/guides/pixel).
- **Never name an event `purchase`.** Whop generates its own `purchase` event from payment data and forwards it to Meta as the conversion your ads optimize toward. Your own `purchase` does not merge into it - it lands beside it as a separate custom event under a near-identical name, and only one of the two is real revenue. Whop support confirms this and asks for a clearly different name. The full set Whop reserves for its own conversion types is `purchase`, `lead`, `schedule`, `submit_application`, `contact`, `complete_registration`, `view_content`, `add_to_cart`, `custom` and `messaging_conversation`. For a purchase on your own infrastructure, use something like `order_completed`.
- **Custom event names**: max 35 characters; names under ~34 characters forward to Meta as custom conversions. Keep them short and stable, and reuse a small set.
- **`_wuid` stitching** requires the sGTM container running same origin with the site (standard first-party setup) so the pixel's cookie reaches it.
- The Events API is part of Whop's beta/experimental API surface and may change.

## Resources

- [Install the Whop pixel](https://docs.whop.com/developer/guides/pixel)
- [Whop Events API reference](https://docs.whop.com/api-reference/beta/events/create-event)
- [sGTM tag templates guide](https://developers.google.com/tag-platform/tag-manager/server-side/api)

## License

Apache 2.0 - see [LICENSE](LICENSE).
