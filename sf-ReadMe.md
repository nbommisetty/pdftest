# FSC - Mosaic Platform - Onboarding Handoff Integration

## API Reference

### 1. Server-to-Server Stash (Phase 1)
Secure, backend server-to-server call to stash the onboarding context into Mosaic's Redis cache before initiating any browser navigation for the banker.

* **URL:** `/mosaicAssisted/api/handoff`
* **Method:** `POST`
* **Content-Type:** `application/json`

#### Example Request
```text
POST https://[mosaic-domain]/mosaicAssisted/api/handoff
```

#### Request Body
```json
{
  "opportunityId": "123456789",
  "relationshipId": "987654321"
}
```

#### Success Response
* **Code:** `200 OK`
* **Content:**
```json
{
  "handoffToken": "xyz123-abc-789"
}
```

#### Critical Constraints
* **Configurable TTL:** The data associated with the `handoffToken` is stashed with a configurable Time-To-Live (During POC - we can go with a big window, say 15 minutes. But in Prod, we would limit this to 60 seconds). Phase 2 must be initiated by the client browser immediately after this token is received.

---

### 2. Browser Redirect & Authentication (Phase 2)
Following a successful response from Phase 1, the Salesforce UI must immediately redirect the PCS banker's browser to this endpoint.

* **URL:** `/mosaicAssisted/onboard`
* **Method:** `GET`

#### URL Parameters
* `token=[string]` (Required) - The `handoffToken` received from the `/mosaicAssisted/api/handoff` response.

#### Example Request
```text
GET https://[mosaic-domain]/mosaicAssisted/onboard?token=xyz123-abc-789
```

#### Execution Flow (Internal Mosaic Behavior)
1. Mosaic intercepts the request and encodes the `handoffToken` into the standard OAuth `state` parameter.
2. Mosaic triggers an HTTP 302 redirect, sending the banker to Okta to authenticate.
3. After successful Okta authentication, the browser is redirected back to Mosaic's `/callback` route with the encoded `state`.
4. Mosaic decodes the state to extract the `handoffToken`, connects to the Redis cache, and fetches the original context (`opportunityId` and/or `relationshipId`).
5. The token is strictly one-time use.
6. The Mosaic application renders the onboarding user interface, fully hydrated with the Opportunity context and the banker's authenticated session.