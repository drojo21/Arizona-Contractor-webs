#!/bin/bash

# Arizona Contractor Webs - Quick Start Script
# This script helps set up the application quickly

echo "================================================"
echo "Arizona Contractor Webs - Quick Start Setup"
echo "================================================"
echo ""

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed!"
    echo "Please install Node.js from https://nodejs.org/"
    exit 1
fi

echo "✅ Node.js version: $(node --version)"
echo ""

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo "❌ npm is not installed!"
    exit 1
fi

echo "✅ npm version: $(npm --version)"
echo ""

# Install dependencies
echo "📦 Installing dependencies..."
npm install

if [ $? -ne 0 ]; then
    echo "❌ Failed to install dependencies"
    exit 1
fi

echo "✅ Dependencies installed successfully"
echo ""

# Check if .env file exists
if [ ! -f .env ]; then
    echo "⚠️  No .env file found. Creating from example..."
    cp .env.example .env
    echo "✅ Created .env file"
    echo ""
    echo "🔧 IMPORTANT: Edit .env file with your actual credentials:"
    echo "   - Square Access Token"
    echo "   - Square Location ID"
    echo "   - Email SMTP settings"
    echo "   - Base URL"
    echo ""
    read -p "Press Enter when you've updated .env file..."
else
    echo "✅ .env file found"
fi

echo ""
echo "================================================"
echo "Setup Complete! 🎉"
echo "================================================"
echo ""
echo "Next steps:"
echo ""
echo "1. Make sure you've configured your .env file"
echo "2. Start the development server:"
echo "   npm run dev"
echo ""
echo "3. Or start in production mode:"
echo "   npm start"
echo ""
echo "4. Deploy arizona-contractor-webs.html to your web hosting"
echo ""
echo "5. Update the API endpoint in the HTML file to point to your server"
echo ""
echo "📚 Read SETUP-GUIDE.md for detailed instructions"
echo ""
echo "================================================"
