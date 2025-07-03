# LV-Compress

LV-Compress is a **high-performance point cloud compression tool** designed for **fast storage and efficient processing** of lidar and 3D scan data.  
The project focuses on **multi-format support**, **GPU-accelerated compression**, and **seamless integration with GIS tools**.

## Features
- ✅ **Support for multiple formats**: LAS, LAZ, E57, PLY, XYZ
- ✅ **Fast compression using PDAL (Phase 1)**
- ✅ **Custom GPU-accelerated compression (Future Phase)**
- ✅ **Multi-platform support**: Windows, Linux (WSL), macOS

## Installation
### **Windows**
```powershell
.\setup.ps1

### **Linux**
chmod +x setup.sh
./setup.sh

## **Usage**
lv-compress convert input.las output.laz
