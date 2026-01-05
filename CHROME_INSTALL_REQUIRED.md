# Chrome Installation Required for PDF Generation

## Overview
PDF generation requires Chrome or Chromium to convert HTML to PDF using the `chromedp` library. This is a production-ready approach used by many applications.

## For Local Development

Chrome is not currently installed on your system. Install it once to enable PDF generation:

## Quick Fix - Install Chrome

### Option 1: Direct Download (Fastest)
1. Download Chrome from: https://www.google.com/chrome/
2. Install the application
3. Restart the backend server
4. PDF generation will work immediately

### Option 2: Using Homebrew
```bash
brew install --cask google-chrome
```

Then restart the server:
```bash
# Kill existing server
lsof -ti:8080 | xargs kill -9

# Start server
cd server
go run .
```

## Temporary Workaround - HTML Preview

While Chrome is being installed, you can view the curriculum in HTML format:

### From Browser
Add `?preview=html` to the PDF URL:
```
http://localhost:8080/api/regulation/4/pdf?preview=html
```

This will show the fully formatted curriculum in your browser, which you can:
- Print to PDF using your browser's print function (Cmd+P → Save as PDF)
- Save as HTML file
- Copy content as needed

### Example URLs
- **PDF (requires Chrome)**: `http://localhost:8080/api/regulation/4/pdf`
- **HTML Preview**: `http://localhost:8080/api/regulation/4/pdf?preview=html`

## After Installing Chrome

1. Verify installation:
```bash
# Should show Chrome location
ls -la "/Applications/Google Chrome.app"
```

2. Restart backend server

3. Test PDF generation - it should work now!

## Why Chrome is Needed

The PDF generator uses:
- **chromedp** - Headless Chrome automation
- Chrome's built-in PDF print functionality
- Better CSS/HTML rendering than alternatives
- Native support for modern web standards

## Alternative: Manual Conversion

If you prefer not to install Chrome:

1. Get HTML preview: `http://localhost:8080/api/regulation/4/pdf?preview=html`
2. Open in any browser
3. Print to PDF (Cmd+P on Mac, Ctrl+P on Windows/Linux)
4. Choose "Save as PDF"

This gives you a PDF without installing Chrome on the server!

## For Production Deployment

### Docker Deployment (Recommended)

Since this application will be deployed using Docker, Chrome/Chromium can be included in the container. Add to your Dockerfile:

#### Option 1: Alpine-based (Smaller image)
```dockerfile
FROM golang:1.21-alpine

# Install Chromium and dependencies
RUN apk add --no-cache \
    chromium \
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont

# Set Chrome path for chromedp
ENV CHROME_BIN=/usr/bin/chromium-browser
ENV CHROME_PATH=/usr/bin/chromium-browser

# Copy application files
WORKDIR /app
COPY . .

# Build and run your application
RUN go build -o server .
CMD ["./server"]
```

#### Option 2: Ubuntu/Debian-based (More compatible)
```dockerfile
FROM golang:1.21

# Install Chrome
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    ca-certificates \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

# Copy application files
WORKDIR /app
COPY . .

# Build and run your application
RUN go build -o server .
CMD ["./server"]
```

### Benefits of Docker + chromedp for Production

✅ **One-time setup** - Chrome installed in container, works everywhere  
✅ **Consistent environment** - Same Chrome version across dev/staging/production  
✅ **Isolated** - Chrome runs inside container, no conflicts with host system  
✅ **Complex rendering** - Perfect HTML/CSS support for curriculum documents  
✅ **Zero manual setup** - Automated deployment, no server configuration needed  

### Local Server Deployment

If deploying directly to a server (non-Docker):

**Ubuntu/Debian:**
```bash
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo "deb http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google.list
sudo apt-get update
sudo apt-get install -y google-chrome-stable
```

**CentOS/RHEL:**
```bash
wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
sudo yum localinstall google-chrome-stable_current_x86_64.rpm -y
```

