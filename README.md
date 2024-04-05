# Worker fleet
Definitions for the framework that runs on devices enrolled in FLOTO


The instructions below assume the balena CLI has been aliased to `floto`.

## Build and push new release
```
floto build --fleet admin/floto-k3s
floto deploy admin/floto-k3s
```

## Configuring release
Devices initially need to be configured to communicate to a k3s control plane.
This requires a k3s token (from `k3s token create`). Then set this inside the
framework with:

```
floto env add K3S_TOKEN "<token>" --fleet admin/floto-k3s
floto env add K3S_URL "<url>" --fleet admin/floto-k3s
```

