# 🚀 Deployment Checklist - Arizona Contractor Webs

## Pre-Deployment Checklist

### ✅ Development Complete

- [ ] All features tested locally
- [ ] Payment flow works end-to-end
- [ ] Emails send successfully
- [ ] Website responsive on all devices
- [ ] Forms validate correctly
- [ ] Error handling implemented
- [ ] Logging configured
- [ ] Documentation reviewed

### ✅ Square Configuration

- [ ] Production access token obtained
- [ ] Location ID confirmed (LC95Y4243HZKF)
- [ ] Webhook endpoint configured
- [ ] Webhook subscriptions set up (payment.created, payment.updated)
- [ ] Test payments successful
- [ ] Production mode enabled in .env

### ✅ Email Configuration

- [ ] Production email service chosen (SendGrid/AWS SES recommended)
- [ ] SMTP credentials configured
- [ ] Test emails delivered successfully
- [ ] SPF/DKIM records configured
- [ ] Admin email notifications working

### ✅ Security

- [ ] HTTPS enabled (SSL certificate)
- [ ] Environment variables secured
- [ ] .env file not in repository
- [ ] Input validation implemented
- [ ] CORS configured properly
- [ ] Rate limiting enabled
- [ ] Webhook signature verification active

## Deployment Steps

### Step 1: Prepare Repository

```bash
# Ensure .env is not tracked
echo ".env" >> .gitignore

# Commit all changes
git add .
git commit -m "Prepare for production deployment"
git push origin main
```

### Step 2: Deploy Backend

#### Option A: Heroku

```bash
# Login to Heroku
heroku login

# Create application
heroku create arizona-contractor-webs-api

# Set environment variables
heroku config:set SQUARE_ACCESS_TOKEN=your_production_token
heroku config:set SQUARE_LOCATION_ID=LC95Y4243HZKF
heroku config:set SQUARE_ENVIRONMENT=production
heroku config:set BASE_URL=https://your-domain.com
heroku config:set SMTP_HOST=smtp.sendgrid.net
heroku config:set SMTP_PORT=587
heroku config:set SMTP_USER=apikey
heroku config:set SMTP_PASS=your_sendgrid_key
heroku config:set SMTP_FROM="Arizona Contractor Webs <noreply@arizonacontractorwebs.com>"
heroku config:set ADMIN_EMAIL=luisrojosmasonry@gmail.com

# Deploy
git push heroku main

# Check logs
heroku logs --tail

# Open application
heroku open
```

#### Option B: DigitalOcean

```bash
# 1. Create Droplet (Ubuntu 22.04)
# 2. SSH into server
ssh root@your_server_ip

# 3. Install Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# 4. Install PM2
sudo npm install -g pm2

# 5. Clone repository
git clone https://github.com/yourusername/arizona-contractor-webs.git
cd arizona-contractor-webs

# 6. Install dependencies
npm install

# 7. Create .env file
nano .env
# Add all environment variables

# 8. Start with PM2
pm2 start payment-server.js --name arizona-contractor-webs
pm2 save
pm2 startup

# 9. Configure Nginx
sudo apt install nginx
sudo nano /etc/nginx/sites-available/arizona-contractor-webs

# Add this configuration:
server {
    listen 80;
    server_name api.arizonacontractorwebs.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}

# Enable site
sudo ln -s /etc/nginx/sites-available/arizona-contractor-webs /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx

# 10. Get SSL certificate
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx -d api.arizonacontractorwebs.com
```

### Step 3: Deploy Frontend

#### Option A: Netlify

```bash
# 1. Install Netlify CLI
npm install -g netlify-cli

# 2. Login
netlify login

# 3. Initialize site
netlify init

# 4. Deploy
netlify deploy --prod

# 5. Update API endpoint in HTML
# Edit arizona-contractor-webs.html
# Change: fetch('http://localhost:3000/api/...')
# To: fetch('https://api.arizonacontractorwebs.com/api/...')
```

#### Option B: Vercel

```bash
# 1. Install Vercel CLI
npm install -g vercel

# 2. Login
vercel login

# 3. Deploy
vercel --prod

# 4. Update API endpoint in HTML
```

### Step 4: Configure Square Webhook

1. Go to Square Developer Dashboard
2. Select your application
3. Go to Webhooks section
4. Add webhook endpoint: `https://api.arizonacontractorwebs.com/api/square-webhook`
5. Subscribe to events:
   - payment.created
   - payment.updated
6. Test webhook delivery

### Step 5: DNS Configuration

```
# A Records
Type    Name    Value               TTL
A       @       your_frontend_ip    3600
A       api     your_backend_ip     3600

# CNAME Records (if using hosting services)
CNAME   www     your-frontend.netlify.app.   3600
CNAME   api     your-backend.herokuapp.com.  3600
```

### Step 6: Test Production

- [ ] Visit production website
- [ ] Submit test order
- [ ] Verify payment processing
- [ ] Check email delivery
- [ ] Verify admin notification
- [ ] Test mobile experience
- [ ] Check all links
- [ ] Verify webhook is receiving events

## Post-Deployment

### Monitoring Setup

1. **Uptime Monitoring**
   ```bash
   # Add to UptimeRobot
   - Website: https://arizonacontractorwebs.com
   - API Health: https://api.arizonacontractorwebs.com/health
   - Interval: 5 minutes
   ```

2. **Error Tracking**
   ```bash
   # Install Sentry
   npm install @sentry/node
   
   # Add to payment-server.js
   const Sentry = require("@sentry/node");
   Sentry.init({ dsn: "your-sentry-dsn" });
   ```

3. **Analytics**
   - Add Google Analytics to website
   - Track conversions and page views
   - Monitor user flow

### Backup Strategy

```bash
# Automated daily backups
0 2 * * * /usr/bin/pg_dump database_name > /backups/db_$(date +\%Y\%m\%d).sql
0 2 * * * tar -czf /backups/files_$(date +\%Y\%m\%d).tar.gz /var/www/arizona-contractor-webs
```

### Documentation

- [ ] Update README with production URLs
- [ ] Document deployment process
- [ ] Create runbook for common issues
- [ ] Share credentials securely with team

## Go-Live Checklist

### Marketing

- [ ] Update Google My Business
- [ ] Launch social media announcements
- [ ] Update email signatures
- [ ] Print business cards with URL
- [ ] Update contractor registry profile

### Operations

- [ ] Set up order tracking system
- [ ] Create customer onboarding process
- [ ] Establish SLA (3-5 day delivery)
- [ ] Create email templates for customer communication
- [ ] Set up calendar for order management

### Legal & Compliance

- [ ] Privacy policy published
- [ ] Terms of service published
- [ ] Refund policy defined
- [ ] Business licenses current
- [ ] Insurance updated

## Rollback Plan

If issues occur after deployment:

### Quick Rollback

```bash
# Heroku
heroku rollback

# DigitalOcean/PM2
pm2 stop arizona-contractor-webs
git checkout previous-version
npm install
pm2 restart arizona-contractor-webs
```

### Emergency Contact

- Developer: [Your contact info]
- Square Support: https://squareup.com/help
- Hosting Support: [Your hosting provider]

## Performance Optimization

After successful deployment:

1. **Enable Caching**
   ```nginx
   # In Nginx config
   location ~* \.(jpg|jpeg|png|gif|css|js)$ {
       expires 1y;
       add_header Cache-Control "public, immutable";
   }
   ```

2. **Enable Compression**
   ```javascript
   // In payment-server.js
   const compression = require('compression');
   app.use(compression());
   ```

3. **CDN Setup**
   - Move static assets to CDN
   - Use CloudFlare or AWS CloudFront

## Success Metrics

Track these KPIs:
- Conversion rate (visitors → orders)
- Average order value
- Order fulfillment time
- Customer satisfaction
- Revenue per month
- Website uptime
- Email delivery rate

## Next Steps After Launch

Week 1:
- Monitor closely for issues
- Respond to all customer inquiries within 24 hours
- Process first orders carefully
- Gather feedback

Week 2-4:
- Optimize based on feedback
- Add features based on customer requests
- Scale infrastructure if needed
- Expand marketing efforts

---

**You're ready to go live! 🚀**

Remember: Start small, test everything, and scale gradually.
