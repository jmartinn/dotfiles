# StreamCam cinematic setup

Tuned on 2026-09-15 in OBS 32.2.2 for the Logitech StreamCam, with a bright wall and daylight from the side. Native OBS filters only; no plugin or LUT dependencies.

## Everyday use

Select **Studio - Cinematic**. The original **Discord** scene remains a wide, ungraded comparison. Both share one camera source. The cinematic scene's transform is locked to prevent accidental movement.

For calls, start OBS Virtual Camera and choose **OBS Virtual Camera** in the call app. OBS Virtual Camera carries video; choose the microphone separately in the call app. Recording/streaming do not start automatically.

## Saved settings

- Camera and canvas: 1920×1080, 30 fps; NV12, Rec.709, limited range.
- Framing: crop left/right 160 px, top 80 px, bottom 100 px; scale the resulting 1600×900 image by 1.2. Original mirror orientation retained. This trades some source resolution for a tighter composition.
- Scene filter: built-in Color Correction v2, gamma +0.22, contrast +0.06, brightness −0.005, saturation −0.08, hue 0, opacity 1. The lift brightens face midtones without a strong color cast. Neutral multiply/add colors.
- Recording: Apple VT H.264 hardware encoder, Indistinguishable Quality (HQ), hybrid MOV; saved in Movies. Native recording verification reported quality 0.70, hardware encoding enabled, 1080p/30 H.264.
- Focus, exposure, and white balance retain the camera's existing automatic behavior. They were not locked with a separate hardware-control application. The look may need a gamma adjustment when lighting changes substantially.
- No artificial blur, extra sharpening, black bars, or beauty smoothing. The StreamCam already sharpens the image.

To adjust the look, right-click **Studio - Cinematic** in Scenes → Filters. Turn the color filter off for comparison. For changed lighting, start with gamma; avoid raising overall brightness aggressively. To reframe, unlock the source and use Transform → Edit Transform, then lock it again.

## Free physical improvements

Bring the camera closer to eye height, with only a slight downward angle. Keep the window a little in front of you and off to one side. A white surface on the darker side of your face can return some window light. Move the blue water container and loose panel outside the frame; keep some distance from the wall. These physical changes can improve the image more than additional filters. The preset cannot synthesize optical background separation or compensate fully for insufficient light.

## Restore on this Mac or another Mac

1. OBS → Scene Collection → Import → select `cinematic.json` from this directory. Switch to **Camera - Cinematic**. Import creates a separate named collection; it does not require replacing the live scene file.
2. OBS → Profile → Import → select this directory containing `basic.ini`, then choose **Camera - Cinematic**. On another Mac, set the recording folder to that account's Movies directory.
3. Open **Video Capture Device → Properties** and select the connected **Logitech StreamCam**. Confirm 1080p and 30 fps; device IDs are Mac/USB-port-specific.
4. Record a brief local test before an important call or recording.

These files are recovery exports. OBS's live settings remain in `~/Library/Application Support/obs-studio/`; this preset directory can be stowed independently without replacing OBS's live configuration. After deliberately retuning, export the scene collection/profile again to update the recovery copy.

## If the camera disappears

This Mac's original OBS source referenced `0x1200000046d0893`; the connected StreamCam was `0x200000046d0893`. Selecting the camera again in source Properties repairs that mismatch. Prefer the same USB port/hub arrangement. The preset does not automatically detect future device-ID changes.

If only Virtual Camera fails after an OBS update, check `systemextensionsctl list`. An old OBS extension waiting for removal on reboot is evidence of a pending system-extension transition; finish that reboot and retest. Do not reset every system extension or disable macOS protections.

## Implementation references

- [OBS native Color Correction](https://github.com/obsproject/obs-studio/blob/master/plugins/obs-filters/color-correction-filter.c)
- [OBS simple recording quality and hardware encoder selection](https://github.com/obsproject/obs-studio/blob/master/frontend/utility/SimpleOutput.cpp)
