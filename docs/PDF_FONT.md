# PDF Font Configuration

## Available Fonts

Fonts used for PDF rendering are provided by the Docker container and
managed by **fontconfig**.

You can inspect the installed fonts by running:

``` bash
fc-list
```

Most custom fonts are located at:

``` bash
/ usr / share / fonts / truetype / custom /
```

Example output:

``` text
/usr/share/fonts/truetype/custom/Battambang-Regular.ttf: Battambang:style=Regular
/usr/share/fonts/truetype/custom/Battambang-Bold.ttf: Battambang:style=Bold
```

## Font Family Resolution

When rendering PDFs, **fontconfig selects fonts in alphabetical order by
family name**.

Because of this:

-   `Battambang` comes **before** `Moul`
-   If multiple Khmer fonts are installed, an unexpected font may be
    selected
-   This can cause incorrect font weight or style in PDFs

For example:

-   Using `Siemreap` may still result in `Moul` being selected first
-   This leads to unexpected font styles when rendering PDFs

## Recommended Font Usage

To avoid font conflicts:

-   Prefer font families that appear **earlier alphabetically**
-   Explicitly specify the font family (e.g. `Battambang`)
-   Ensure all font variants (Regular, Bold, Light, etc.) are installed

## Troubleshooting

After adding or changing fonts, always rebuild the font cache:

``` bash
fc-cache -f -v
```

Then verify again with:

``` bash
fc-list | grep Battambang
```

This ensures the correct font family and styles are available for PDF
rendering.
