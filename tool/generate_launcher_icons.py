"""Genera los iconos de launcher a partir del logo del producto."""

from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / 'assets' / 'img' / 'logo_stickyNotesEnglish.png'


def flatten(image: Image.Image) -> Image.Image:
    sample = image.convert('RGBA').getpixel((0, 0))
    background = Image.new('RGB', image.size, sample[:3])
    if image.mode in ('RGBA', 'LA'):
        background.paste(image, mask=image.split()[-1])
        return background
    return image.convert('RGB')


def save_resized(source: Image.Image, path: Path, size: int) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    resized = source.resize((size, size), Image.Resampling.LANCZOS)
    resized.save(path, format='PNG', optimize=True)


def save_inset(
    source: Image.Image,
    path: Path,
    canvas: int,
    color: tuple[int, int, int],
    scale: float,
) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    image = Image.new('RGB', (canvas, canvas), color)
    inner = int(canvas * scale)
    resized = source.resize((inner, inner), Image.Resampling.LANCZOS)
    offset = (canvas - inner) // 2
    image.paste(resized, (offset, offset))
    image.save(path, format='PNG', optimize=True)


def main() -> None:
    source = flatten(Image.open(SOURCE))
    background = source.getpixel((0, 0))
    print(f'Fondo: #{background[0]:02X}{background[1]:02X}{background[2]:02X}')

    android = ROOT / 'android' / 'app' / 'src' / 'main' / 'res'
    for folder, size in {
        'mipmap-mdpi': 48,
        'mipmap-hdpi': 72,
        'mipmap-xhdpi': 96,
        'mipmap-xxhdpi': 144,
        'mipmap-xxxhdpi': 192,
    }.items():
        save_resized(source, android / folder / 'ic_launcher.png', size)
        save_resized(source, android / folder / 'ic_launcher_round.png', size)

    for folder, size in {
        'mipmap-mdpi': 108,
        'mipmap-hdpi': 162,
        'mipmap-xhdpi': 216,
        'mipmap-xxhdpi': 324,
        'mipmap-xxxhdpi': 432,
    }.items():
        save_resized(source, android / folder / 'ic_launcher_foreground.png', size)

    ios = ROOT / 'ios' / 'Runner' / 'Assets.xcassets' / 'AppIcon.appiconset'
    for name, size in {
        'Icon-App-20x20@1x.png': 20,
        'Icon-App-20x20@2x.png': 40,
        'Icon-App-20x20@3x.png': 60,
        'Icon-App-29x29@1x.png': 29,
        'Icon-App-29x29@2x.png': 58,
        'Icon-App-29x29@3x.png': 87,
        'Icon-App-40x40@1x.png': 40,
        'Icon-App-40x40@2x.png': 80,
        'Icon-App-40x40@3x.png': 120,
        'Icon-App-60x60@2x.png': 120,
        'Icon-App-60x60@3x.png': 180,
        'Icon-App-76x76@1x.png': 76,
        'Icon-App-76x76@2x.png': 152,
        'Icon-App-83.5x83.5@2x.png': 167,
        'Icon-App-1024x1024@1x.png': 1024,
    }.items():
        save_resized(source, ios / name, size)

    macos = ROOT / 'macos' / 'Runner' / 'Assets.xcassets' / 'AppIcon.appiconset'
    for name, size in {
        'app_icon_16.png': 16,
        'app_icon_32.png': 32,
        'app_icon_64.png': 64,
        'app_icon_128.png': 128,
        'app_icon_256.png': 256,
        'app_icon_512.png': 512,
        'app_icon_1024.png': 1024,
    }.items():
        save_resized(source, macos / name, size)

    web = ROOT / 'web'
    save_resized(source, web / 'favicon.png', 32)
    save_resized(source, web / 'icons' / 'Icon-192.png', 192)
    save_resized(source, web / 'icons' / 'Icon-512.png', 512)
    save_resized(source, web / 'icons' / 'Icon-maskable-192.png', 192)
    save_resized(source, web / 'icons' / 'Icon-maskable-512.png', 512)

    windows_icon = ROOT / 'windows' / 'runner' / 'resources' / 'app_icon.ico'
    windows_icon.parent.mkdir(parents=True, exist_ok=True)
    source.save(
        windows_icon,
        format='ICO',
        sizes=[(16, 16), (32, 32), (48, 48), (256, 256)],
    )

    # Logo completo en el splash (no el icono adaptativo, que Android recorta).
    for folder, size in {
        'drawable-mdpi': 192,
        'drawable-hdpi': 288,
        'drawable-xhdpi': 384,
        'drawable-xxhdpi': 576,
        'drawable-xxxhdpi': 768,
    }.items():
        save_resized(source, android / folder / 'splash_logo.png', size)

    # Android 12+ enmascara el icono de arranque en un círculo (~66%).
    for folder, size in {
        'drawable-mdpi': 288,
        'drawable-hdpi': 432,
        'drawable-xhdpi': 576,
        'drawable-xxhdpi': 864,
        'drawable-xxxhdpi': 1152,
    }.items():
        save_inset(
            source,
            android / folder / 'splash_icon.png',
            size,
            background,
            0.56,
        )

    ios_launch = ROOT / 'ios' / 'Runner' / 'Assets.xcassets' / 'LaunchImage.imageset'
    save_resized(source, ios_launch / 'LaunchImage.png', 200)
    save_resized(source, ios_launch / 'LaunchImage@2x.png', 400)
    save_resized(source, ios_launch / 'LaunchImage@3x.png', 600)

    print('Iconos generados.')


if __name__ == '__main__':
    main()
