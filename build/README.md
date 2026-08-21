# Build

This directory is used for building Lumina OS images and packages.

## Structure (planned)

```
build/
├── iso/           # Output directory for ISO images
├── chroot/        # Temporary chroot environments
├── cache/         # Package and download cache
└── logs/          # Build logs
```

The actual build process will use Debian live-build or a custom pipeline.
