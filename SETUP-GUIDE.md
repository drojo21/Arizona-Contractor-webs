# Arizona Contractor Webs - Complete Setup Guide

## 📋 Overview

This is a complete website and payment processing system for Arizona Contractor Webs. It includes:
- Professional marketing website showcasing services
- Square payment integration for upfront payment
- Automated bolt.new template generation and email delivery
- Admin notifications for new orders

## 🚀 Quick Start

### 1. Install Dependencies

```bash
npm install
```

### 2. Configure Environment Variables

Create a `.env` file from the example:

```bash
cp .env.example .env
```

Then edit `.env` with your actual credentials:

```env
SQUARE_ACCESS_TOKEN=your_actual_square_token
SQUARE_LOCATION_ID=your_location_id
SQUARE_ENVIRONMENT=sandbox  # or 'production'
BASE_URL=https://your-domain.com
SMTP_USER=your_email@gmail.com
SMTP_PASS=your_password
ADMIN_EMAIL=your_admin_email@gmail.com
```

### 3. Start the Server

```bash
# Development mode (auto-restart on changes)
npm run dev

# Production mode
npm start
```

### 4. Deploy the Website

Upload `arizona-contractor-webs.html` to your web hosting or use a static hosting service.

## 🔧 Square Setup

### Getting Your Square Credentials

1. **Create Square Developer Account**
   - Go to https://developer.squareup.com/apps
   - Sign in with your Square account
   - Click "New Application"

2. **Get Access Token**
   - Go to your application dashboard
   - Click "Credentials" tab
   - Copy your **Access Token** (use Sandbox for testing, Production when ready)
   - Add to `.env` as `SQUARE_ACCESS_TOKEN`

3. **Get Location ID**
   - In Square dashboard, go to "Locations"
   - Find your location ID
   - Add to `.env` as `SQUARE_LOCATION_ID`

4. **Set Up Webhooks**
   - In your Square app, go to "Webhooks"
   - Click "Add Endpoint"
   - Set URL to: `https://your-domain.com/api/square-webhook`
   - Subscribe to: `payment.created` and `payment.updated`
   - Copy webhook signature key (optional, for verification)

### Testing with Square Sandbox

Use Square's test cards:
- **Success**: 4111 1111 1111 1111
- **CVV**: Any 3 digits
- **Exp**: Any future date
- **Postal Code**: Any valid code

## 📧 Email Setup

### Gmail Configuration

1. **Enable 2-Factor Authentication** on your Gmail account

2. **Create App Password**:
   - Go to Google Account settings
   - Security → 2-Step Verification → App passwords
   - Generate password for "Mail"
   - Use this password in `.env` as `SMTP_PASS`

### Alternative Email Providers

**SendGrid**:
```env
SMTP_HOST=smtp.sendgrid.net
SMTP_PORT=587
SMTP_USER=apikey
SMTP_PASS=your_sendgrid_api_key
```

**Mailgun**:
```env
SMTP_HOST=smtp.mailgun.org
SMTP_PORT=587
SMTP_USER=your_mailgun_username
SMTP_PASS=your_mailgun_password
```

## 🌐 Deployment Options

### Option 1: Heroku

```bash
# Install Heroku CLI
heroku login
heroku create arizona-contractor-webs
git init
git add .
git commit -m "Initial commit"
git push heroku main

# Set environment variables
heroku config:set SQUARE_ACCESS_TOKEN=your_token
heroku config:set SQUARE_LOCATION_ID=your_location
# ... set all other env vars
```

### Option 2: DigitalOcean

1. Create a Droplet (Ubuntu 22.04)
2. SSH into your server
3. Install Node.js:
```bash
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs
```
4. Clone your repository
5. Install dependencies: `npm install`
6. Install PM2: `sudo npm install -g pm2`
7. Start server: `pm2 start payment-server.js`
8. Set up Nginx reverse proxy

### Option 3: Vercel/Netlify

Upload `arizona-contractor-webs.html` as a static site. Deploy backend separately on Heroku or DigitalOcean.

## 📁 File Structure

```
arizona-contractor-webs/
├── arizona-contractor-webs.html    # Main website
├── payment-server.js               # Backend server with Square integration
├── package.json                    # Dependencies
├── .env.example                    # Environment variables template
├── .env                           # Your actual credentials (don't commit!)
└── README.md                      # This file
```

## 🔄 Payment Flow

1. **Customer visits website** → Fills out order form
2. **Form submits** → Backend creates Square Checkout session
3. **Customer redirects to Square** → Completes payment
4. **Payment completes** → Square webhook notifies your server
5. **Server processes**:
   - Generates custom bolt.new template
   - Emails template to customer
   - Sends admin notification
6. **Customer receives email** → Can preview website on bolt.new
7. **You build website** → Deliver within 3-5 days

## 🎨 Customizing the Website

### Update the HTML

Edit `arizona-contractor-webs.html`:

```html
<!-- Change colors -->
--primary-color: #d84315;  <!-- Your brand color -->
--secondary-color: #1976d2;

<!-- Update contact info -->
<p>Email: your-email@domain.com<br>
Phone: (555) 123-4567</p>

<!-- Add your actual business details -->
```

### Update Form Endpoint

In `arizona-contractor-webs.html`, find the form submission code and update the API endpoint:

```javascript
const response = await fetch('https://your-domain.com/api/create-square-checkout', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data)
});
```

## 🛠️ Bolt.new Template Customization

The templates are generated in `payment-server.js` → `generateBoltTemplate()` function.

To customize templates for different trades:
1. Edit the `getTradeColors()` function for color schemes
2. Edit the `getTradeServices()` function for service lists
3. Modify the main template structure in `generateBoltTemplate()`

## 📊 Tracking Orders

Orders are temporarily stored in memory. For production, integrate a database:

**MongoDB Example**:
```javascript
const mongoose = require('mongoose');

const OrderSchema = new mongoose.Schema({
    orderId: String,
    businessName: String,
    contactName: String,
    email: String,
    phone: String,
    tradeType: String,
    serviceArea: String,
    packageType: String,
    amount: Number,
    status: String,
    createdAt: Date,
    paidAt: Date
});

const Order = mongoose.model('Order', OrderSchema);
```

## 🔒 Security Best Practices

1. **Never commit `.env` file** - Add to `.gitignore`
2. **Use environment variables** for all sensitive data
3. **Validate webhook signatures** from Square
4. **Use HTTPS** in production
5. **Rate limit** your API endpoints
6. **Sanitize user inputs** before processing

## 🐛 Troubleshooting

### Payment not redirecting
- Check `BASE_URL` in `.env`
- Verify Square redirect URL matches your domain
- Check browser console for errors

### Email not sending
- Verify SMTP credentials in `.env`
- Check spam folder
- Try using an app password instead of regular password
- Enable "Less secure app access" for Gmail (not recommended for production)

### Webhook not firing
- Verify webhook URL is publicly accessible
- Check Square dashboard for webhook delivery attempts
- Review webhook signature validation
- Check server logs

### Template not generating
- Verify order details are being captured correctly
- Check `generateBoltTemplate()` function
- Review email template HTML for syntax errors

## 📞 Support

For questions or issues:
- Email: info@arizonacontractorwebs.com
- Phone: Your phone number
- Website: Your website URL

## 📝 License

MIT License - Feel free to modify for your use

## 🎯 Next Steps

1. ✅ Set up Square account and get credentials
2. ✅ Configure email service
3. ✅ Test payment flow in sandbox mode
4. ✅ Customize website design and copy
5. ✅ Deploy to production server
6. ✅ Switch Square to production mode
7. ✅ Set up domain and SSL certificate
8. ✅ Test complete order flow
9. ✅ Launch and start marketing!

## 💡 Additional Features to Consider

- **Customer Dashboard**: Let customers track their order status
- **Email Sequences**: Automated follow-ups and website launch notifications
- **Analytics**: Track conversion rates and revenue
- **Testimonials**: Collect and display customer reviews
- **Referral Program**: Incentivize customers to refer other contractors
- **Upsells**: Offer additional services (SEO, social media management, etc.)

---

Built with ❤️ for Arizona Contractors
