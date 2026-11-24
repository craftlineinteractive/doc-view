// Compile-time feature flags gating upcoming roadmap phases.

/// Enables subscription management and premium surfaces (Phase G7).
const bool premiumEnabled = true;

/// When enabled, tools check premium subscription before allowing edits (Phase G7).
const bool premiumGatingRequiresProduct = true;
const bool widgetsEnabled = false;

/// Enables Convert-to-Word action in PDF reader (Phase G6).
const bool conversionsEnabled = true;

/// Enables Create PDF blank document/template tool (Phase G4b).
const bool createPdfEnabled = true;

/// Enables Recycle bin tool (Phase G4c).
const bool recycleBinEnabled = true;

/// Enables PDF annotation tool (Phase G5).
const bool annotateEnabled = true;

/// Enables PDF Add Text tool (Phase G5).
const bool addTextEnabled = true;

/// Enables PDF Signature tool (Phase G5).
const bool signEnabled = true;
const bool signPdfEnabled = true;
