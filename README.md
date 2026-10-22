[README.md](https://github.com/user-attachments/files/33802855/README.md)
# Face Retouch Detection (C++)

AI-based detector that classifies a portrait photo as **Original** (no beauty retouch) or **Beautified** (beauty / face-retouch processing).

This repository is a ready-to-run **Windows x64** package: executable, OpenCV/runtime DLLs, ONNX/TFLite models, and a batch helper script. No Python install is required for normal use.

---

## Project Overview

Users provide a portrait image (typically an ID / passport-style photo). The program:

1. Loads detection and classification models from the `models` directory
2. Detects a face and runs a retouch classifier
3. Outputs a label corresponding to **original** or **beautified**

Batch mode copies images into labeled output folders and writes a CSV summary. Source images are not modified in place.

---

## Features

- Single-image classification via CLI (`--image`)
- Batch folder classification via CLI (`--src` / `--out`) or `batch_detect.bat`
- Copies results into output subfolders (does not overwrite originals)
- Ships with bundled DLLs and model files for offline use on Windows

**Note:** Console help text and some UI strings inside `face_retouch_detect.exe` are still in Chinese (compiled into the binary). Folder names created in batch output are also Chinese (see [Input and Output](#input-and-output)).

---

## Technology Stack

| Component | Details |
|-----------|---------|
| Language / runtime | C++ Windows executable (`face_retouch_detect.exe`) |
| Vision | OpenCV 4 (`opencv_*4.dll`) |
| Models | ONNX, TFLite, custom `.bin` MLP weights; optional `.pth` source weights present in tree |
| Config | `models/config.json` |
| Platform | **64-bit Windows** (confirmed by shipped binaries and original docs) |

Source code (`.cpp` / `.h`) is **not included** in this package. Only the prebuilt binary and dependencies are provided.

---

## Project Structure

```text
face-retouch-detect-cpp/
├── face_retouch_detect.exe   # Main CLI program
├── batch_detect.bat          # Interactive batch helper
├── README.md                 # This file (English)
├── USAGE_zh.md               # Original Chinese usage notes (preserved)
├── *.dll                     # OpenCV, image codecs, MSVC runtime, etc.
└── models/
    ├── config.json           # Runtime configuration
    ├── face_retouch.onnx     # Main retouch classifier (referenced by config)
    ├── face_detection_yunet_2023mar.onnx
    ├── face_landmark.tflite
    ├── branch_*.onnx         # Branch models used by the pipeline
    ├── mlp_*.bin             # MLP weight blobs
    └── ...                   # Additional model assets (kept for completeness)
```

---

## Models and Dependencies

### Models referenced by the executable / config (keep these names)

From `models/config.json` and strings embedded in the binary:

| File | Role |
|------|------|
| `config.json` | Thresholds, class names, model filenames |
| `face_retouch.onnx` | Main classifier (`onnx_model`) |
| `face_detection_yunet_2023mar.onnx` | Face detection |
| `face_landmark.tflite` | Face landmarks |
| `branch_texture.onnx` | Texture branch (referenced in binary) |
| `mlp_geom_0.bin`, `mlp_geom_1.bin` | Geometry MLP |
| `mlp_extra_0.bin`, `mlp_extra_1.bin` | Extra-feature MLP |
| `mlp_fuse_0.bin`, `mlp_fuse_1.bin` | Fusion MLP |

Also present under `models/` (do not delete; exact runtime use is **to be confirmed** if not listed above):

- `branch_extra.onnx`, `branch_fusion.onnx`, `branch_geom.onnx`
- `face_detection_short_range.onnx` / `.tflite`
- `face_landmark_with_attention.tflite`
- `best_face_retouch_model.pth`

Optional MediaPipe bridge path (not shipped in this package):

- On startup the program looks for `tools/mp_bridge_server.py`
- If missing, it logs that the MediaPipe bridge was not found and falls back to **YuNet** face detection (`face_detection_yunet_2023mar.onnx`)
- Environment variables referenced by the binary: `FACE_RETOUCH_PYTHON`, `FACE_RETOUCH_DEBUG` (exact behavior **to be confirmed**)
- Other optional names seen in the binary (`face_retouch_mp_lms.bin`, `face_retouch_mp_models`) are **not** present in this tree

### Runtime DLLs (keep these names)

Shipped next to the executable, including but not limited to:

- OpenCV: `opencv_core4.dll`, `opencv_imgproc4.dll`, `opencv_imgcodecs4.dll`, `opencv_dnn4.dll`, `opencv_objdetect4.dll`, and related modules
- Image codecs: `jpeg62.dll`, `libpng16.dll`, `libwebp*.dll`, `tiff.dll`, `liblzma.dll`, `z.dll`, …
- Protobuf / Abseil: `libprotobuf.dll`, `abseil_dll.dll`
- MSVC runtime: `msvcp140.dll`, `vcruntime140.dll`, `vcruntime140_1.dll`, `concrt140.dll`, `vcomp140.dll`

---

## Requirements

- **OS:** 64-bit Windows
- **No Python** required for the default C++ workflow
- If a DLL is missing at runtime, install the [Microsoft Visual C++ Redistributable (x64)](https://learn.microsoft.com/en-us/cpp/windows/latest-supported-vc-redist)
- Keep the executable, DLLs, and `models` folder in the same layout (do not scatter files)

---

## Installation and Setup

1. Copy or clone this folder to any path, e.g. `D:\face-retouch-detect-cpp`
2. Do **not** rename model files, DLLs, the executable, or `models/config.json` unless you have verified all references
3. Open PowerShell or Command Prompt in that folder

Optional: double-click `batch_detect.bat` for guided batch paths.

---

## Usage

### Single image

```powershell
.\face_retouch_detect.exe --models .\models --image "C:\path\to\photo.jpg"
```

### Batch folder

```powershell
.\face_retouch_detect.exe --models .\models --src "C:\path\to\input_folder" --out "C:\path\to\output_folder"
```

### Interactive batch script

```powershell
.\batch_detect.bat
```

You will be prompted for the input folder and output folder. If the output path is left empty, the default is `<input_folder>_results`.

### Help

```powershell
.\face_retouch_detect.exe --help
```

---

## Input and Output

### Input

- Portrait images (docs recommend **white / light background ID-style photos**)
- Supported extensions observed in the binary / docs: at least `.jpg`, `.png` (other formats depend on OpenCV codecs shipped with the package — **to be confirmed** for every format)

### Output (batch mode)

Images are **copied** into subfolders under `--out`:

| Folder / file (as created by the exe) | Meaning |
|----------------------------------------|---------|
| `原图\` | Classified as original (no retouch) |
| `美颜\` | Classified as beautified / retouched |
| `检测失败\` | Failed to read the image or detect a face |
| `识别结果.csv` | Per-image result details |

These Chinese folder and CSV names are **hardcoded in the executable** and were not renamed, to avoid breaking behavior without source code.

Class names in `config.json`: `"original"`, `"beautified"`.

### Output (single-image mode)

Console prediction for one image (exact field layout depends on the binary; see program stdout).

---

## Limitations

- Optimized for ID / passport-style photos on light backgrounds; casual photos, multiple faces, or profile views may be inaccurate or fail
- First run may be slower than later runs (normal cold start)
- No C++ source code in this repository — UI language and output folder names cannot be changed without rebuilding from source
- `models/config.json` includes a `source_weights` field (relative: `best_face_retouch_model.pth`) for documentation of the PyTorch source weights; the C++ binary does not load `.pth` at runtime (uses ONNX and related assets)
- MediaPipe Python bridge (`tools/mp_bridge_server.py`) is not included; runtime falls back to YuNet (verified on this machine)
- Single-image mode may exit with a non-zero code when detection fails (observed exit code `2` on a blank test image)

---

## License

This project is released under the [MIT License](LICENSE).

Third-party binaries and model assets (OpenCV DLLs, MSVC runtime, ONNX/TFLite weights, etc.) remain under their respective licenses; see the notice in `LICENSE`.

---

## Changelog (packaging / docs)

- Renamed project folder to `face-retouch-detect-cpp`
- Renamed batch helper to `batch_detect.bat` (English prompts)
- Preserved original Chinese notes as `USAGE_zh.md`
- Added this English `README.md`
- Left all models, DLLs, the executable, and `config.json` filenames unchanged
