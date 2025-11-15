# Deploy to Vercel - Quick Guide

## Prerequisites

1. Install Vercel CLI globally:
```bash
npm install -g vercel
```

2. Have your Vercel account ready (sign up at vercel.com if needed)

## Step 1: Deploy Backend (API)

```bash
# Login to Vercel
vercel login

# Deploy the backend
vercel --prod

# Follow the prompts:
# - Setup and deploy? Y
# - Which scope? (select your account)
# - Link to existing project? N
# - Project name? arizona-contractor-webs-api
# - Directory? ./
# - Override settings? N
```

After deployment, Vercel will give you a URL like:
`https://arizona-contractor-webs-api.vercel.app`

## Step 2: Configure Environment Variables

Go to your Vercel dashboard (vercel.com) and add these environment variables:

1. Navigate to: Project Settings → Environment Variables

2. Add each variable:

```
SQUARE_ACCESS_TOKEN=EAAAl1M0roYPxWAHcEJtAy5Whv__NV9CJZthYmzKulTSyHA1Zv_e9YtDv32RlCsk
SQUARE_LOCATION_ID=LC95Y4243HZKF
SQUARE_ENVIRONMENT=production
BASE_URL=https://your-backend-url.vercel.app
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_SECURE=false
SMTP_USER=luisrojosmasonry@gmail.com
SMTP_PASS=cgpu zhdt pmgw spjn
SMTP_FROM=Arizona Contractor Webs <luisrojosmasonry@gmail.com>
ADMIN_EMAIL=luisrojosmasonry@gmail.com
```

3. After adding variables, redeploy:
```bash
vercel --prod
```

## Step 3: Update BASE_URL

After your backend is deployed, update the BASE_URL environment variable in Vercel dashboard with your actual backend URL:

```
BASE_URL=https://arizona-contractor-webs-api.vercel.app
```

Then redeploy again:
```bash
vercel --prod
```

## Step 4: Deploy Frontend (HTML Website)

Create a new directory for frontend:

```bash
# Create frontend directory
mkdir frontend
cp arizona-contractor-webs.html frontend/index.html

# Deploy frontend separately
cd frontend
vercel --prod

# When prompted:
# - Project name? arizona-contractor-webs
# - Build settings? N (it's just a static HTML file)
```

Your frontend will be at:
`https://arizona-contractor-webs.vercel.app`

## Step 5: Configure Square Webhook

1. Go to Square Developer Dashboard: https://developer.squareup.com/apps
2. Select your application
3. Go to "Webhooks" section
4. Add webhook endpoint:
   ```
   https://arizona-contractor-webs-api.vercel.app/api/square-webhook
   ```
5. Subscribe to these events:
   - payment.created
   - payment.updated
6. Save

## Step 6: Test Your Live Site

1. Visit your frontend URL: `https://arizona-contractor-webs.vercel.app`
2. Fill out the order form with test data
3. Complete a test payment
4. Verify:
   - Payment processes successfully
   - Confirmation email is received
   - Admin notification email is received
   - Template is sent correctly

## Step 7: Custom Domain (Optional)

### Add Custom Domain to Frontend:

1. In Vercel dashboard, go to your frontend project
2. Navigate to Settings → Domains
3. Add your domain (e.g., arizonacontractorwebs.com)
4. Follow DNS configuration instructions from Vercel

### Add Custom Domain to Backend (API):

1. In Vercel dashboard, go to your backend project
2. Navigate to Settings → Domains
3. Add your API subdomain (e.g., api.arizonacontractorwebs.com)
4. Update DNS with provided settings

### Update Environment Variables:

After setting up custom domains:

1. Update BASE_URL in backend environment variables:
   ```
   BASE_URL=https://api.arizonacontractorwebs.com
   ```

2. Redeploy both projects

## Important Notes

- **Vercel Serverless Functions**: Your payment-server.js runs as a serverless function
- **Cold Starts**: First request may be slower, subsequent requests are fast
- **Logs**: View logs in Vercel dashboard under "Deployments" → "Functions"
- **Rate Limits**: Vercel has generous limits for hobby plan
- **Database**: Consider using Supabase (already configured) for storing orders permanently

## Troubleshooting

### If emails aren't sending:
- Verify Gmail App Password is correct
- Check SMTP environment variables
- Consider switching to SendGrid or AWS SES for production

### If payments aren't processing:
- Verify Square credentials are for production (not sandbox)
- Check webhook is configured correctly
- View Vercel function logs for errors

### If you get CORS errors:
- The backend already has CORS enabled
- Ensure you're calling the correct backend URL
- Check browser console for specific error

## Quick Redeploy Commands

```bash
# Redeploy backend
vercel --prod

# Redeploy frontend
cd frontend && vercel --prod
```

## Monitoring

- **Uptime**: Use UptimeRobot (free) to monitor both URLs
- **Analytics**: Add Google Analytics to your HTML
- **Errors**: Check Vercel dashboard for function errors
- **Square**: Monitor payments in Square Dashboard

## Success Checklist

- [ ] Backend deployed to Vercel
- [ ] All environment variables configured
- [ ] Frontend deployed to Vercel
- [ ] Square webhook configured
- [ ] Test payment successful
- [ ] Emails sending correctly
- [ ] Custom domain configured (optional)
- [ ] Monitoring set up

---

**You're now live! Start marketing your services and getting customers.**

For support, check the Vercel documentation or contact support@vercel.com
