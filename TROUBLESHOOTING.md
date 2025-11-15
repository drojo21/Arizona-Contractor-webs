# Troubleshooting Guide - Arizona Contractor Webs

## 🔍 Common Issues & Solutions

### Installation & Setup Issues

#### Issue: `npm install` fails
**Symptoms:**
```bash
npm ERR! code ENOENT
npm ERR! syscall open
```

**Solutions:**
1. Ensure Node.js is installed: `node --version`
2. Update npm: `npm install -g npm@latest`
3. Clear npm cache: `npm cache clean --force`
4. Delete `node_modules` and `package-lock.json`, then reinstall:
```bash
rm -rf node_modules package-lock.json
npm install
```

#### Issue: Port already in use
**Symptoms:**
```bash
Error: listen EADDRINUSE: address already in use :::3000
```

**Solutions:**
1. Find process using port 3000:
```bash
# Mac/Linux
lsof -i :3000

# Windows
netstat -ano | findstr :3000
```

2. Kill the process or change port in `.env`:
```env
PORT=3001
```

---

### Square Integration Issues

#### Issue: Invalid access token
**Symptoms:**
```json
{
  "errors": [{
    "code": "UNAUTHORIZED",
    "detail": "Invalid access token"
  }]
}
```

**Solutions:**
1. Verify access token in `.env` file
2. Check if you're using correct environment (sandbox vs production)
3. Regenerate access token in Square Developer Dashboard
4. Ensure no extra spaces or quotes in `.env` file

#### Issue: Location ID not found
**Symptoms:**
```json
{
  "errors": [{
    "code": "NOT_FOUND",
    "detail": "Location not found"
  }]
}
```

**Solutions:**
1. Verify location ID in Square dashboard
2. Ensure location is active
3. Check if location belongs to your account
4. Update `SQUARE_LOCATION_ID` in `.env`

#### Issue: Webhook not receiving payments
**Symptoms:**
- Payments complete on Square but no email sent
- No order fulfillment triggered

**Solutions:**
1. Verify webhook URL is publicly accessible
2. Check Square Developer Dashboard → Webhooks → Event Log
3. Ensure webhook is subscribed to `payment.created` and `payment.updated`
4. Test webhook locally using ngrok:
```bash
npm install -g ngrok
ngrok http 3000
# Use ngrok URL in Square webhook settings
```

5. Add logging to webhook endpoint:
```javascript
app.post('/api/square-webhook', async (req, res) => {
    console.log('Webhook received:', JSON.stringify(req.body, null, 2));
    // ... rest of code
});
```

---

### Email Issues

#### Issue: Email not sending
**Symptoms:**
```bash
Error: Invalid login: 535-5.7.8 Username and Password not accepted
```

**Solutions for Gmail:**

1. Enable 2-Factor Authentication
2. Create App Password:
   - Google Account → Security → 2-Step Verification → App passwords
   - Generate password for "Mail"
   - Use this in `SMTP_PASS`

3. Check less secure apps (not recommended):
   - Google Account → Security → Less secure app access → Turn on

4. Try alternative port:
```env
SMTP_PORT=465
SMTP_SECURE=true
```

**Solutions for Other Providers:**

SendGrid:
```env
SMTP_HOST=smtp.sendgrid.net
SMTP_PORT=587
SMTP_USER=apikey
SMTP_PASS=your_sendgrid_api_key
```

Mailgun:
```env
SMTP_HOST=smtp.mailgun.org
SMTP_PORT=587
SMTP_USER=postmaster@your-domain.mailgun.org
SMTP_PASS=your_mailgun_smtp_password
```

#### Issue: Emails going to spam
**Solutions:**
1. Set up SPF record for your domain
2. Set up DKIM signing
3. Use professional email service (SendGrid, AWS SES)
4. Add unsubscribe link in emails
5. Avoid spam trigger words in subject line
6. Use custom domain for sending

#### Issue: Email template not displaying correctly
**Solutions:**
1. Test email in different clients
2. Use inline CSS instead of `<style>` tags
3. Avoid JavaScript in emails
4. Test with email testing tools (Litmus, Email on Acid)
5. Keep HTML simple and table-based for layout

---

### Payment Processing Issues

#### Issue: Payment succeeds but no confirmation email
**Checklist:**
1. Check server logs for errors
2. Verify webhook is being triggered
3. Test email configuration separately:
```javascript
// Add test endpoint
app.get('/test-email', async (req, res) => {
    await transporter.sendMail({
        from: process.env.SMTP_FROM,
        to: 'your-test-email@example.com',
        subject: 'Test Email',
        html: '<p>This is a test</p>'
    });
    res.send('Email sent');
});
```

4. Check if order is in memory/database
5. Verify Square webhook is sending correct metadata

#### Issue: Customer charged but order not processed
**Immediate Actions:**
1. Check Square dashboard for payment details
2. Retrieve order ID from payment metadata
3. Manually trigger email send:
```javascript
// Add manual fulfillment endpoint
app.post('/api/manual-fulfill', async (req, res) => {
    const { orderId } = req.body;
    const order = orders.get(orderId);
    await sendBoltTemplate(order);
    res.json({ success: true });
});
```

4. Refund customer if needed (via Square dashboard)
5. Investigate webhook logs

#### Issue: Test payments not working
**Solutions:**
1. Ensure `SQUARE_ENVIRONMENT=sandbox` in `.env`
2. Use Square test card: 4111 1111 1111 1111
3. Check Square Sandbox dashboard for test payments
4. Verify webhook is configured for sandbox environment

---

### Frontend Issues

#### Issue: Form submission not working
**Symptoms:**
- Form submits but nothing happens
- Console errors

**Solutions:**
1. Check browser console for errors (F12)
2. Verify API endpoint URL is correct
3. Check CORS configuration on server:
```javascript
app.use(cors({
    origin: 'https://your-domain.com',
    methods: ['GET', 'POST']
}));
```

4. Test API endpoint with curl:
```bash
curl -X POST https://your-api.com/api/create-square-checkout \
  -H "Content-Type: application/json" \
  -d '{"businessName":"Test","email":"test@example.com",...}'
```

#### Issue: Styling issues on mobile
**Solutions:**
1. Test in browser device emulator
2. Verify viewport meta tag is present
3. Check media queries are working
4. Test on actual devices
5. Use mobile-first approach

#### Issue: Portfolio section not loading
**Solutions:**
1. Verify Luis Rojo's Masonry link is accessible
2. Check for HTTPS issues (mixed content)
3. Ensure iframe permissions are correct
4. Consider using screenshot instead of iframe

---

### Deployment Issues

#### Issue: Heroku deployment fails
**Solutions:**
1. Check `package.json` has correct start script
2. Verify `engines` field specifies Node version:
```json
"engines": {
    "node": ">=18.0.0"
}
```

3. Check Heroku logs:
```bash
heroku logs --tail
```

4. Ensure all dependencies are in `dependencies`, not `devDependencies`

#### Issue: Environment variables not loading
**Solutions:**
1. Verify `.env` file exists (not `.env.example`)
2. Ensure `dotenv` is loaded at top of file:
```javascript
require('dotenv').config();
```

3. For Heroku, set config vars:
```bash
heroku config:set SQUARE_ACCESS_TOKEN=your_token
```

4. Don't commit `.env` to git (add to `.gitignore`)

#### Issue: Cannot connect to deployed server
**Solutions:**
1. Check if server is running: `heroku ps` (for Heroku)
2. Verify HTTPS is enabled
3. Check DNS settings point to correct server
4. Ensure firewall allows incoming connections on port 80/443
5. Test with curl:
```bash
curl -I https://your-domain.com/health
```

---

### Database Issues (If Using Database)

#### Issue: Cannot connect to MongoDB
**Solutions:**
1. Verify connection string
2. Check IP whitelist in MongoDB Atlas
3. Ensure database user has correct permissions
4. Test connection:
```javascript
mongoose.connect(process.env.MONGODB_URI)
    .then(() => console.log('Connected to MongoDB'))
    .catch(err => console.error('MongoDB connection error:', err));
```

#### Issue: Orders not saving
**Solutions:**
1. Check schema definition
2. Verify database permissions
3. Add error handling:
```javascript
try {
    await order.save();
} catch (error) {
    console.error('Error saving order:', error);
}
```

---

### Performance Issues

#### Issue: Slow API responses
**Solutions:**
1. Add caching layer (Redis)
2. Optimize database queries
3. Use CDN for static assets
4. Enable compression:
```javascript
const compression = require('compression');
app.use(compression());
```

5. Monitor with New Relic or Datadog

#### Issue: High memory usage
**Solutions:**
1. If using in-memory storage, switch to database
2. Implement garbage collection monitoring
3. Check for memory leaks
4. Use PM2 for process management:
```bash
pm2 start payment-server.js --name "acw-api"
pm2 monit
```

---

## 🐛 Debugging Tips

### Enable Debug Logging

Add to your server:
```javascript
// Add debug middleware
app.use((req, res, next) => {
    console.log(`${new Date().toISOString()} ${req.method} ${req.path}`);
    next();
});

// Log all webhook data
app.post('/api/square-webhook', async (req, res) => {
    console.log('Webhook received:', JSON.stringify(req.body, null, 2));
    // ... rest of code
});
```

### Test Components Independently

**Test Square Connection:**
```javascript
const { Client, Environment } = require('square');

const client = new Client({
    accessToken: process.env.SQUARE_ACCESS_TOKEN,
    environment: Environment.Sandbox
});

async function testSquare() {
    try {
        const response = await client.locationsApi.listLocations();
        console.log('Locations:', response.result);
    } catch (error) {
        console.error('Error:', error);
    }
}

testSquare();
```

**Test Email:**
```javascript
async function testEmail() {
    try {
        await transporter.sendMail({
            from: process.env.SMTP_FROM,
            to: 'your-email@example.com',
            subject: 'Test',
            html: '<p>Test email</p>'
        });
        console.log('Email sent successfully');
    } catch (error) {
        console.error('Email error:', error);
    }
}

testEmail();
```

### Use Request Logging

Install morgan:
```bash
npm install morgan
```

Add to server:
```javascript
const morgan = require('morgan');
app.use(morgan('combined'));
```

---

## 📞 Getting Help

### Before Asking for Help

1. ✅ Check this troubleshooting guide
2. ✅ Review server logs
3. ✅ Check browser console
4. ✅ Test components individually
5. ✅ Search error messages online
6. ✅ Review Square Developer documentation
7. ✅ Check environment variables

### Information to Provide

When asking for help, include:
- Error message (full text)
- Server logs
- Browser console errors
- Steps to reproduce
- Environment (Node version, OS)
- What you've already tried

### Support Resources

- **Square Support**: https://squareup.com/help
- **Node.js Documentation**: https://nodejs.org/docs/
- **Express.js Guide**: https://expressjs.com/
- **Stack Overflow**: Search for specific errors
- **GitHub Issues**: Check square-nodejs-sdk issues

---

## 🔧 Quick Fixes Checklist

Before diving deep into debugging:

- [ ] Restart the server
- [ ] Clear browser cache
- [ ] Check `.env` file exists and has correct values
- [ ] Verify all npm packages are installed
- [ ] Check server logs for errors
- [ ] Test in incognito/private browser window
- [ ] Verify API endpoints are accessible
- [ ] Check Square dashboard for payment status
- [ ] Test email sending separately
- [ ] Verify webhook URL is publicly accessible
- [ ] Check firewall and security group settings
- [ ] Confirm HTTPS is enabled
- [ ] Test with curl or Postman
- [ ] Review recent code changes
- [ ] Check if issue is reproducible

---

## 🚨 Emergency Procedures

### If Payments Are Processing But Not Fulfilling

1. **Immediate Action**: Document all affected orders
2. **Retrieve Payment Data**: Check Square dashboard
3. **Manual Fulfillment**: Use order IDs to manually send emails
4. **Customer Communication**: Contact affected customers
5. **Root Cause Analysis**: Investigate logs
6. **Prevention**: Add monitoring alerts

### If System Is Down

1. **Check Status**: Verify server is running
2. **Review Logs**: Look for crash reports
3. **Restart Service**: 
```bash
# If using PM2
pm2 restart all

# If using systemd
sudo systemctl restart arizona-contractor-webs
```
4. **Check Dependencies**: Verify external services (Square, email)
5. **Notify Customers**: If prolonged, add status page
6. **Escalate**: If can't resolve quickly, contact hosting support

---

## 📊 Monitoring Setup

Prevent issues with proper monitoring:

### Uptime Monitoring
```javascript
// Add health check endpoint
app.get('/health', (req, res) => {
    res.json({
        status: 'ok',
        timestamp: new Date().toISOString(),
        uptime: process.uptime()
    });
});
```

Use services like:
- UptimeRobot (free)
- Pingdom
- StatusCake

### Error Tracking

Install Sentry:
```bash
npm install @sentry/node
```

Configure:
```javascript
const Sentry = require("@sentry/node");

Sentry.init({ dsn: "your-sentry-dsn" });

app.use(Sentry.Handlers.errorHandler());
```

### Log Management

Collect logs with:
- Papertrail
- Loggly
- CloudWatch (if on AWS)

---

**Remember**: Most issues have simple solutions. Work through this guide systematically, and you'll resolve 95% of problems quickly! 🎯
