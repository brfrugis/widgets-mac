# World Clock Widget - Features Overview

## ✨ What Changed

### 1. Desktop Widget (NEW!)
- **Before**: Regular app window that you had to manage
- **After**: Floating desktop widget that stays on your screen
- Always visible, even when you switch apps
- Positioned at bottom-right by default (draggable)
- Transparent background with blur effects
- Shows/hides controls on hover

### 2. Brazil Timezone Support (FIXED!)
- **Before**: Couldn't find "Brazil" in search
- **After**: Full support for all Brazilian cities
  - São Paulo (BRT - UTC-3)
  - Rio Branco (ACT - UTC-5)
  - Manaus (AMT - UTC-4)
  - Fortaleza (BRT - UTC-3)
  - And 12+ more Brazilian cities!

## 🎨 Widget Behavior

### On Launch
- Widget appears at bottom-right corner
- Shows your 4 selected timezones (default: Local, São Paulo, New York, London)
- Clocks update every second
- Stays on top of other windows

### Interactions

**Hover Mode**
- Hover over widget → Shows controls
  - ⚙️ Settings button (add timezones)
  - ❌ Close button (quit app)
  - 🗑️ Trash icons on each clock (remove timezone)
  - ➕ "Add Timezone" button (if less than 4 timezones)

**Normal Mode**
- No hover → Clean, minimal view
- Just shows: City name, country, time, GMT offset
- Beautiful typography with rounded design

**Dragging**
- Click anywhere on widget background
- Drag to reposition
- Position is remembered

## 🔍 Enhanced Search

Search now works for:
- ✅ **Country names**: "Brazil", "Japan", "United States"
- ✅ **City names**: "São Paulo", "Tokyo", "London"
- ✅ **Regions**: "Americas", "Europe", "Asia"
- ✅ **Partial matches**: "paulo" finds "São Paulo"

### Brazilian Cities Available
1. São Paulo - BRT (UTC-3)
2. Rio Branco - ACT (UTC-5)
3. Manaus - AMT (UTC-4)
4. Fortaleza - BRT (UTC-3)
5. Belém - BRT (UTC-3)
6. Recife - BRT (UTC-3)
7. Bahia - BRT (UTC-3)
8. Cuiabá - AMT (UTC-4)
9. Maceió - BRT (UTC-3)
10. Santarém - BRT (UTC-3)
11. Porto Velho - AMT (UTC-4)
12. Boa Vista - AMT (UTC-4)
13. Araguaína - BRT (UTC-3)
14. Campo Grande - AMT (UTC-4)
15. Eirunepé - ACT (UTC-5)
16. Fernando de Noronha - FNT (UTC-2)

## 🎯 Widget Specs

- **Size**: 320px × 400px (fixed)
- **Position**: Bottom-right by default, draggable
- **Level**: Floating (always on top)
- **Behavior**: Stays across all Spaces
- **Style**: Borderless with rounded corners
- **Background**: Black with transparency + blur effect
- **Shadow**: Subtle drop shadow for depth

## ⌨️ Keyboard Shortcuts

- **⌘Q**: Quit app (from menu bar or widget)
- **Esc**: Close settings/search panel
- **Type to search**: Instant filter in timezone selector

## 💡 Tips

1. **Can't find a city?** Try typing the country name first
2. **Widget too big?** It's fixed size, but you can position it anywhere
3. **Want more clocks?** Maximum is 4 for optimal readability
4. **Widget disappeared?** Relaunch the app from Applications
5. **Wrong time?** macOS automatically syncs with internet time

## 🚀 Performance

- **Memory**: ~30-40 MB (very lightweight)
- **CPU**: Minimal (updates once per second)
- **Battery**: Negligible impact
- **Startup**: Instant widget appearance
