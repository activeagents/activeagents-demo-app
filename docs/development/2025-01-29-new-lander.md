# New Landing Page Implementation

**Date:** 2025-01-29
**Branch:** `feature/new-lander`
**PR:** https://github.com/activeagents/activeagents-demo-app/pull/5

## Overview

Complete reinitialization of the activeagents.ai application with a new landing page using the Evil Martians devtool-template.

## Changes Made

### Tech Stack

- **Framework:** Rails 8.0.1
- **Database:** PostgreSQL
- **Frontend:** Inertia.js with React
- **Styling:** Evil Martians LaunchKit template + Tailwind CSS 4
- **Background Jobs:** Solid Queue
- **Caching:** Solid Cache
- **WebSockets:** Solid Cable
- **Deployment:** Kamal

### New Files

| File | Purpose |
|------|---------|
| `app/controllers/landing_controller.rb` | Serves the static landing page |
| `app/controllers/dashboard_controller.rb` | Inertia React dashboard |
| `app/views/layouts/landing.html.erb` | Landing page layout with template styles |
| `app/views/landing/index.html.erb` | Landing page content with pricing |
| `app/javascript/inertia.jsx` | Inertia React entry point |
| `app/javascript/pages/Dashboard.jsx` | React dashboard component |
| `public/landing/` | Evil Martians template assets (CSS, JS, fonts, images) |

### Dependencies Added

**Ruby Gems:**
- `inertia_rails` - Inertia adapter for Rails
- `activeagent` (from github.com/activeagents/activeagent) - AI agent framework

**NPM Packages:**
- `react` / `react-dom` - React 19
- `@inertiajs/react` - Inertia React adapter
- `tailwindcss` / `@tailwindcss/cli` - Tailwind CSS 4

## Pricing Tiers

### 1. activeagent.dev (Free)
- Full framework access
- All providers supported
- Community support
- GitHub discussions
- MIT License

### 2. activeagent.pro ($19.99/mo)
- Everything in Dev
- Priority email support
- Private Discord channel
- Early access to features
- Premium documentation

### 3. activeagent enterprise ($2.5K+/mo)
- Weekly strategy calls
- Priority async support
- Expert feedback & recommendations
- Code review
- Hiring & client support
- Advisory (no hands-on coding)

Target audience: CTOs, lean teams, agencies offering AI development services

## Routes

```ruby
root "landing#index"           # Static landing page
get "dashboard", to: "dashboard#index"  # Inertia React dashboard
```

## Next Steps

- [ ] Add authentication (Devise or similar)
- [ ] Set up Stripe for Pro tier subscriptions
- [ ] Create user dashboard with agent management
- [ ] Add documentation pages
- [ ] Create custom branding assets (logo, favicon, social image)
- [ ] Set up email collection for waitlist

## Related Links

- [Evil Martians DevTool Template](https://github.com/evilmartians/devtool-template)
- [Inertia.js Rails](https://inertia-rails.dev/)
- [Active Agent Repository](https://github.com/activeagents/activeagent)
