# 🔑 Square Setup Guide - Getting Your Access Token

## Your Square Information

**Location ID**: `LC95Y4243HZKF`  
**Business Name**: Luis Rojo's Masonry LLC  
**Business Email**: luisrojosmasonry@gmail.com  
**Location**: Tucson, AZ

## Step-by-Step: Get Your Square Access Token

### 1. Go to Square Developer Dashboard

Visit: [https://developer.squareup.com/apps](https://developer.squareup.com/apps)

### 2. Sign In

- Use your Square account credentials
- Email: luisrojosmasonry@gmail.com
- Same password you use for Square POS

### 3. Create a New Application

- Click **"Create App"** or **"New Application"**
- Name it: **"Arizona Contractor Webs"**
- Click **"Create Application"**

### 4. Get Your Credentials

Once created, you'll see two tabs:

#### For Testing (Sandbox):
1. Click **"Credentials"** tab
2. Find **"Sandbox Access Token"**
3. Click **"Show"** to reveal the token
4. Copy the entire token (starts with `EAAAE...`)

#### For Production (Live Payments):
1. Click **"Credentials"** tab
2. Find **"Production Access Token"**
3. Click **"Show"** to reveal the token
4. Copy the entire token

### 5. Add to Your .env File

Open your `.env` file and update:

```env
# For testing/development:
SQUARE_ACCESS_TOKEN=EAAAEYourSandboxTokenHere
SQUARE_LOCATION_ID=LC95Y4243HZKF
SQUARE_ENVIRONMENT=sandbox

# For production (when ready to go live):
# SQUARE_ACCESS_TOKEN=EAAAEYourProductionTokenHere
# SQUARE_LOCATION_ID=LC95Y4243HZKF
# SQUARE_ENVIRONMENT=production
```

## Setting Up Webhooks

### 1. In Your Square App Dashboard

- Click **"Webhooks"** in the left menu
- Click **"Add Endpoint"**

### 2. Configure Webhook

**For Development (using ngrok)**:
```
URL: https://your-ngrok-url.ngrok.io/api/square-webhook
```

**For Production**:
```
URL: https://api.arizonacontractorwebs.com/api/square-webhook
```

### 3. Subscribe to Events

Select these events:
- ✅ `payment.created`
- ✅ `payment.updated`

### 4. Save Webhook

- Click **"Create Webhook"**
- Copy the **Signature Key** (if you want to verify webhooks)
- Add to `.env` as `SQUARE_WEBHOOK_SIGNATURE_KEY` (optional)

## Testing Your Setup

### 1. Use Square Sandbox

When `SQUARE_ENVIRONMENT=sandbox`, use these test cards:

**Successful Payment**:
- Card: `4111 1111 1111 1111`
- CVV: Any 3 digits (e.g., `123`)
- Expiration: Any future date (e.g., `12/28`)
- ZIP: Any valid ZIP (e.g., `85705`)

**Other Test Scenarios**:
- Declined card: `4000 0000 0000 0002`
- Insufficient funds: `4000 0000 0000 9995`

### 2. Test Payment Flow

```bash
# Start your server
npm run dev

# In another terminal, use ngrok to expose your server
ngrok http 3000

# Update Square webhook URL with ngrok URL
# Open your website and test a payment
```

### 3. Verify Webhook

- Make a test payment
- Check Square Dashboard → Webhooks → Event Log
- Should see successful webhook deliveries
- Check your server logs for webhook received
- Check your email for confirmation

## Permissions Your App Needs

Square apps need specific permissions. Ensure these are enabled:

- ✅ **Payments**: Accept payments
- ✅ **Orders**: Create and manage orders
- ✅ **Merchant**: Read merchant information
- ✅ **Locations**: Read location details

These are usually enabled by default, but you can check in:
**App Settings** → **OAuth** → **Permissions**

## Security Best Practices

### ✅ DO:
- Keep access tokens secret
- Use environment variables
- Never commit `.env` to Git
- Use sandbox for testing
- Rotate tokens regularly
- Enable webhook signature verification

### ❌ DON'T:
- Share access tokens publicly
- Hardcode tokens in source code
- Use production tokens for testing
- Commit credentials to GitHub
- Use same token across multiple environments

## Troubleshooting

### "Invalid Access Token" Error

**Possible causes**:
1. Token copied incorrectly (missing characters)
2. Using sandbox token with production environment
3. Using production token with sandbox environment
4. Token expired or revoked

**Solution**:
1. Double-check the token in `.env`
2. Ensure no extra spaces before/after token
3. Verify `SQUARE_ENVIRONMENT` matches token type
4. Try regenerating the token in Square dashboard

### Webhook Not Receiving Events

**Checklist**:
- [ ] Webhook URL is publicly accessible (use ngrok for local testing)
- [ ] Webhook is subscribed to correct events
- [ ] Webhook endpoint returns 200 status code
- [ ] Check Square webhook event log for delivery attempts
- [ ] Check server logs for webhook received

### Location ID Not Found

Your location ID is: **LC95Y4243HZKF**

If you get location errors:
1. Verify it's copied correctly in `.env`
2. Check it matches your Square account
3. Try listing locations with API:

```bash
curl https://connect.squareup.com/v2/locations \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

## Going to Production

When you're ready to accept real payments:

### 1. Update .env

```env
SQUARE_ACCESS_TOKEN=YOUR_PRODUCTION_TOKEN
SQUARE_LOCATION_ID=LC95Y4243HZKF
SQUARE_ENVIRONMENT=production
BASE_URL=https://your-actual-domain.com
```

### 2. Update Webhook

- Change webhook URL from ngrok to your production URL
- Test webhook delivery with production webhook URL

### 3. Test Production

Before marketing:
- [ ] Make a small test payment ($1)
- [ ] Verify email is received
- [ ] Check Square dashboard shows the payment
- [ ] Confirm webhook triggered correctly
- [ ] Refund test payment if needed

### 4. Monitor

- Check Square dashboard daily
- Monitor webhook event log
- Review server logs
- Track email delivery rates

## Support Resources

- **Square Developer Docs**: https://developer.squareup.com/docs
- **Square Support**: https://squareup.com/help
- **Square Community**: https://developer.squareup.com/forums
- **API Reference**: https://developer.squareup.com/reference/square

## Your Complete Configuration

Once you have your access token, your `.env` should look like:

```env
# Square Configuration
SQUARE_ACCESS_TOKEN=YOUR_TOKEN_HERE
SQUARE_LOCATION_ID=LC95Y4243HZKF
SQUARE_ENVIRONMENT=sandbox

# Server
PORT=3000
BASE_URL=http://localhost:3000

# Email
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=luisrojosmasonry@gmail.com
SMTP_PASS=YOUR_GMAIL_APP_PASSWORD
SMTP_FROM="Arizona Contractor Webs <luisrojosmasonry@gmail.com>"
ADMIN_EMAIL=luisrojosmasonry@gmail.com

# Business
BUSINESS_NAME="Arizona Contractor Webs"
BUSINESS_PHONE="+1 520-461-3937"
BUSINESS_EMAIL=luisrojosmasonry@gmail.com
```

## Quick Reference

**Your Square Location**:
- ID: `LC95Y4243HZKF`
- Name: Daniel Rojo
- Address: 2029 w southbrooke cir, Tucson, AZ 85705
- Phone: +1 520-461-3937
- Email: luisrojosmasonry@gmail.com

**Test Cards**:
- Success: `4111 1111 1111 1111`
- Decline: `4000 0000 0000 0002`

**Webhook Events**:
- `payment.created`
- `payment.updated`

---

**Need Help?**

Email: luisrojosmasonry@gmail.com  
Square Support: https://squareup.com/help
