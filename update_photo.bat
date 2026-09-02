@echo off
echo Updating photo in index.html from images folder...
node -e "
const fs = require('fs');
const path = require('path');
const dir = path.join(__dirname, 'images');
const candidates = ['photo.jpg', 'photo.jpeg', 'photo.png', 'photo.webp', 'photo.avif', 'photo.jfif'];
let targetFile = null;
for (const f of candidates) {
    const full = path.join(dir, f);
    if (fs.existsSync(full)) {
        targetFile = full;
        break;
    }
}
if (!targetFile) {
    // Check if any file in images
    const files = fs.readdirSync(dir).filter(x => !fs.statSync(path.join(dir, x)).isDirectory());
    if (files.length > 0) targetFile = path.join(dir, files[0]);
}
if (!targetFile) {
    console.log('No image found in images/ folder!');
    process.exit(1);
}
console.log('Found image:', targetFile);
const b64 = fs.readFileSync(targetFile).toString('base64');
const ext = path.extname(targetFile).slice(1).toLowerCase() || 'jpeg';
const dataUrl = 'data:image/' + (ext === 'jpg' ? 'jpeg' : ext) + ';base64,' + b64;
let html = fs.readFileSync(path.join(__dirname, 'index.html'), 'utf8');
html = html.replace(/const DEFAULT_IMAGE =\s*"[^"]*";/, 'const DEFAULT_IMAGE =\n    "' + dataUrl + '";');
html = html.replace(/src="data:image[^"]*"/, 'src="' + dataUrl + '"');
fs.writeFileSync(path.join(__dirname, 'index.html'), html, 'utf8');
console.log('Successfully updated index.html with ' + path.basename(targetFile) + '!');
"
pause
