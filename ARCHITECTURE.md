# Arizona Contractor Webs - System Architecture & Workflow

## 🏗️ System Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                    Arizona Contractor Webs                      │
│                    Complete Solution Stack                      │
└─────────────────────────────────────────────────────────────────┘

┌──────────────────┐     ┌──────────────────┐     ┌──────────────┐
│   Customer       │     │   Your Server    │     │   Square     │
│   (Browser)      │────▶│   (Node.js)      │────▶│   Payment    │
└──────────────────┘     └──────────────────┘     └──────────────┘
         │                        │                        │
         │                        │                        │
         ▼                        ▼                        ▼
┌──────────────────┐     ┌──────────────────┐     ┌──────────────┐
│   Website        │     │   Database       │     │   Email      │
│   (HTML)         │     │   (Optional)     │     │   Service    │
└──────────────────┘     └──────────────────┘     └──────────────┘
```

## 📊 Complete Payment & Delivery Flow

### Step 1: Customer Visits Website
```
Customer → arizona-contractor-webs.html
          ↓
    Sees services:
    • Website - $250
    • Social Media - $120  
    • Complete Package - $370
          ↓
    Fills out order form:
    • Business name
    • Contact info
    • Trade type
    • Service area
    • Package selection
```

### Step 2: Order Submission
```
Form Submit → POST /api/create-square-checkout
             ↓
    Server processes:
    1. Validates form data
    2. Generates unique order ID
    3. Creates Square Checkout session
    4. Stores order details
             ↓
    Response: Square checkout URL
             ↓
    Redirect → Square payment page
```

### Step 3: Payment Processing
```
Customer on Square payment page
         ↓
    Enters payment info
    (Secure on Square's servers)
         ↓
    Payment completed
         ↓
    Square processes payment
         ↓
    Square sends webhook
         ↓
    POST /api/square-webhook
```

### Step 4: Order Fulfillment
```
Webhook received → payment-server.js
                  ↓
    Verify payment status = COMPLETED
                  ↓
    ┌─────────────────────────────────┐
    │  Parallel Processing:           │
    │                                 │
    │  1. Generate bolt.new template  │
    │     • Trade-specific design     │
    │     • Custom color scheme       │
    │     • Service descriptions      │
    │                                 │
    │  2. Send customer email         │
    │     • Order confirmation        │
    │     • Bolt.new template         │
    │     • Next steps                │
    │                                 │
    │  3. Send admin notification     │
    │     • New order alert           │
    │     • Customer details          │
    │     • Action required           │
    └─────────────────────────────────┘
                  ↓
    Customer redirected to success page
```

### Step 5: Website Development
```
Admin receives notification
         ↓
    Reviews order details
         ↓
    Contacts customer (within 24 hours)
         ↓
    Gathers additional info:
    • Photos
    • Logo
    • Specific services
    • Contact details
         ↓
    Builds website (3-5 days)
         ↓
    Deploys to production
         ↓
    Sends final website URL
```

## 🔧 Technical Component Breakdown

### Frontend (arizona-contractor-webs.html)

**Features:**
- Responsive design (mobile, tablet, desktop)
- Service pricing cards
- Portfolio section (Luis Rojo's Masonry example)
- Order form with validation
- Smooth scrolling navigation
- Professional styling

**Key Sections:**
1. Hero - Strong value proposition
2. Services - Clear pricing
3. Portfolio - Real example
4. Features - Why choose us
5. Process - How it works
6. Order - Payment form
7. Footer - Contact info

### Backend (payment-server.js)

**Endpoints:**

1. **POST /api/create-square-checkout**
   - Creates Square payment link
   - Stores order details
   - Returns checkout URL

2. **POST /api/square-webhook**
   - Receives payment notifications
   - Triggers fulfillment process
   - Sends emails

3. **GET /payment-success**
   - Success page after payment
   - Shows order confirmation
   - Lists next steps

4. **GET /health**
   - Health check endpoint
   - Used for monitoring

**Core Functions:**

- `generateBoltTemplate()` - Creates custom bolt.new prompt
- `getTradeColors()` - Returns color scheme for trade type
- `getTradeServices()` - Returns service list for trade type
- `sendBoltTemplate()` - Emails template to customer
- `sendAdminNotification()` - Alerts admin of new order

### Email Templates

**Customer Email Includes:**
- Welcome message
- Order summary
- Custom bolt.new template (full text)
- Button to open bolt.new
- Step-by-step instructions
- What happens next
- Timeline (3-5 days)
- Contact information

**Admin Email Includes:**
- Order notification
- All customer details
- Package type
- Action required notice
- Order ID for tracking

## 💳 Square Integration Details

### Payment Link Creation

```javascript
const checkoutResponse = await squareClient.checkoutApi.createPaymentLink({
    idempotencyKey: orderId,
    order: {
        locationId: SQUARE_LOCATION_ID,
        lineItems: [{
            name: packageName,
            quantity: '1',
            basePriceMoney: {
                amount: BigInt(amount * 100), // cents
                currency: 'USD'
            }
        }],
        metadata: {
            // Store order details for webhook
            orderId, businessName, email, etc.
        }
    },
    checkoutOptions: {
        redirectUrl: `${BASE_URL}/payment-success?orderId=${orderId}`,
        askForShippingAddress: false
    },
    prePopulatedData: {
        buyerEmail: email,
        buyerPhoneNumber: phone
    }
});
```

### Webhook Processing

```javascript
// Square notifies your server
POST /api/square-webhook
{
    type: "payment.updated",
    data: {
        object: {
            payment: {
                status: "COMPLETED",
                order: {
                    metadata: {
                        orderId, businessName, email, ...
                    }
                }
            }
        }
    }
}
```

## 📧 Email Service Integration

### SMTP Configuration Options

**Gmail** (Development):
```env
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your_email@gmail.com
SMTP_PASS=app_specific_password
```

**SendGrid** (Production Recommended):
```env
SMTP_HOST=smtp.sendgrid.net
SMTP_PORT=587
SMTP_USER=apikey
SMTP_PASS=your_sendgrid_api_key
```

**AWS SES** (Production Recommended):
```env
SMTP_HOST=email-smtp.us-east-1.amazonaws.com
SMTP_PORT=587
SMTP_USER=your_aws_smtp_username
SMTP_PASS=your_aws_smtp_password
```

## 🎨 Bolt.new Template Generation

### Trade-Specific Customization

Each trade type gets:
- **Custom color scheme** - Matches industry standards
- **Specific services** - Relevant to that trade
- **Tailored copy** - Industry-appropriate language
- **Design suggestions** - Trade-specific imagery

**Example for Masonry:**
```
Colors: Brick red (#d84315), Brown (#5d4037)
Services: Block walls, Stucco, Stonework, Repairs
Imagery: Brick textures, stone work, completed projects
```

**Example for Plumbing:**
```
Colors: Blue (#1976d2), Cyan (#00acc1)
Services: Leak repair, Water heaters, Drain cleaning
Imagery: Pipes, fixtures, clean installations
```

### Template Structure

```
1. Hero Section
   • Business name
   • Primary CTA
   • Trust indicators

2. Services Section
   • Trade-specific services
   • Pricing structure
   • Service descriptions

3. About Section
   • Experience
   • Credentials
   • Why choose us

4. Gallery
   • Project photos
   • Before/after shots

5. Contact Section
   • Contact form
   • Phone/email
   • Service area map

6. Footer
   • Business info
   • License details
   • Social links
```

## 🚀 Deployment Architecture

### Recommended Production Setup

```
┌─────────────────────────────────────────────────┐
│                   Domain                        │
│          www.arizonacontractorwebs.com         │
└────────────┬───────────────────┬────────────────┘
             │                   │
             │                   │
        ┌────▼─────┐      ┌─────▼──────┐
        │  Static  │      │   API      │
        │  Website │      │  Server    │
        │          │      │            │
        │ Netlify/ │      │ Heroku/    │
        │ Vercel   │      │ Digital    │
        │          │      │ Ocean      │
        └──────────┘      └────────────┘
                                │
                          ┌─────┴──────┐
                          │            │
                     ┌────▼────┐  ┌───▼────┐
                     │ Square  │  │ Email  │
                     │ Payment │  │Service │
                     └─────────┘  └────────┘
```

## 📈 Scaling Considerations

### Current Setup (Good for 0-100 orders/month)
- In-memory order storage
- Single server instance
- Basic email service

### Growth Phase (100-1000 orders/month)
- Add MongoDB/PostgreSQL database
- Load balancer with multiple servers
- Professional email service (SendGrid/AWS SES)
- Order tracking dashboard
- Automated website deployment pipeline

### Enterprise Phase (1000+ orders/month)
- Microservices architecture
- Redis caching layer
- CDN for static assets
- Automated testing pipeline
- Customer self-service portal
- Analytics dashboard
- A/B testing framework

## 🔐 Security Checklist

- ✅ HTTPS enabled (SSL certificate)
- ✅ Environment variables for secrets
- ✅ Square webhook signature verification
- ✅ Input validation and sanitization
- ✅ Rate limiting on API endpoints
- ✅ CORS configuration
- ✅ SQL injection prevention
- ✅ XSS protection
- ✅ CSRF tokens (if using sessions)
- ✅ Regular dependency updates

## 📊 Monitoring & Analytics

### Key Metrics to Track

**Business Metrics:**
- Conversion rate (visitors → orders)
- Average order value
- Package distribution (website vs complete)
- Geographic distribution
- Trade type popularity

**Technical Metrics:**
- Server uptime
- API response times
- Payment success rate
- Email delivery rate
- Error rates
- Webhook processing time

### Recommended Tools

- **Analytics**: Google Analytics 4
- **Monitoring**: Datadog, New Relic, or Sentry
- **Uptime**: UptimeRobot or Pingdom
- **Logs**: Papertrail or LogDNA

## 🎯 Future Enhancement Ideas

1. **Customer Portal**
   - Order tracking
   - Website preview
   - Provide feedback
   - Request changes

2. **Advanced Customization**
   - Logo upload during checkout
   - Photo upload
   - Color scheme selection
   - Layout preferences

3. **Marketing Automation**
   - Email sequences
   - Follow-up reminders
   - Referral program
   - Loyalty rewards

4. **Analytics Dashboard**
   - Revenue tracking
   - Order pipeline
   - Customer insights
   - Performance metrics

5. **Additional Services**
   - SEO optimization ($100/month)
   - Content updates ($50/month)
   - Social media management ($200/month)
   - Google Ads management ($300/month)

---

**Built for Arizona contractors, by Arizona Contractor Webs** 🏗️
