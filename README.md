# RehaBot v1.0 – Control Dashboard GUI

GUI application for controlling **RehaBot v1.0**.

## Requirements
- Python 3.8
- Create a virtual environment
- Install dependencies from `requirements.txt`

```bash
python -m venv venv
source venv/bin/activate      # Linux / macOS
venv\Scripts\activate         # Windows
pip install -r requirements.txt
````

## Installation Notes

### Linux

If you encounter the error:

```
sounddevice OSError: PortAudio library not found
```

Install PortAudio:

```bash
sudo apt-get install libportaudio2
```

### Windows

If you get PortAudio / sounddevice errors, install the pre-built PortAudio binary:

1. Download the latest **PortAudio** installer:
   [https://www.portaudio.com/download.html](https://www.portaudio.com/download.html)
2. Install it, then reinstall sounddevice:

```bash
pip install --force-reinstall sounddevice
```

## Run the Application

```bash
python main.py
```