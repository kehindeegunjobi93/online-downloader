# Online Downloader 🚀

**Online Downloader** is a fast, privacy-focused media downloader designed to help you save publicly accessible videos, audio, and media without ads, trackers, popups, or paywalls. 

Simply paste a link, choose your preferred format (video, audio-only, or mute), and save your media directly.

---

## ✨ Features

- 🎥 **High Quality Downloads**: Supports downloading YouTube, Twitter/X, TikTok, Instagram, Reddit, SoundCloud, and many other services.
- ⚡ **No Ads or Trackers**: Clean, distraction-free interface focused purely on functionality.
- 🎵 **Audio Extraction**: Easily extract MP3/AAC audio from video clips.
- 📱 **Fully Responsive**: Works seamlessly on Mobile (iOS / Android) and Desktop browsers.
- 🐳 **Docker & Cloud Ready**: Out-of-the-box containerized setup ready for platforms like Render, Railway, or self-hosted Docker environments.

---

## 🛠️ Tech Stack & Architecture

- **Frontend**: SvelteKit / TypeScript / Web Components
- **Backend API**: Node.js microservice powered by `ffmpeg` and extraction engine
- **Deployment**: Unified Docker Multi-stage build (`Dockerfile` & `render.yaml`)

---

## 🚀 Quick Start (Local Development)

### Prerequisites

- Node.js >= 20
- `pnpm` >= 9 (`npm i -g pnpm`)
- `ffmpeg` installed on your system

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/kehindeegunjobi93/online-downloader.git
   cd online-downloader
   ```

2. **Install dependencies:**
   ```bash
   pnpm install
   ```

3. **Run using Docker Compose (Recommended):**
   ```bash
   docker compose up -d
   ```
   Open `http://localhost:7575` in your web browser.

---

## ☁️ Deployment

### 1-Click Deployment on Render

This repository includes a `render.yaml` blueprint.

1. Sign into **[Render Dashboard](https://dashboard.render.com)**.
2. Click **New +** -> **Blueprint**.
3. Connect `kehindeegunjobi93/online-downloader`.
4. Click **Apply**.

---

## 📜 License

This project is open-source under the [AGPL-3.0 License](LICENSE). Built upon open-source media processing tools and the Cobalt extraction core.
