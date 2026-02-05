# Quick Start Guide

## 🚀 Get Started in 60 Seconds

### 1. Open the Generator
Double-click `index.html` in this folder → opens in your browser

### 2. Load the TAFE SA Preset
- Select **"Implementation (TAFE SA) - 13 slides"** from Preset dropdown
- This loads all pre-configured clickable areas

### 3. Upload Your SVG Slides
- Click **"Upload SVGs (ordered by slide)"**
- Select your 13 SVG files (Slide 1 through Slide 13)
- ✅ Status will show "13 file(s) selected"

### 4. Set Your Tenant
- In **"Tenant Subdomain"** field, enter your client name:
  - `tafesa` (default)
  - `tafensw`
  - `university`
  - etc.
- All tool links will automatically update to use your subdomain

### 5. Generate Your Page
- Click **"Preview"** to test in new tab
- Click **"Generate HTML"** to download

### 6. Upload to HubSpot
- Go to HubSpot → Marketing → Files
- Upload the generated `.html` file
- Share the file URL with your client

---

## 🐛 Debug Overlay Issues

If clickable areas aren't working correctly:

1. Check **"Include debug tool"** (enabled by default)
2. Generate/Preview your page
3. Look for **"Debug Overlays"** button (bottom-right)
4. Click it to enable debug mode
5. Hover over any clickable area:
   - Green box = Navigation (Next/Back)
   - Purple box = Video
   - Orange box = External link
6. Click the debug box to **copy coordinates**
7. Send me:
   - Slide number
   - Copied coordinates
   - What should happen when clicked

I'll update the preset and send you the fixed version.

---

## 📋 Preset Details: TAFE SA Implementation

### Slide Count: 13
1. Title slide
2. Compress Tools to NCC
3. Foundational Tools
4. Embed Tools
5. Playlists
6. Real Life vs Code
7. Treasure Hunt
8. Best Practices
9. Student Presentation
10. Specblocks
11. Safety
12. Critical Thinking
13. Closing slide

### Pre-configured Elements:
- ✅ All Next/Back buttons
- ✅ All video overlays (HubSpot CDN)
- ✅ All external tool links (with query params)
- ✅ GIF overlays (where applicable)

---

## 💡 Tips

**No SVGs yet?**
- Still click Preview! You'll see placeholder slides with all overlays working
- Perfect for testing the structure before graphics are ready

**Multiple Clients?**
- Generate once per client
- Just change tenant subdomain each time
- Same SVGs, different links

**Need different videos?**
- Use the **"Advanced: overrides"** section
- Paste JSON to override video URLs
- Example in `README.md`

**Testing locally?**
- Generated HTML works offline
- Videos need internet connection
- External links won't track locally (needs HubSpot domain)

---

## ❓ FAQ

**Q: Do I need to install anything?**  
A: No! Just open `index.html` in any modern browser.

**Q: Can I edit the preset coordinates?**  
A: Yes, but let me do it. Use Debug Tool to report issues, I'll fix the preset.

**Q: What if I have more/less than 13 slides?**  
A: Upload any number of SVGs. Preset overlays apply to matching slide numbers. Extra slides have no overlays (add manually via JSON).

**Q: Can I use this without HubSpot?**  
A: Yes! Generated pages work anywhere. HubSpot Portal ID is optional (only for tracking).

**Q: How big will the file be?**  
A: Depends on SVG size. Typical: 2-8 MB for 13 slides with embedded SVGs.

**Q: Can I host on S3/Netlify/GitHub Pages?**  
A: Absolutely! It's just static HTML. Upload anywhere.

---

## 🆘 Need Help?

1. Check `README.md` for detailed docs
2. Check `TESTING.md` for troubleshooting
3. Use Debug Tool to inspect overlays
4. Contact developer with:
   - Browser version
   - Console errors (F12 → Console)
   - Debug coordinates of problem areas

---

## Next Steps

After you're comfortable with the basics:
- Explore **Advanced: overrides** for custom configs
- Request additional presets (Activation, other clients)
- Suggest workflow improvements

Happy generating! 🎉
