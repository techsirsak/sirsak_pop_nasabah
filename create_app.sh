#!/bin/bash

# Build script for Sirsak PoP - supports Android (AAB/APK), iOS, and Web builds
# Builds development and/or production flavors for selected platforms

set -e  # Exit on error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
BUILD_PLATFORM="all"  # android, ios, web, mobile, or all
BUILD_TYPE="both"  # aab, apk, or both (Android only)
BUILD_FLAVOR="both"  # dev, prod, or both

# Function to display help
show_help() {
  echo "Usage: $0 [OPTIONS]"
  echo ""
  echo "Build application for Android (AAB/APK), iOS, and/or Web platforms."
  echo ""
  echo "Options:"
  echo "  -p, --platform PLATFORM  Build platform: 'android', 'ios', 'web', 'mobile', or 'all' (default: all)"
  echo "                           'mobile' builds Android AAB + iOS IPA (store releases)"
  echo "  -t, --type TYPE          Build type (Android only): 'aab', 'apk', or 'both' (default: both)"
  echo "  -f, --flavor FLAVOR      Build flavor: 'dev', 'prod', or 'both' (default: both)"
  echo "  -h, --help              Show this help message"
  echo ""
  echo "Examples:"
  echo "  $0                                        # Build everything (Android AAB+APK, iOS, and Web for both flavors)"
  echo "  $0 --platform mobile                      # Build mobile only (Android AAB + iOS IPA) for both flavors"
  echo "  $0 --platform mobile -f prod              # Build production mobile only (Android AAB + iOS IPA)"
  echo "  $0 --platform web                         # Build Web only for both flavors"
  echo "  $0 --platform ios                         # Build iOS only for both flavors"
  echo "  $0 --platform android --type apk          # Build Android APK only for both flavors"
  echo "  $0 -p android -t aab -f prod              # Build production Android AAB only"
  echo "  $0 -p ios -f prod                         # Build production iOS only"
  echo "  $0 -p web -f dev                          # Build development Web only"
  echo ""
  exit 0
}

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    -p|--platform)
      BUILD_PLATFORM="$2"
      if [[ ! "$BUILD_PLATFORM" =~ ^(android|ios|web|mobile|all)$ ]]; then
        echo -e "${RED}Error: Invalid platform '$BUILD_PLATFORM'. Must be 'android', 'ios', 'web', 'mobile', or 'all'${NC}"
        exit 1
      fi
      shift 2
      ;;
    -t|--type)
      BUILD_TYPE="$2"
      if [[ ! "$BUILD_TYPE" =~ ^(aab|apk|both)$ ]]; then
        echo -e "${RED}Error: Invalid build type '$BUILD_TYPE'. Must be 'aab', 'apk', or 'both'${NC}"
        exit 1
      fi
      shift 2
      ;;
    -f|--flavor)
      BUILD_FLAVOR="$2"
      if [[ ! "$BUILD_FLAVOR" =~ ^(dev|prod|both)$ ]]; then
        echo -e "${RED}Error: Invalid flavor '$BUILD_FLAVOR'. Must be 'dev', 'prod', or 'both'${NC}"
        exit 1
      fi
      shift 2
      ;;
    -h|--help)
      show_help
      ;;
    *)
      echo -e "${RED}Error: Unknown option '$1'${NC}"
      echo "Use --help for usage information"
      exit 1
      ;;
  esac
done

# Check for environment configuration files
if [ ! -f "env.dev.json" ]; then
  echo -e "${RED}Error: env.dev.json file not found${NC}"
  echo "Please create env.dev.json from env.example.json"
  exit 1
fi

if [ ! -f "env.prod.json" ]; then
  echo -e "${RED}Error: env.prod.json file not found${NC}"
  echo "Please create env.prod.json from env.example.json"
  exit 1
fi

# Determine what to build
BUILD_DEV=false
BUILD_PROD=false
BUILD_ANDROID=false
BUILD_IOS=false
BUILD_WEB=false
BUILD_AAB=false
BUILD_APK=false

if [[ "$BUILD_FLAVOR" == "dev" ]] || [[ "$BUILD_FLAVOR" == "both" ]]; then
  BUILD_DEV=true
fi

if [[ "$BUILD_FLAVOR" == "prod" ]] || [[ "$BUILD_FLAVOR" == "both" ]]; then
  BUILD_PROD=true
fi

if [[ "$BUILD_PLATFORM" == "android" ]] || [[ "$BUILD_PLATFORM" == "mobile" ]] || [[ "$BUILD_PLATFORM" == "all" ]]; then
  BUILD_ANDROID=true
fi

if [[ "$BUILD_PLATFORM" == "ios" ]] || [[ "$BUILD_PLATFORM" == "mobile" ]] || [[ "$BUILD_PLATFORM" == "all" ]]; then
  BUILD_IOS=true
fi

if [[ "$BUILD_PLATFORM" == "web" ]] || [[ "$BUILD_PLATFORM" == "all" ]]; then
  BUILD_WEB=true
fi

# For mobile platform, only build AAB (not APK) - store releases only
if [[ "$BUILD_PLATFORM" == "mobile" ]]; then
  BUILD_AAB=true
  BUILD_APK=false
elif [[ "$BUILD_TYPE" == "aab" ]] || [[ "$BUILD_TYPE" == "both" ]]; then
  BUILD_AAB=true
fi

if [[ "$BUILD_PLATFORM" != "mobile" ]]; then
  if [[ "$BUILD_TYPE" == "apk" ]] || [[ "$BUILD_TYPE" == "both" ]]; then
    BUILD_APK=true
  fi
fi

# Calculate total steps
TOTAL_STEPS=0

# Android steps
if [ "$BUILD_ANDROID" = true ]; then
  if [ "$BUILD_DEV" = true ]; then
    [ "$BUILD_AAB" = true ] && ((TOTAL_STEPS++))
    [ "$BUILD_APK" = true ] && ((TOTAL_STEPS++))
  fi
  if [ "$BUILD_PROD" = true ]; then
    [ "$BUILD_AAB" = true ] && ((TOTAL_STEPS++))
    [ "$BUILD_APK" = true ] && ((TOTAL_STEPS++))
  fi
fi

# iOS steps
if [ "$BUILD_IOS" = true ]; then
  [ "$BUILD_DEV" = true ] && ((TOTAL_STEPS++))
  [ "$BUILD_PROD" = true ] && ((TOTAL_STEPS++))
fi

# Web steps
if [ "$BUILD_WEB" = true ]; then
  [ "$BUILD_DEV" = true ] && ((TOTAL_STEPS++))
  [ "$BUILD_PROD" = true ] && ((TOTAL_STEPS++))
fi

CURRENT_STEP=0
BUILT_FILES=()

echo "=========================================="
echo "Building Sirsak POP App"
echo "=========================================="
echo -e "${BLUE}Build Configuration:${NC}"
echo "  Platform: $([ "$BUILD_ANDROID" = true ] && echo -n "Android " || echo -n "")$([ "$BUILD_IOS" = true ] && echo -n "iOS " || echo -n "")$([ "$BUILD_WEB" = true ] && echo "Web" || echo "")"
if [ "$BUILD_ANDROID" = true ]; then
  echo "  Android Type: $([ "$BUILD_AAB" = true ] && echo -n "AAB " || echo -n "")$([ "$BUILD_APK" = true ] && echo "APK" || echo "")"
fi
echo "  Flavor: $([ "$BUILD_DEV" = true ] && echo -n "Development " || echo -n "")$([ "$BUILD_PROD" = true ] && echo "Production" || echo "")"
echo "  Total steps: $TOTAL_STEPS"
echo ""

# Function to build AAB
build_aab() {
  local flavor=$1
  local flavor_name=$2
  local target=$3
  local dart_defines_file=$4

  ((CURRENT_STEP++))
  echo -e "${YELLOW}[$CURRENT_STEP/$TOTAL_STEPS] Building $flavor_name Android AAB...${NC}"
  echo "Flavor: $flavor"
  echo "Target: $target"
  echo "Environment config: $dart_defines_file"
  echo ""

  fvm flutter build appbundle \
    --flavor "$flavor" \
    --target "$target" \
    --release \
    --dart-define-from-file="$dart_defines_file" \
    --no-tree-shake-icons

  if [ $? -eq 0 ]; then
    local output_file="build/app/outputs/bundle/${flavor}Release/app-${flavor}-release.aab"
    echo -e "${GREEN}✓ $flavor_name Android AAB built successfully${NC}"
    echo "Location: $output_file"
    BUILT_FILES+=("$output_file")
  else
    echo -e "${RED}✗ $flavor_name Android AAB build failed${NC}"
    exit 1
  fi

  echo ""
}

# Function to build APK
build_apk() {
  local flavor=$1
  local flavor_name=$2
  local target=$3
  local dart_defines_file=$4

  ((CURRENT_STEP++))
  echo -e "${YELLOW}[$CURRENT_STEP/$TOTAL_STEPS] Building $flavor_name Android APK...${NC}"
  echo "Flavor: $flavor"
  echo "Target: $target"
  echo "Environment config: $dart_defines_file"
  echo ""

  fvm flutter build apk \
    --flavor "$flavor" \
    --target "$target" \
    --release \
    --dart-define-from-file="$dart_defines_file" \
    --no-tree-shake-icons

  if [ $? -eq 0 ]; then
    local output_file="build/app/outputs/flutter-apk/app-${flavor}-release.apk"
    echo -e "${GREEN}✓ $flavor_name Android APK built successfully${NC}"
    echo "Location: $output_file"
    BUILT_FILES+=("$output_file")
  else
    echo -e "${RED}✗ $flavor_name Android APK build failed${NC}"
    exit 1
  fi

  echo ""
}

# Function to build iOS
build_ios() {
  local flavor=$1
  local flavor_name=$2
  local target=$3
  local dart_defines_file=$4

  ((CURRENT_STEP++))
  echo -e "${YELLOW}[$CURRENT_STEP/$TOTAL_STEPS] Building $flavor_name iOS...${NC}"
  echo "Flavor: $flavor"
  echo "Target: $target"
  echo "Environment config: $dart_defines_file"
  echo ""

  fvm flutter build ipa \
    --flavor "$flavor" \
    --target "$target" \
    --release \
    --dart-define-from-file="$dart_defines_file" \
    --no-tree-shake-icons

  if [ $? -eq 0 ]; then
    local output_dir="build/ios/ipa"
    local ios_output_base="build/app/outputs/ios"
    local flavor_output_dir="${ios_output_base}/${flavor}Release"

    # Create output directory if it doesn't exist
    mkdir -p "$ios_output_base"

    # Remove old flavor build if exists
    [ -d "$flavor_output_dir" ] && rm -rf "$flavor_output_dir"

    # Move to flavor-specific directory
    mv "$output_dir" "$flavor_output_dir"

    echo -e "${GREEN}✓ $flavor_name iOS IPA built successfully${NC}"
    echo "Location: $flavor_output_dir/"
    BUILT_FILES+=("$flavor_output_dir/")
  else
    echo -e "${RED}✗ $flavor_name iOS build failed${NC}"
    exit 1
  fi

  echo ""
}

# Function to build Web
build_web() {
  local flavor=$1
  local flavor_name=$2
  local target=$3
  local dart_defines_file=$4

  ((CURRENT_STEP++))
  echo -e "${YELLOW}[$CURRENT_STEP/$TOTAL_STEPS] Building $flavor_name Web...${NC}"
  echo "Flavor: $flavor"
  echo "Target: $target"
  echo "Environment config: $dart_defines_file"
  echo ""

  fvm flutter build web \
    --target "$target" \
    --release \
    --dart-define-from-file="$dart_defines_file" \
    --no-tree-shake-icons

  if [ $? -eq 0 ]; then
    local output_dir="build/web"
    # Rename output directory to include flavor
    local flavor_output_dir="build/web-${flavor}"

    # Remove old flavor build if exists
    [ -d "$flavor_output_dir" ] && rm -rf "$flavor_output_dir"

    # Move to flavor-specific directory
    mv "$output_dir" "$flavor_output_dir"

    echo -e "${GREEN}✓ $flavor_name Web built successfully${NC}"
    echo "Location: $flavor_output_dir/"
    BUILT_FILES+=("$flavor_output_dir/")
  else
    echo -e "${RED}✗ $flavor_name Web build failed${NC}"
    exit 1
  fi

  echo ""
}

# Build Android Development builds
if [ "$BUILD_ANDROID" = true ] && [ "$BUILD_DEV" = true ]; then
  if [ "$BUILD_AAB" = true ]; then
    build_aab "development" "Development" "lib/main/main_development.dart" "env.dev.json"
    echo "=========================================="
    echo ""
  fi

  if [ "$BUILD_APK" = true ]; then
    build_apk "development" "Development" "lib/main/main_development.dart" "env.dev.json"
    echo "=========================================="
    echo ""
  fi
fi

# Build Android Production builds
if [ "$BUILD_ANDROID" = true ] && [ "$BUILD_PROD" = true ]; then
  if [ "$BUILD_AAB" = true ]; then
    build_aab "production" "Production" "lib/main/main_production.dart" "env.prod.json"
    echo "=========================================="
    echo ""
  fi

  if [ "$BUILD_APK" = true ]; then
    build_apk "production" "Production" "lib/main/main_production.dart" "env.prod.json"
    echo "=========================================="
    echo ""
  fi
fi

# Build iOS Development build
if [ "$BUILD_IOS" = true ] && [ "$BUILD_DEV" = true ]; then
  build_ios "development" "Development" "lib/main/main_development.dart" "env.dev.json"
  echo "=========================================="
  echo ""
fi

# Build iOS Production build
if [ "$BUILD_IOS" = true ] && [ "$BUILD_PROD" = true ]; then
  build_ios "production" "Production" "lib/main/main_production.dart" "env.prod.json"
  echo "=========================================="
  echo ""
fi

# Build Web Development build
if [ "$BUILD_WEB" = true ] && [ "$BUILD_DEV" = true ]; then
  build_web "development" "Development" "lib/main/main_development.dart" "env.dev.json"
  echo "=========================================="
  echo ""
fi

# Build Web Production build
if [ "$BUILD_WEB" = true ] && [ "$BUILD_PROD" = true ]; then
  build_web "production" "Production" "lib/main/main_production.dart" "env.prod.json"
  echo "=========================================="
  echo ""
fi

# Final summary
echo "=========================================="
echo -e "${GREEN}All builds completed successfully!${NC}"
echo "=========================================="
echo ""
echo "Output files:"
for file in "${BUILT_FILES[@]}"; do
  echo "  $file"
done
echo ""
