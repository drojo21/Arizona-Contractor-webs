# 🏗️ Arizona Contractor Webs

**Professional website and payment processing system for Arizona contractors**

A complete solution that accepts upfront payments, automatically generates custom website templates, and delivers them via email. Built specifically for serving newly licensed contractors across Arizona.

[![Node.js](https://img.shields.io/badge/Node.js-18+-green.svg)](https://nodejs.org/)
[![Square API](https://img.shields.io/badge/Square-Payment%20API-blue.svg)](https://developer.squareup.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## 🌟 Features

- ✅ **Professional Marketing Website** - Beautiful, responsive design showcasing your services
- 💳 **Square Payment Integration** - Secure upfront payment processing
- 🤖 **Automated Template Generation** - Custom bolt.new templates for each trade type
- 📧 **Email Automation** - Automatic delivery of templates and order notifications
- 🎨 **Trade-Specific Designs** - Custom colors and services for 10+ contractor types
- 📱 **Mobile-Responsive** - Perfect on all devices
- 🔒 **Secure** - PCI-compliant payment processing through Square

## 💰 Services & Pricing

- **Website Only**: $250
- **Social Media Setup**: $120
- **Complete Package**: $370 (Website + Social Media)

## 🚀 Quick Start

### Prerequisites

- Node.js 18 or higher
- Square Developer account (free)
- Gmail account or SMTP email service
- Domain name (for production deployment)

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/yourusername/arizona-contractor-webs.git
cd arizona-contractor-webs

# 2. Install dependencies
npm install

# 3. Configure environment variables
cp .env .env.local
# Edit .env.local with your credentials

# 4. Start development server
npm run dev
```

### Configuration

Your `.env` file is already set up with your Square Location ID: `LC95Y4243HZKF`

You need to add:
1. **Square Access Token** - Get from [Square Developer Dashboard](https://developer.squareup.com/apps)
2. **Gmail App Password** - Generate at [Google App Passwords](https://myaccount.google.com/apppasswords)

## 📚 Documentation

| Document | Description |
|----------|-------------|
| [START-HERE.md](START-HERE.md) | Welcome guide & quick overview |
| [SETUP-GUIDE.md](SETUP-GUIDE.md) | Complete setup instructions |
| [ARCHITECTURE.md](ARCHITECTURE.md) | System architecture & workflow |
| [TROUBLESHOOTING.md](TROUBLESHOOTING.md) | Problem-solving guide |
| [FILES-OVERVIEW.txt](FILES-OVERVIEW.txt) | Complete package contents |

## 🏗️ System Architecture

```
Customer → Website → Payment Server → Square Payment
                    ↓
            Generate Template → Email Customer
                    ↓
            Notify Admin → Build Website → Deliver
```

## 📁 Project Structure

```
arizona-contractor-webs/
├── 🌐 arizona-contractor-webs.html    # Marketing website
├── ⚙️  payment-server.js              # Backend server
├── 📦 package.json                    # Dependencies
├── 🔧 .env                           # Configuration (not in repo)
├── 📚 Documentation files            # Guides and help
└── 🚀 quick-start.sh                 # Setup script
```

## 🛠️ Technology Stack

- **Frontend**: HTML, CSS, JavaScript (Vanilla)
- **Backend**: Node.js, Express
- **Payment**: Square Payments API
- **Email**: Nodemailer (supports Gmail, SendGrid, AWS SES, Mailgun)
- **Template Generation**: Custom bolt.new integration

## 🔧 Development

```bash
# Start development server (auto-restart)
npm run dev

# Start production server
npm start

# Test email configuration
node -e "require('./payment-server.js')"
```

## 🌐 Deployment

### Recommended Setup

- **Frontend**: Netlify, Vercel, or static hosting
- **Backend**: Heroku, DigitalOcean, or AWS
- **Database** (optional): MongoDB, PostgreSQL

### Quick Deploy to Heroku

```bash
heroku create arizona-contractor-webs
git push heroku main
heroku config:set SQUARE_ACCESS_TOKEN=your_token
heroku config:set SQUARE_LOCATION_ID=LC95Y4243HZKF
# ... set other environment variables
```

## 🎨 Supported Trade Types

The system automatically generates custom templates for:

- Masonry
- Plumbing
- Electrical
- HVAC
- Carpentry
- Painting
- Roofing
- Landscaping
- Flooring
- Concrete
- And more...

Each trade gets custom colors, service descriptions, and industry-specific designs.

## 📧 Email Templates

Automated emails include:
- Order confirmation to customer
- Custom bolt.new template with full instructions
- Admin notification with customer details
- Professional formatting and branding

## 🔒 Security

- ✅ Environment variables for all sensitive data
- ✅ HTTPS enforced in production
- ✅ Square webhook signature verification
- ✅ Input validation and sanitization
- ✅ CORS configuration
- ✅ Rate limiting on API endpoints

## 🧪 Testing

### Test Payment Flow (Sandbox)

1. Set `SQUARE_ENVIRONMENT=sandbox` in `.env`
2. Use Square test card: `4111 1111 1111 1111`
3. Any CVV, future expiration date
4. Test complete order flow

## 📊 Monitoring

Recommended tools:
- **Uptime**: UptimeRobot (free)
- **Errors**: Sentry
- **Analytics**: Google Analytics 4
- **Logs**: Papertrail or LogDNA

## 🤝 Contributing

This is a private business project. For inquiries, contact:
- Email: luisrojosmasonry@gmail.com
- Phone: +1 520-461-3937

## 📄 License

MIT License - See [LICENSE](LICENSE) file for details

## 🙏 Acknowledgments

- Square for payment processing
- Bolt.new for website templates
- Node.js community for excellent packages

## 📞 Support

For questions or issues:
1. Check [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
2. Review [SETUP-GUIDE.md](SETUP-GUIDE.md)
3. Email: luisrojosmasonry@gmail.com

## 🗺️ Roadmap

- [ ] Customer dashboard for order tracking
- [ ] Website preview before payment
- [ ] Additional trade types
- [ ] Referral program
- [ ] SEO service upsell
- [ ] Social media management packages
- [ ] Multi-language support

## 📈 Business Model

**Target Market**: Newly licensed contractors in Arizona who need professional websites

**Value Proposition**: 
- Affordable ($250 vs $2000+ traditional web design)
- Fast delivery (3-5 days)
- Trade-specific designs
- Complete online presence solution

**Marketing Channels**:
- Arizona contractor registry databases
- Local contractor associations
- Google Ads
- Social media marketing

---

**Built with ❤️ for Arizona Contractors**

*Helping contractors establish professional online presence since 2025*
