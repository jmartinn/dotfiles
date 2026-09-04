# Official Omarchy wallpapers

Current research snapshot: 2026-09-02 (Europe/Madrid)

Prior snapshot retained below: 2026-08-17

## Conclusion

The canonical source is now the official [`omacom/omarchy`](https://github.com/omacom/omarchy) repository. The former `basecamp/omarchy` address redirects to it; GitHub's official [repository API response for the old address](https://api.github.com/repos/basecamp/omarchy) reports `full_name: omacom/omarchy`. The default branch remains `quattro`.

Omarchy's pinned [theming documentation](https://github.com/omacom/omarchy/blob/7eca64e2683d2a4d4620f36164f001693ae6a5b7/docs/theming.md) defines first-party themes as `themes/<name>/` in the source tree and says they can ship a `backgrounds/` directory; its [backgrounds manual](https://github.com/omacom/omarchy/blob/7eca64e2683d2a4d4620f36164f001693ae6a5b7/manual/39-backgrounds.md) likewise says each theme has its own set of backgrounds. Applying that definition, the complete current bundled first-party wallpaper scope is every supported image blob directly under `themes/<theme>/backgrounds/`.

At default-branch commit [`7eca64e2683d2a4d4620f36164f001693ae6a5b7`](https://github.com/omacom/omarchy/commit/7eca64e2683d2a4d4620f36164f001693ae6a5b7), the pinned recursive [Git tree `214e524676fc5d4ab1510066714f17a085d6a1ac`](https://api.github.com/repos/omacom/omarchy/git/trees/214e524676fc5d4ab1510066714f17a085d6a1ac?recursive=1) is complete (`truncated: false`) and contains:

- 92 wallpaper paths in 22 bundled themes
- 13 JPG files (25,883,622 bytes) and 79 WebP files (28,673,946 bytes); no PNG files remain
- 54,557,568 bytes total (52.03 MiB)
- 91 unique Git blobs; `matte-black/2-dot-hands.webp` and `vantablack/0-dot-hands.webp` remain byte-identical

The scope deliberately excludes previews, unlock-screen art, application icons, community themes, and historical assets absent from the current default branch.

## What happened to `1-quattro.jpg`

It was not removed without a successor. On 2026-08-19, official commit [`a4219f8f4a13b833351e6e36510e421fd1fe8e75`](https://github.com/omacom/omarchy/commit/a4219f8f4a13b833351e6e36510e421fd1fe8e75), “Store theme backgrounds as webp,” converted 79 bundled backgrounds to WebP while retaining their pixel dimensions. The commit removed the `.jpg` path and added the same logical asset as:

- Current repository path: `themes/tokyo-night/backgrounds/1-quattro.webp`
- Current branch URL: <https://raw.githubusercontent.com/omacom/omarchy/quattro/themes/tokyo-night/backgrounds/1-quattro.webp>
- Snapshot-pinned URL: <https://raw.githubusercontent.com/omacom/omarchy/7eca64e2683d2a4d4620f36164f001693ae6a5b7/themes/tokyo-night/backgrounds/1-quattro.webp>
- Size at this snapshot: 625,422 bytes
- Git blob: [`af001763e71cbe30c25f7057dc075fccc8687a68`](https://api.github.com/repos/omacom/omarchy/git/blobs/af001763e71cbe30c25f7057dc075fccc8687a68)

The history before that conversion is unchanged:

1. Commit [`3da9eaf61cf54aa6c238b5f35b8345df589f34df`](https://github.com/omacom/omarchy/commit/3da9eaf61cf54aa6c238b5f35b8345df589f34df) introduced the Vulturetone Quattro background as `2-quattro.jpg`.
2. Commit [`9c9e082954b366bb37e250edf7874856b4172173`](https://github.com/omacom/omarchy/commit/9c9e082954b366bb37e250edf7874856b4172173) renamed it to `1-quattro.jpg`.
3. Commit [`ec779715bda6699cd848b3a859f580d8928c3ae6`](https://github.com/omacom/omarchy/commit/ec779715bda6699cd848b3a859f580d8928c3ae6) re-encoded oversized images without changing resolution.
4. Commit [`a4219f8f4a13b833351e6e36510e421fd1fe8e75`](https://github.com/omacom/omarchy/commit/a4219f8f4a13b833351e6e36510e421fd1fe8e75) changed its storage format and filename to `1-quattro.webp`.

## Complete current inventory

Every filename below is relative to `themes/<theme>/backgrounds/` in the snapshot commit. A pinned URL is formed as:

```text
https://raw.githubusercontent.com/omacom/omarchy/7eca64e2683d2a4d4620f36164f001693ae6a5b7/themes/<theme>/backgrounds/<filename>
```

- **catppuccin** (4): `1-totoro.webp`, `2-waves.webp`, `3-blue-eye.webp`, `omarchy.webp`
- **catppuccin-latte** (2): `1-color-fade.webp`, `omarchy.webp`
- **ethereal** (3): `1-cosmic.webp`, `2-meadow.webp`, `omarchy.webp`
- **everforest** (2): `1-tree-tops.webp`, `omarchy.webp`
- **flexoki-light** (2): `1-orb.webp`, `2-omarchy.webp`
- **gruvbox** (6): `1-the-backwater.jpg`, `2-flower-basket.webp`, `3-village-square.jpg`, `4-idyllic-procession.jpg`, `5-leaves.jpg`, `omarchy.webp`
- **hackerman** (3): `1-synth-scape.jpg`, `2-geometric.webp`, `omarchy.webp`
- **kanagawa** (2): `1-kanagawa.jpg`, `omarchy.webp`
- **last-horizon** (4): `1-eyes-wide.webp`, `2-blink.webp`, `3-bokeh.webp`, `4-new-horizons.jpg`
- **lumon** (3): `01-united-in-severance.webp`, `02-opinions-equally.webp`, `omarchy.webp`
- **lupine** (6): `01-cherry-blossom-bokeh.webp`, `02-cherry-blossom-white.webp`, `03-pastel-clouds.webp`, `04-elegant-blue-wave.webp`, `05-abstract-wave.webp`, `06-omarchy.webp`
- **matte-black** (4): `0-ship-at-sea.jpg`, `1-dark-waters.webp`, `2-dot-hands.webp`, `omarchy.webp`
- **miasma** (3): `01-nature-of-fear.webp`, `02-crowned.webp`, `omarchy.webp`
- **nord** (4): `0-black-moon.jpg`, `1-city-view.webp`, `2-night-hawks.webp`, `omarchy.webp`
- **osaka-jade** (4): `1-glowing-city.webp`, `2-shaded-entrance.webp`, `3-mountain-moon.webp`, `omarchy.webp`
- **retro-82** (9): `1-in-the-groove.webp`, `2-dusk-guardian.webp`, `3-glassy-lines.webp`, `4-gateway.webp`, `5-zen-boat.webp`, `6-abstract-pyramids.webp`, `7-the-journey.webp`, `8-glitter-glass.webp`, `omarchy.webp`
- **ristretto** (5): `0-launch.webp`, `1-color-curves.webp`, `2-coffee-beans.jpg`, `3-industrial-moon.webp`, `omarchy.webp`
- **rose-pine** (4): `1-funky-shapes.webp`, `2-dot-map.webp`, `3-omarchy-plants.webp`, `omarchy.webp`
- **solitude** (5): `1-on-pole.webp`, `2-wreakage.webp`, `3-climb.jpg`, `4-ether.webp`, `5-eyed.jpg`
- **tokyo-night** (8): `0-winding-road.webp`, `1-quattro.webp`, `2-swirl-buck.webp`, `3-sunset-lake.webp`, `4-omakub.webp`, `5-oma-cityscape.jpg`, `6-oma.webp`, `omarchy.webp`
- **vantablack** (5): `0-dot-hands.webp`, `1-twisted-stairs.webp`, `2-layers-deep.webp`, `3-layers-stacked.webp`, `omarchy.webp`
- **white** (4): `1-white.webp`, `2-white.webp`, `3-white.webp`, `omarchy.webp`

## Change since the 2026-08-17 snapshot

| Snapshot | Commit | Themes | Paths | Formats | Total bytes |
|---|---|---:|---:|---|---:|
| 2026-08-17 | [`f32ebbdb730c4e8fe11e4046cef4267e466264ea`](https://github.com/omacom/omarchy/commit/f32ebbdb730c4e8fe11e4046cef4267e466264ea) | 22 | 92 | 61 JPG, 31 PNG | 112,313,747 |
| 2026-09-02 | [`7eca64e2683d2a4d4620f36164f001693ae6a5b7`](https://github.com/omacom/omarchy/commit/7eca64e2683d2a4d4620f36164f001693ae6a5b7) | 22 | 92 | 13 JPG, 79 WebP | 54,557,568 |

No themes or wallpaper slots disappeared between these snapshots. Official commits [`ec779715`](https://github.com/omacom/omarchy/commit/ec779715bda6699cd848b3a859f580d8928c3ae6) and [`a4219f8f`](https://github.com/omacom/omarchy/commit/a4219f8f4a13b833351e6e36510e421fd1fe8e75) optimized the assets and changed most extensions. The exact total fell by 57,756,179 bytes (about 51.4%).

## Archived Synthwave84 extra

The official [`omacom/omarchy-synthwave84-theme`](https://github.com/omacom/omarchy-synthwave84-theme) repository is archived and separate from the Omarchy distribution. Its default `master` branch remains at commit [`283dbcf17c3a500b7d3ddfce081e1dc2b3641172`](https://github.com/omacom/omarchy-synthwave84-theme/commit/283dbcf17c3a500b7d3ddfce081e1dc2b3641172), and it contains one wallpaper:

- Path: `backgrounds/1-synthwave-84.jpg`
- Branch URL: <https://raw.githubusercontent.com/omacom/omarchy-synthwave84-theme/master/backgrounds/1-synthwave-84.jpg>
- Snapshot-pinned URL: <https://raw.githubusercontent.com/omacom/omarchy-synthwave84-theme/283dbcf17c3a500b7d3ddfce081e1dc2b3641172/backgrounds/1-synthwave-84.jpg>
- Size: 7,232,828 bytes
- Git blob: [`2adaecf7bbe966a8e4d0733b32308e04959a97a0`](https://api.github.com/repos/omacom/omarchy-synthwave84-theme/git/blobs/2adaecf7bbe966a8e4d0733b32308e04959a97a0)

Decision: it does **not** belong in the current bundled first-party scope. It is an official historical extra, so include it only in an explicitly broader “official current bundle plus archived extras” collection. The current Omarchy tree contains no `synthwave84` or `synthwave-84` path.

## Reproducible enumeration

Resolve the default branch through GitHub's official API, pin its commit, require a complete tree response, and then select image blobs in first-party background directories:

```bash
repo=omacom/omarchy
branch=$(gh api "repos/$repo" --jq .default_branch)
commit=$(gh api "repos/$repo/commits/$branch" --jq .sha)

gh api "repos/$repo/git/trees/$commit?recursive=1" \
  --jq 'if .truncated then error("GitHub tree response was truncated") else .tree[] | select(.type == "blob" and (.path | test("^themes/[^/]+/backgrounds/[^/]+\\.(jpg|jpeg|png|webp|avif)$"; "i"))) | [.path, .sha, .size] | @tsv end'
```

The live [recursive tree endpoint](https://api.github.com/repos/omacom/omarchy/git/trees/quattro?recursive=1) and [default-branch commit endpoint](https://api.github.com/repos/omacom/omarchy/commits/quattro) are the authoritative inputs. Preserve each `<theme>/` subdirectory when downloading because many themes reuse basenames such as `omarchy.webp`.
