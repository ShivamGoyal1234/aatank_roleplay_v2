# 📦 TStudio ZMapData - Interior & Compatibility Management

A comprehensive FiveM resource for managing interior configurations, entity sets, and automatic compatibility patches for TStudio map resources.

## 🚀 Features

- **Interior Management**: Automated interior blocking and entity set configuration
- **Compatibility Patches**: Intelligent patch system for map combinations
- **Floor Management**: Dynamic floor loading for multi-level interiors
- **Privacy Controls**: Interactive privacy glass controls
- **Debug Support**: Comprehensive debugging tools

## 🔧 Server Requirements

Before installation, ensure your server meets these requirements:

| Requirement | Minimum Version |
|-------------|----------------|
| **FXServer Artifact** | `7290` or higher |
| **Game Build** | `3258` or higher |
| **Recommended** | txAdmin for resource management |

---

## 🔧 Configuration

### Supported Map Combinations

This resource automatically detects and applies compatibility patches for:

#### TStudio Maps
- Mission Row Park combinations
- Opium Nights integrations
- Legion Square compatibility
- Tropical Heights support
- Pillbox Medical combinations

#### Third-Party Maps
- **Kiiya MRPD**: Comprehensive compatibility with all TStudio maps
- **Fiv3Devs**: Pillbox and other map integrations
- **FM Maps**: MRPD compatibility patches

### Interior Blocking

Automatically blocks conflicting default GTA interiors:
- Fleeca Banks (6 locations)
- Ammunation stores (11 locations)
- Tattoo parlors (4 locations)

---

## 📦 Installation Steps

### 1. Prepare Resource Folders

Create the following folder structure in your `resources` directory:

```
resources/
├── [tstudio_maps]/
└── [_tstudio_maps_patches]/
```


### 2. Install Resources

- **Drag and drop** all `tstudio_*` resources into `[tstudio_maps]/` folder
- **Drag and drop** all `tstudio_zpatch_*` resources into `[_tstudio_maps_patches]/` folder

### 3. Configure server.cfg

Add this line to your `server.cfg`:

```cfg
ensure [tstudio_maps]
```

### 4. Finalize Installation

1. **Clear your server cache** after installation
2. **Restart your server**

> ⚠️ **Important:** Do not manually start the patches folder - our system handles this automatically!

---

## 🔄 Update Process

Follow these steps to update your resources:

1. **Delete** old `tstudio_*` resources
2. **Replace** with new versions
3. **Clear** server cache
4. **Restart** server

---

## � Performance Tips

### Load Order Priority
- Load `tstudio_zmapdata` and `tstudio_audioocclusion` **first**
- Maintain original file structure
- Test on development server before production deployment

### Best Practices
- ✅ Keep original filenames and folder structure
- ✅ Clear cache after each update
- ✅ Use txAdmin for easier management
- ❌ Don't rename resources or files
- ❌ Don't modify folder structure

---

## 🆘 Support & Community

Need help? Join our community:

[![Discord](https://img.shields.io/badge/Discord-Join%20Server-7289da?style=for-the-badge&logo=discord&logoColor=white)](https://discord.gg/tstudio)

**🌐 Official Discord:** [https://discord.gg/tstudio](https://discord.gg/tstudio)

---

<div align="center">

**Made with ❤️ by TStudio**

</div>